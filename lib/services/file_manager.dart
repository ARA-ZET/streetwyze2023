import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:street_wyze/models/activity.dart';
import 'package:xml/xml.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
// import '../models/saved_file,dart';

class FileManager {
  static FileManager? _instance;
  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  gpxconverttrk(dname, List<Wpt> points) {
    // create gpx-xml from object
    final gpx = Gpx();

    gpx.version = '1.1';
    gpx.creator = 'dart-gpx library';
    gpx.metadata = Metadata();
    gpx.metadata?.name = 'Movements of distributors';
    gpx.metadata?.desc = 'recording movements of distributors';
    gpx.metadata?.time = DateTime.now();
    gpx.trks = [
      Trk(name: dname, trksegs: [Trkseg(trkpts: points)])
    ];
    // get GPX string
    final gpxString = GpxWriter().asString(gpx, pretty: true);
    return gpxString;
  }

  Future<String> get _directoryPath async {
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      return directory!.path;
    } else {
      Directory? directory = await getExternalStorageDirectory();
      return directory!.path;
    }
  }

  // Future<String> get _supportDirectoryPath async {
  //   Directory directory = await getApplicationSupportDirectory();
  //   return directory.path;
  // }

  Future<File> myFile(file) async {
    final path = await _directoryPath;
    return File('$path/$file');
  }

  // Future<File> _jsonSupportFiles(file) async {
  //   final supportPath = await _supportDirectoryPath;
  //   return File('$supportPath/$file');
  // }

  Future<List<Restaurant>> loadRestaurantData() async {
    String jsonData = await rootBundle.loadString('assets/dataset2.json');
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(json.decode(jsonData));
    List<Restaurant> restaurants =
        data.map((json) => Restaurant.fromJson(json)).toList();

    return restaurants;
  }

  Future<List<Activity>> loadActivitieaData() async {
    String jsonData = await rootBundle.loadString('assets/activities.json');
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(json.decode(jsonData));
    List<Activity> activities =
        data.map((json) => Activity.fromJson(json)).toList();

    return activities;
  }

  Future<List<Station>> readKmlFull() async {
    debugPrint("loading2");
    // File name = await File("assets/stations.kml");
    // final kmlString = await name.readAsString();
    final kmlString = rootBundle.loadString("assets/stations.kml");

    final document = XmlDocument.parse(await kmlString);
    final polygonElements = document.findAllElements("Placemark").toList();
    // debugPrint(polygonElements.toString());
    final polygonCoordinates = polygonElements.map((polygonElement) {
      final coordinateElements = polygonElement.findAllElements('coordinates');
      final nameElements =
          polygonElement.findAllElements('name').first.innerText;

      final coordinateString =
          coordinateElements.first.innerText.replaceAll(",0", "").trim();

      final coordinateList = coordinateString.split(' ').toList();
      coordinateList.removeWhere((element) => element.length < 2);

      // Create a list of LatLng coordinates from the coordinate string
      final coordinates = coordinateList.map((coordinate) {
        final latLngList = coordinate.split(',');
        latLngList.removeWhere((number) => number == "0");
        // debugPrint(latLngList.length.toString());

        final lng = double.tryParse(latLngList[0]);
        final lat = double.tryParse(latLngList[1]);
        return LatLng(lat!, lng!);
      }).toList();
      final stationsData = Station(nameElements.toString(), coordinates);

      return stationsData;
    }).toList();

    return polygonCoordinates;
  }

  Future<List<List<LatLng>>> readKmlFile() async {
    File name = await myFile("saps boundaries/SapsBoundary.kml");
    final kmlString = await name.readAsString();

    final document = XmlDocument.parse(kmlString);
    final polygonElements = document.findAllElements("Polygon").toList();
    // debugPrint(polygonElements.toString());
    final polygonCoordinates = polygonElements.map((polygonElement) {
      final coordinateElements = polygonElement.findAllElements('coordinates');
      final coordinateString =
          coordinateElements.first.innerText.replaceAll(",0", "").trim();

      final coordinateList = coordinateString.split(' ').toList();
      coordinateList.removeWhere((element) => element.length < 2);

      // debugPrint(coordinateList.toString());

      // Create a list of LatLng coordinates from the coordinate string
      final coordinates = coordinateList.map((coordinate) {
        final latLngList = coordinate.split(',');
        latLngList.removeWhere((number) => number == "0");
        debugPrint(latLngList.length.toString());

        final lng = double.tryParse(latLngList[0]);
        final lat = double.tryParse(latLngList[1]);
        return LatLng(lat!, lng!);
      }).toList();

      return coordinates;
    }).toList();
    debugPrint(polygonCoordinates[0].toString());
    return polygonCoordinates;
  }

  // Future<Map<String, dynamic>?> readJsonFile() async {
  //   String fileContent =
  //       '{"name": "arazetgpx", "date": "16 Jan", "cliet": "nodata", "targetarea": "nodata"}';

  //   File file = await _jsonSupportFiles("SessionData.json");
  //   if (await file.exists()) {
  //     try {
  //       fileContent = await file.readAsString();
  //       return json.decode(fileContent);
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   }

  //   return json.decode(fileContent);
  // }

  // Future<SessionData> writeJsonFile(
  //   name,
  //   date,
  //   client,
  //   cientmap,
  // ) async {
  //   final SessionData user = SessionData(
  //     name,
  //     date,
  //     client,
  //     cientmap,
  //   );

  //   File file = await _jsonSupportFiles("SessionData.json");
  //   await file.writeAsString(json.encode(user));
  //   return user;
  // }

  createDir(folder) async {
    final directoryName = folder;

    final docDir = await getExternalStorageDirectory();
    final myDir = Directory('${docDir!.path}/$directoryName');
    if (await myDir.exists()) {}
    final dir = await myDir.create(recursive: true);
    debugPrint(dir.toString());
  }
}
