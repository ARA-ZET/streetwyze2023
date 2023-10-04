import 'dart:math';

import 'package:flutter/material.dart';
import 'package:street_wyze/models/activity.dart';
import 'package:street_wyze/models/activity_type.dart';

import 'package:street_wyze/models/cuisine_set.dart';
import 'package:street_wyze/models/user_location.dart';
import 'package:street_wyze/providers/location_controller.dart';

import '../models/restaurant.dart';
import '../models/search_place.dart';
import '../models/station.dart';
import '../services/file_manager.dart';

class FileController with ChangeNotifier {
  List<Station> _polyList = [];
  SearchedPlace _origin = SearchedPlace("", "", "", []);
  SearchedPlace _destination = SearchedPlace("", "", "", []);
  List<Restaurant> _restaurantList = [];
  List<Restaurant> _filteredRestaurants = [];
  String _currentCuisine = "All Restaurance";
  List<CuisineSet> _cuisineSorted = [];
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  String _currentCActivity = "All Activities";
  List<TypeSet> _typeSorted = [];

  UserLocation currentloc = LocationService().userLoc;

  List<Station> get polyList => _polyList;
  SearchedPlace get origin => _origin;
  SearchedPlace get destination => _destination;
  List<Restaurant> get restaurantList => _restaurantList;
  List<Restaurant> get filteredRestaurants => _filteredRestaurants;
  String get currentCuisine => _currentCuisine;
  List<Activity> get activities => _activities;
  List<Activity> get filteredActivities => _filteredActivities;
  String get currentCActivity => _currentCActivity;

  List<TypeSet> get typeSorted => _typeSorted;
  List<CuisineSet> get cuisineSorted => _cuisineSorted;

  kmlFull() async {
    _polyList = await FileManager().readKmlFull();
    notifyListeners();
  }

  void createFolder(folder) async {
    FileManager().createDir(folder);

    notifyListeners();
  }

  changeOrigin(data) {
    _origin = data;
    notifyListeners();
  }

  changedestination(data) {
    _destination = data;
    notifyListeners();
  }

  loadRestaurants() async {
    final now = DateTime.now();
    final modifiedlist = await FileManager().loadRestaurantData();
    _restaurantList = modifiedlist
        .map((res) => Restaurant(
            name: res.name,
            location: res.location,
            cuisine: res.cuisine,
            about: res.about,
            restaurantInfo: res.restaurantInfo,
            website: res.website,
            parking: res.parking,
            price: calculateDistance(
              double.parse(res.coordinates.split(",")[0]),
              double.parse(res.coordinates.split(",")[1]),
              double.parse(currentloc.latitude),
              double.parse(currentloc.longitude),
            ).toString(),
            coordinates: res.coordinates))
        .toList();
    _restaurantList.sort((a, b) => a.price.compareTo(b.price));
    _filteredRestaurants = _restaurantList;
    final then = DateTime.now();
    debugPrint(then.difference(now).toString());

    notifyListeners();
    return _restaurantList;
  }

  loadActivities() async {
    final now = DateTime.now();
    final modifiedlist = await FileManager().loadActivitieaData();
    _activities = modifiedlist
        .map((res) => Activity(
              name: res.name,
              type: res.type,
              location: res.location,
              address: res.address,
              priceRange: res.priceRange,
              duration: res.duration,
              operatingHours: res.operatingHours,
              bookingRequired: res.bookingRequired,
              info: res.info,
              contact: res.contact,
              website: res.website,
              coordinates: res.coordinates,
            ))
        .toList();
    // _activities.sort((a, b) => a.price.compareTo(b.price));
    _filteredActivities = _activities;
    final then = DateTime.now();
    debugPrint(then.difference(now).toString());

    notifyListeners();
    return _activities;
  }

  sortCuisines() async {
    final cuisinesList =
        _restaurantList.map((restaurant) => restaurant.cuisine).toList();
    final cuisinesSet = cuisinesList.toSet();

    _cuisineSorted = cuisinesSet
        .map((cuisine) => CuisineSet(
            cuisine: cuisine,
            quantity: cuisinesList.where((word) => word == cuisine).length))
        .toList();
    _cuisineSorted.sort((a, b) => b.quantity.compareTo(a.quantity));
    notifyListeners();
  }

  sortType() async {
    final typeList = _activities.map((activity) => activity.type).toList();
    final typeSet = typeList.toSet();

    _typeSorted = typeSet
        .map((type) => TypeSet(
            type: type,
            quantity: typeList.where((word) => word == type).length))
        .toList();
    _typeSorted.sort((a, b) => b.quantity.compareTo(a.quantity));
    notifyListeners();
  }

  List<Restaurant> filterRestaurants(String cuisine) {
    if (cuisine == "All") {
      _filteredRestaurants = _restaurantList;
      _currentCuisine = "All Restaurants";
    } else {
      _filteredRestaurants = _restaurantList
          .where((restaurant) => restaurant.cuisine.contains(cuisine))
          .toList();
      _currentCuisine = "$cuisine Restaurants";
    }
    notifyListeners();
    return _filteredRestaurants;
  }

  List<Activity> filterActivities(String type) {
    if (type == "All") {
      _filteredActivities = _activities;
      _currentCActivity = "All Activities";
    } else {
      _filteredActivities = _activities
          .where((activity) => activity.type.contains(type))
          .toList();
      _currentCActivity = type;
    }
    notifyListeners();
    return _filteredActivities;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6372.8; // In kilometers

    double toRadians(double degree) {
      return degree * pi / 180;
    }

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }
}
