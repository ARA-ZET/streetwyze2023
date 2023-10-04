import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/models/activity.dart';
import 'package:street_wyze/models/user_location.dart';
import 'package:street_wyze/providers/location_controller.dart';
import 'package:street_wyze/widgets/activity_container.dart';
import 'package:street_wyze/widgets/activity_type_view.dart';

import '../models/google_place.dart';

import '../providers/bitmap_provider.dart';
import '../providers/file_controller.dart';
import '../providers/google_maps_controller.dart';
import '../screens/about.dart';
import '../screens/travel_wyze.dart';
import '../widgets/activity_info.dart';
import '../widgets/map_wyze_button.dart';

class PlayWyzeMap extends StatefulWidget {
  const PlayWyzeMap({super.key});

  @override
  State<PlayWyzeMap> createState() => _PlayWyzeMapState();
}

class _PlayWyzeMapState extends State<PlayWyzeMap> {
  Color fill = Colors.green;
  bool layer = true;
  bool light = true;
  double containerHeight = 200.0;
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController? mapController;

  Set<Marker> _markers = {};
  bool isMapCreated = false;
  bool showLIst = false;
  bool fromUpdateMarkers = true;
  bool _isMapInitialized = false;
  String cuzine = "";
  Color mainColor = const Color.fromARGB(255, 0, 121, 220);

  void changeColor() {
    setState(() {
      fill = Colors.red;
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    // Delay the initialization logic to the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FileController>(context, listen: false).sortType();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_isMapInitialized) {
      mapController?.dispose(); // Dispose only if the map is initialized
    }

    super.dispose();
  }

  Future<List<LatLng>> fetchCoordinates(UserLocation userLocation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      LatLng(double.parse(userLocation.latitude),
          double.parse(userLocation.longitude)),
    ];
  }

