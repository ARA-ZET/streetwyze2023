import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/screens/play_wyze_map.dart';
import 'package:street_wyze/services/notification_service.dart';
import 'landing_page.dart';
import 'eay_wyze_map.dart';
import 'notifications.dart';
import '../providers/bitmap_provider.dart';
import '../providers/file_controller.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.root});

  final int root;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final notificationService = NotificationsService();
  // list of pages show at the bottom navbar
  List<Widget> pages = [
    const HomePage(),
    const PlayWyzeMap(),
    const EatwyzeMap(),
    const NotificationPage(),
  ];
  // list of colors to show based on index
  List<Color> color = [
    Colors.green,
    const Color.fromARGB(255, 0, 121, 220),
    Colors.green,
    Colors.blueGrey
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.root;
      notificationService.firebaseNotification(context);
    });

    // Delay the initialization logic to the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FileController>(context, listen: false).kmlFull();
      Provider.of<FileController>(context, listen: false).loadRestaurants();
      Provider.of<FileController>(context, listen: false).sortCuisines();
      Provider.of<FileController>(context, listen: false).loadActivities();
      Provider.of<FileController>(context, listen: false).sortType();
      Provider.of<BitMapDis>(context, listen: false).customBits();
    });
  }

// change index when toggle
  void onTap(int index) async {
    setState(() {
      if (index != widget.root) {
        currentIndex = index;
      } else {
        currentIndex = widget.root;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 99, 209, 15),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: color[currentIndex],
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.hiking), label: "Play Wyze"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Eat Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
    );
  }
}
