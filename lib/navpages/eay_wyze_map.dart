import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/models/user_location.dart';
import 'package:street_wyze/providers/location_controller.dart';

import '../models/google_place.dart';
import '../models/restaurant.dart';
import '../providers/bitmap_provider.dart';
import '../providers/file_controller.dart';
import '../providers/google_maps_controller.dart';
import '../screens/about.dart';
import '../screens/travel_wyze.dart';
import '../widgets/cuisine_view.dart';
import '../widgets/map_wyze_button.dart';
import '../widgets/markers_info.dart';
import '../widgets/restaurants_container.dart';

class EatwyzeMap extends StatefulWidget {
  const EatwyzeMap({super.key});

  @override
  State<EatwyzeMap> createState() => _EatwyzeMapState();
}

class _EatwyzeMapState extends State<EatwyzeMap> {
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
      Provider.of<FileController>(context, listen: false).sortCuisines();
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
      List<Restaurant> restaurants,
      BitmapDescriptor barBit,
      BitmapDescriptor coffeeBit,
      BitmapDescriptor italianBit,
      BitmapDescriptor traditionalBit,
      BitmapDescriptor resBit) {
    return restaurants.map((res) {
      BitmapDescriptor bitSelector(cuisine) {
        // Cuisine icon selection logic...
        if (cuisine.toString().toLowerCase().contains("bar")) {
          return barBit;
        }
        if (cuisine.toString().toLowerCase().contains("coffee")) {
          return coffeeBit;
        }
        if (cuisine.toString().toLowerCase().contains("italian")) {
          return italianBit;
        }
        if (cuisine.toString().toLowerCase().contains("africa")) {
          return traditionalBit;
        } else {
          return resBit;
        }
      }

      return Marker(
        markerId: MarkerId(res.name),
        position: LatLng(
          double.parse(res.coordinates.split(",")[0]),
          double.parse(res.coordinates.split(",")[1]),
        ),
        icon: bitSelector(res.cuisine),
        infoWindow: InfoWindow(title: res.name),
        consumeTapEvents: true,
        onTap: () {
          context
              .read<GoogleController>()
              .calculateDistanceAndTime(res.coordinates);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowMarkerInfo(
                    name: res.name,
                    about: res.about,
                    cuisine: res.cuisine,
                    address: res.location,
                    website: res.website,
                    contact: res.restaurantInfo,
                    parking: res.parking,
                    lat: double.parse(res.coordinates.split(",")[0]),
                    lng: double.parse(res.coordinates.split(",")[1]));
              });
        },
      );
    }).toSet();
  }

  void updateMarkers(
      List<Restaurant> restaurants,
      BitmapDescriptor barBit,
      BitmapDescriptor coffeeBit,
      BitmapDescriptor italianBit,
      BitmapDescriptor traditionalBit,
      BitmapDescriptor resBit) {
    setState(() {
      _markers = generateMarkers(
          restaurants, barBit, coffeeBit, italianBit, traditionalBit, resBit);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // final saps = context.watch<BitMapDis>().sapsBit;
    final resBit = context.watch<BitMapDis>().resBit;
    final coffeeBit = context.watch<BitMapDis>().coffeeBit;
    final barBit = context.watch<BitMapDis>().barBit;
    final italianBit = context.watch<BitMapDis>().italianBit;
    final traditionalBit = context.watch<BitMapDis>().traditionalBit;

    List<GoogleSearchedPlace> suggestion =
        context.watch<GoogleController>().responses;

    List<Restaurant> filtrest =
        context.watch<FileController>().filteredRestaurants;

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
                  color: const Color.fromARGB(255, 0, 96, 4),
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
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 4, 130, 0),
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromARGB(255, 242, 251, 241),
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
                    color: Colors.green,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    String.fromCharCode(Icons.search.codePoint),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 52, 94, 53),
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
              activeColor: const Color.fromARGB(255, 0, 98, 3),
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

              updateMarkers(filtrest, barBit, coffeeBit, italianBit,
                  traditionalBit, resBit);
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
                        return barBit;
                      }
                      if (cuisine.toString().toLowerCase().contains("coffee")) {
                        return coffeeBit;
                      }
                      if (cuisine
                          .toString()
                          .toLowerCase()
                          .contains("italian")) {
                        return italianBit;
                      }
                      if (cuisine.toString().toLowerCase().contains("africa")) {
                        return traditionalBit;
                      } else {
                        return resBit;
                      }
                    }

                    return Marker(
                      markerId: MarkerId(res.name),
                      position: LatLng(
                        double.parse(res.coordinates.split(",")[0]),
                        double.parse(res.coordinates.split(",")[1]),
                      ),
                      icon: bitSelector(res.cuisine),
                      infoWindow: InfoWindow(title: res.name),
                      consumeTapEvents: true,
                      onTap: () {
                        context
                            .read<GoogleController>()
                            .calculateDistanceAndTime(res.coordinates);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowMarkerInfo(
                                  name: res.name,
                                  about: res.about,
                                  cuisine: res.cuisine,
                                  address: res.location,
                                  website: res.website,
                                  contact: res.restaurantInfo,
                                  parking: res.parking,
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
                          .filterRestaurants("All");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Italian",
                    icon: Icons.local_pizza,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterRestaurants("Italian");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "French",
                    icon: Icons.fastfood,
                    color: Colors.blueGrey,
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterRestaurants("French");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Asian",
                    icon: Icons.table_restaurant,
                    color: const Color.fromARGB(255, 183, 102, 2),
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterRestaurants("Asian");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "African",
                    icon: Icons.local_florist_outlined,
                    color: const Color.fromARGB(255, 1, 149, 83),
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterRestaurants("African");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
                    },
                  ),
                  const SizedBox(width: 5),
                  MapWyzeButton(
                    text: "Breakfast & Cafe",
                    icon: Icons.local_cafe,
                    color: const Color.fromARGB(255, 1, 149, 83),
                    onPressed: () {
                      setState(() {
                        showLIst = false;
                        fromUpdateMarkers = true;
                      });
                      final rest = context
                          .read<FileController>()
                          .filterRestaurants("cafe");
                      updateMarkers(rest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
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
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  margin: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  width: 54,
                  height: 54,
                  child: IconButton(
                      iconSize: 36,
                      onPressed: () {
                        mapController?.animateCamera(CameraUpdate.newLatLng(
                          LatLng(double.parse(userLocation.latitude),
                              double.parse(userLocation.longitude)),
                        ));
                      },
                      icon: const Icon(
                        Icons.my_location,
                        color: Colors.green,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.green,
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
          isMapCreated ? const RestaurantContainer() : Container(),
          Positioned(
            width: width,
            height: height,
            top: 50,
            child: showLIst
                ? CuisineView(
                    onTap: () {
                      setState(() {
                        showLIst = !showLIst;
                      });

                      updateMarkers(filtrest, barBit, coffeeBit, italianBit,
                          traditionalBit, resBit);
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
