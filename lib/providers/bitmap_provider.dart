import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class BitMapDis with ChangeNotifier {
  late BitmapDescriptor _saps;
  late BitmapDescriptor _res;
  late BitmapDescriptor _bar;
  late BitmapDescriptor _coffee;
  late BitmapDescriptor _travel;
  late BitmapDescriptor _italian;
  late BitmapDescriptor _traditional;
  late BitmapDescriptor _activity;
  List<BitmapDescriptor> _bitList = [];

  List<BitmapDescriptor> get bitList => _bitList;
  BitmapDescriptor get sapsBit => _saps;
  BitmapDescriptor get resBit => _res;
  BitmapDescriptor get barBit => _bar;
  BitmapDescriptor get coffeeBit => _coffee;
  BitmapDescriptor get travelBit => _travel;
  BitmapDescriptor get italianBit => _italian;
  BitmapDescriptor get traditionalBit => _traditional;
  BitmapDescriptor get activityBit => _activity;

  Future<void> customBits() async {
    _saps = await customize('assets/saps.png');
    _bar = await customize('assets/bar.png');
    _coffee = await customize('assets/coffee.png');
    _italian = await customize('assets/italian.png');
    _travel = await customize('assets/travel.png');
    _res = await customize('assets/res.png');
    _traditional = await customize('assets/traditional.png');
    _activity = await customize('assets/activity.png');
    _bitList = [
      _saps,
      _bar,
      _coffee,
      _italian,
      _travel,
      _res,
      _traditional,
      _activity
    ];

    notifyListeners();
  }

  Future<BitmapDescriptor> customize(String file) async {
    ByteData imageData = await rootBundle.load(file);
    final Uint8List bytes = imageData.buffer.asUint8List();
    final output = BitmapDescriptor.fromBytes(bytes);
    notifyListeners();
    return output;
  }
}