  Set<Marker> generateMarkers(
    List<Activity> activities,
    BitmapDescriptor activityBit,
  ) {
    return activities.map((res) {
      BitmapDescriptor bitSelector(cuisine) {
        // Cuisine icon selection logic...
        if (cuisine.toString().toLowerCase().contains("bar")) {
          return activityBit;
        } else {
          return activityBit;
        }
      }

      return Marker(
        markerId: MarkerId(res.name),
        position: LatLng(
          double.parse(res.coordinates.split(",")[0]),
          double.parse(res.coordinates.split(",")[1]),
        ),
        icon: bitSelector(res.type),
        infoWindow: InfoWindow(title: res.name),
        consumeTapEvents: true,
        onTap: () {
          context
              .read<GoogleController>()
              .calculateDistanceAndTime(res.coordinates);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowActivityInfo(
                    name: res.name,
                    about: res.info,
                    type: res.type,
                    address: res.address,
                    website: res.website,
                    contact: res.contact,
                    lat: double.parse(res.coordinates.split(",")[0]),
                    lng: double.parse(res.coordinates.split(",")[1]));
              });
        },
      );
    }).toSet();
  }

  void updateMarkers(
    List<Activity> activities,
    BitmapDescriptor barBit,
  ) {
    setState(() {
      _markers = generateMarkers(activities, barBit);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // final saps = context.watch<BitMapDis>().sapsBit;

    final activityBit = context.watch<BitMapDis>().activityBit;

    List<GoogleSearchedPlace> suggestion =
        context.watch<GoogleController>().responses;

    List<Activity> filtrest =
        context.watch<FileController>().filteredActivities;

    late UserLocation userLocation = context.watch<LocationService>().userLoc;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const About()));
              },
              child: Text(
                String.fromCharCode(Icons.menu.codePoint),
                style: TextStyle(
                  color: mainColor,
                  fontFamily: Icons.sort_outlined.fontFamily,
                  fontSize: 40, // Adjust the size as needed
                  fontWeight: FontWeight.bold, // Increase the font weight
                ),
              ),
            ),
            Container(
              width: width * 0.63,
              height: 30,
              padding: const EdgeInsets.only(left: 12, bottom: 2, right: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: mainColor,
                    blurRadius: 1,
                  )
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: const Color.fromARGB(255, 241, 244, 251),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.48,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        // context
                        //     .read<GoogleController>()
                        //     .onSearchTextChanged(value);
                      },
                      onTapOutside: (PointerDownEvent event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 2,
                    color: mainColor,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    String.fromCharCode(Icons.search.codePoint),
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: Icons.sort_outlined.fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: light,
              activeColor: mainColor,
              onChanged: (bool value) {
                setState(() {
                  light = value;
                  layer = !layer;
                });
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(userLocation.latitude),
                    double.parse(userLocation.longitude)),
                zoom: 10.0),
            onMapCreated: (controller) {
              mapController = controller;
              isMapCreated = true;

              updateMarkers(filtrest, activityBit);
              setState(() {
                _isMapInitialized = true;
              });
            },
            markers: fromUpdateMarkers
                ? _markers
                : filtrest.map((res) {
                    BitmapDescriptor bitSelector(cuisine) {
                      // Cuisine icon selection logic...
                      if (cuisine.toString().toLowerCase().contains("bar")) {
                        return activityBit;
                      } else {
                        return activityBit;
                      }
                    }

                    return Marker(
                      markerId: MarkerId(res.name),
                      position: LatLng(
                        double.parse(res.coordinates.split(",")[0]),
                        double.parse(res.coordinates.split(",")[1]),
                      ),
                      icon: bitSelector(res.type),
                      infoWindow: InfoWindow(title: res.name),
                      consumeTapEvents: true,
                      onTap: () {
                        context
                            .read<GoogleController>()
                            .calculateDistanceAndTime(res.coordinates);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowActivityInfo(
                                  name: res.name,
                                  about: res.info,
                                  type: res.type,
                                  address: res.location,
                                  website: res.website,
                                  contact: res.contact,
                                  lat: double.parse(
                                      res.coordinates.split(",")[0]),
                                  lng: double.parse(
                                      res.coordinates.split(",")[1]));
                            });
                      },
                    );
                  }).toSet(),
          ),
          Positioned(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 6),
                  MapWyzeButton(
                    text: "  All",
                    icon: Icons.sort_sharp,
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        showLIst = !showLIst;
                        fromUpdateMarkers = false;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("All");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Wine Testing",
                    icon: Icons.wine_bar,
                    color: mainColor,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("Wine");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Museum",
                    icon: Icons.museum_sharp,
                    color: Colors.blueGrey,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("Mueseum");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Golf Course",
                    icon: Icons.golf_course_outlined,
                    color: const Color.fromARGB(255, 168, 92, 0),
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("Golf Course");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Tennis Clubs",
                    icon: Icons.sports_tennis_sharp,
                    color: mainColor,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("Tennis Clubs");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Hiking",
                    icon: Icons.hiking_outlined,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterActivities("Hiking");
                      updateMarkers(rest, activityBit);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                    border: Border.all(color: mainColor, width: 2),
                  ),
                  margin: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  width: 54,
                  height: 54,
                  child: IconButton(
                      iconSize: 36,
                      onPressed: () {
                        mapController?.animateCamera(CameraUpdate.newLatLngZoom(
                            LatLng(double.parse(userLocation.latitude),
                                double.parse(userLocation.longitude)),
                            12));
                      },
                      icon: Icon(
                        Icons.my_location,
                        color: mainColor,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.white, width: 2),
                    color: mainColor,
                  ),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: 54,
                  height: 54,
                  child: IconButton(
                    iconSize: 36,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TravelWyze(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isMapCreated ? const ActivityContainer() : Container(),
          Positioned(
            width: width,
            height: height,
            top: 50,
            child: showLIst
                ? ActivityTypeView(
                    onTap: () {
                      setState(() {
                        showLIst = !showLIst;
                      });

                      updateMarkers(filtrest, activityBit);
                    },
                  )
                : Container(),
          ),
          Positioned(
            top: 0,
            width: width,
            child: searchListView(suggestion),
          ),
        ],
      ),
    );
  }
}

Widget searchListView(List<GoogleSearchedPlace> suggestions) {
  return Container(
    color: Colors.white,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          tileColor: Colors.black,
          title: Text(suggestions[index].place),
          onTap: () {},
        );
      },
    ),
  );
}
