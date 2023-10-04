import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:street_wyze/providers/location_controller.dart';
import 'dart:convert';

import '../models/google_place.dart';
import '../models/place.dart';

class GoogleController with ChangeNotifier {
  final String _apiKey = dotenv.env["GOOGLE_KEY"]!;
  Timer? _searchTimer;
  Timer? _typingTimer;
  String query = '';
  List<GoogleSearchedPlace> _responses = [];
  List<GoogleSearchedPlace> get responses => _responses;
  Place _startPoint = Place(lat: 0, lng: 0, formattedAddress: "");
  Place _destination = Place(lat: 0, lng: 0, formattedAddress: "");

  bool _isLoading = false;
  bool _isEmptyResponse = true;
  bool _hasResponded = false;
  bool _isSearching = true;
  String _distance = "0.0";
  String _time = "0.0";
  String _error = "0.0";

  bool get isLoading => _isLoading;
  bool get isEmptyResponse => _isEmptyResponse;
  bool get hasResponded => _hasResponded;
  bool get isSearching => _isSearching;
  String get distance => _distance;
  String get time => _time;
  String get error => _error;

  Place get startPoint => _startPoint;
  Place get destination => _destination;

  onSearchTextChanged(String value) {
    _isLoading = true;
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 1), () {
      searchHandler(value);
    });
    notifyListeners();
  }

  void searchHandler(String value) async {
    _responses.clear();
    _responses = await fetchSuggestions(value);

    _hasResponded = true;
    _isEmptyResponse = responses.isEmpty;
    _isLoading = false;

    query = value;
    if (_searchTimer?.isActive ?? false) _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () {
      _responses.clear();
    });
    notifyListeners();
  }

  void savePlace(bool isResponseForDestination, placeId) async {
    if (isResponseForDestination) {
      debugPrint("saving destination");
      _destination = await fetchPlaceDetails(placeId);
    } else {
      _startPoint = await fetchPlaceDetails(placeId);
    }
    _responses.clear();
    notifyListeners();
  }

  searchState(value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<String> saveCurrentLoc() async {
    final locData = await LocationService().getCurrentLoc();
    debugPrint("printed from start ${locData!.latitude.toString()}");
    if (locData.latitude != 0.0) {
      _startPoint = Place(
          lat: locData.latitude,
          lng: locData.longitude,
          formattedAddress: "My Location");
      notifyListeners();
      return _startPoint.formattedAddress;
    } else {
      _startPoint = Place(lat: 0.0, lng: 0.0, formattedAddress: "No Location");
      notifyListeners();
      return _startPoint.formattedAddress;
    }
  }

  void saveMarker(lat, lng, place) {
    saveCurrentLoc();
    _destination = Place(lat: lat, lng: lng, formattedAddress: place);
    _isSearching = false;
    notifyListeners();
  }

  Future<List<GoogleSearchedPlace>> fetchSuggestions(String input) async {
    const proximity = 'Western Cape, South Africa';
    final endpoint = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/autocomplete/json')
        .replace(queryParameters: {
      'input': input,
      'key': _apiKey,
      'location': proximity,
      'components': 'country:ZA'
    });

    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final predictions = json.decode(response.body)['predictions'];
      debugPrint("searching destination");
      return List<GoogleSearchedPlace>.from(
        predictions.map(
          (prediction) => GoogleSearchedPlace(
            prediction['structured_formatting']['main_text'] ?? "",
            prediction['structured_formatting']['secondary_text'] ?? "",
            prediction['place_id'] ?? "",
          ),
        ),
      );
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<Place> fetchPlaceDetails(String placeId) async {
    final detailsEndpoint =
        Uri.parse('https://maps.googleapis.com/maps/api/place/details/json')
            .replace(queryParameters: {'place_id': placeId, 'key': _apiKey});

    final detailsResponse = await http.get(detailsEndpoint);

    if (detailsResponse.statusCode == 200) {
      final result = json.decode(detailsResponse.body)['result'];
      final location = result['geometry']['location'];
      final double lat = location['lat'];
      final double lng = location['lng'];
      final formattedAddress = result['name'];
      debugPrint("we get destination");

      return Place(lat: lat, lng: lng, formattedAddress: formattedAddress);
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  Future<void> calculateDistanceAndTime(String destinationAddress) async {
    final String apiKey = _apiKey; // Replace with your Google Maps API key
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json';

    const String origin =
        '-33.916531, 18.510414'; // Replace with your current location (latitude,longitude)

    final Uri uri = Uri.parse(
        '$baseUrl?origins=$origin&destinations=$destinationAddress&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _distance = data['rows'][0]['elements'][0]['distance']['text'];
      _time = data['rows'][0]['elements'][0]['duration']['text'];

      if (kDebugMode) {
        print('Distance: $_distance');
      }
      if (kDebugMode) {
        print('Drive Time: $_time');
      }
    } else {
      _error = "failed to compute";
      throw Exception('Failed to load data');
    }
    notifyListeners();
  }
}
