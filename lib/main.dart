import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/firebase_options.dart';
import 'package:street_wyze/providers/bitmap_provider.dart';
import 'package:street_wyze/providers/file_controller.dart';
import 'package:street_wyze/providers/google_maps_controller.dart';
import 'package:street_wyze/providers/location_controller.dart';
import 'package:street_wyze/providers/mapbox_controller.dart';
import 'package:street_wyze/screens/wrapper.dart';
import 'package:street_wyze/services/auth_service.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'models/user_location.dart';
import 'providers/firebase_controller.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await dotenv.load(fileName: "assets/config/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FileController()),
    ChangeNotifierProvider(create: (_) => BitMapDis()),
    ChangeNotifierProvider(create: (_) => GoogleController()),
    ChangeNotifierProvider(create: (_) => TravelWyzeController()),
    ChangeNotifierProvider(create: (_) => FirebaseProvider()),
    ChangeNotifierProvider(
      create: (_) => LocationService(),
    ),
    StreamProvider(
      initialData: UserLocation("0.0", "0.0", "0.0", "0.0", "0.0", "0.0"),
      create: (_) => LocationService().locationStream,
    ),
    StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}
