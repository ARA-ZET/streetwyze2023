import 'package:flutter/material.dart';

class TravelWyzeController with ChangeNotifier {
  bool _travelWyzeState = false;
  bool get travelWyzeState => _travelWyzeState;

  void changeWyzeState(bool a) {
    _travelWyzeState = a;
    notifyListeners();
  }
}
