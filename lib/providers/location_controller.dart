import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:gpx/gpx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../models/user_location.dart';

// Location provider
class LocationService with ChangeNotifier {
  Wpt _currentLocation = Wpt();
  UserLocation _userLoc =
      UserLocation("-33.922429", "18.422410", "0.0", "0.0", "0.0", "0.0");

  Duration duration = const Duration();
  // List<Wpt> _trackpoints = [];
  Timer? timerr;

  bool _isRecording = false;
  bool _isConnected = false;
  Geolocator location = Geolocator();
  bool ignoreLastKnownPosition = false;

//broadcasting location stream
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

// get methods
  Stream<UserLocation> get locationStream => _locationController.stream;
  // List<Wpt> get trackpoints => _trackpoints;
  bool get isRecording => _isRecording;
  bool get isConnected => _isConnected;
  Wpt get currentLocation => _currentLocation;
  UserLocation get userLoc => _userLoc;
  // double get distance => _distance;

////REALTIME LOCATION SERVICE

// Get realtime location
  Future<Position?> getCurrentLoc() async {
    try {
      Geolocator.checkPermission();
      Geolocator.requestPermission();
      Position locationData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _currentLocation = Wpt(
        lat: locationData.latitude,
        lon: locationData.longitude,
        time: locationData.timestamp,
      );
      notifyListeners();

      return locationData;
    } catch (e) {}
    return null;
  }

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );
  LocationService() {
    Geolocator.requestPermission().then((granted) => {
          if (granted == granted)
            {
              Geolocator.getPositionStream(locationSettings: locationSettings)
                  .listen(
                (Position locationData) => [
                  _userLoc = UserLocation(
                    locationData.latitude.toString(),
                    locationData.longitude.toString(),
                    locationData.altitude.toString(),
                    locationData.speed.toString(),
                    locationData.timestamp.toString(),
                    locationData.accuracy.toStringAsFixed(1),
                  ),
                  _locationController.add(
                    UserLocation(
                      locationData.latitude.toString(),
                      locationData.longitude.toString(),
                      locationData.altitude.toString(),
                      locationData.speed.toString(),
                      locationData.timestamp.toString(),
                      locationData.accuracy.toStringAsFixed(1),
                    ),
                  ),
                  if (locationData.latitude.toString() != "0.0" ||
                      locationData.latitude != 0.0)
                    {_isConnected = true},
                  debugPrint(locationData.latitude.toString())
                ],
              )
            }
        });
    notifyListeners();
  }

////WORKING STATE AND LOGICS

  // Reset all the the track, timers and distance
  void resetData() {
    _isRecording = false;
    notifyListeners();
  }

  // monitoring wether device have gps connection or not
  gpsState() async {
    if (currentLocation.lat.toString() != "0.0" || currentLocation.lat != 0.0) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    final diff = DateTime.now().difference(currentLocation.time!).inSeconds;
    debugPrint(diff.toString());
    if (diff >= 60) {
      _isConnected = false;
    }

    notifyListeners();
  }
}
