import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/widgets/markers_info.dart';
import '../models/restaurant.dart';
import '../providers/file_controller.dart';
import '../providers/google_maps_controller.dart';
import '../screens/travel_wyze.dart';

class RestaurantContainer extends StatefulWidget {
  const RestaurantContainer({super.key});

  @override
  State<RestaurantContainer> createState() => _RestaurantContainerState();
}

class _RestaurantContainerState extends State<RestaurantContainer> {
  double size = 0.028;
  @override
  Widget build(BuildContext context) {
    late List<Restaurant> restaurants =
        context.watch<FileController>().filteredRestaurants;
    String currentCusine = context.watch<FileController>().currentCuisine;
    double width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
      initialChildSize: size,
      minChildSize: 0.028,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.only(right: 8, left: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: restaurants.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                size = 0.8;
                              });
                            },
                            child: Container(
                              height: 5,
                              width: 100,
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 1, 126, 22),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 229, 229, 229),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                            ),
                            padding: const EdgeInsets.only(
                                right: 8, left: 8, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 11, 135, 0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 229, 229, 229),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              currentCusine,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            width: width,
                            color: const Color.fromARGB(255, 35, 109, 48),
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                          )
                        ],
                      );
                    } else {
                      index = index - 1;
                      return Card(
                        color: index.isEven
                            ? const Color.fromARGB(255, 250, 242, 231)
                            : const Color.fromARGB(255, 255, 255, 255),
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<GoogleController>()
                                .calculateDistanceAndTime(
                                    restaurants[index].coordinates);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowMarkerInfo(
                                      name: restaurants[index].name,
                                      about: restaurants[index].about,
                                      cuisine: restaurants[index].cuisine,
                                      address: restaurants[index].location,
                                      website: restaurants[index].website,
                                      contact:
                                          restaurants[index].restaurantInfo,
                                      parking: restaurants[index].parking,
                                      lat: double.parse(restaurants[index]
                                          .coordinates
                                          .split(",")[0]),
                                      lng: double.parse(restaurants[index]
                                          .coordinates
                                          .split(",")[1]));
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 6, left: 4),
                            height: 170,
                            child: Row(
                              children: [
                                Container(
                                  // Image container
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 248, 248, 248),
                                        blurRadius: 3,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: 80,

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: const Image(
                                      image:
                                          AssetImage("assets/placeholder.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  // Wrap the column with Expanded
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurants[index].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: Color.fromARGB(
                                                    255, 201, 134, 45),
                                                size: 14,
                                              ),
                                              Flexible(
                                                // Wrap with Flexible for potential overflow
                                                child: Text(
                                                  restaurants[index].location,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                        255, 201, 134, 45),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        child: Text(
                                          restaurants[index].about,
                                          softWrap: true,
                                          maxLines: 4,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 63, 63, 63)),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                top: 4,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 196, 141, 81),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 229, 229, 229),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  restaurants[index].cuisine,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                top: 4,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 229, 229, 229),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Wrap(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => [
                                                    Provider.of<GoogleController>(
                                                            context,
                                                            listen: false)
                                                        .saveMarker(
                                                            double.parse(restaurants[
                                                                    index]
                                                                .coordinates
                                                                .split(",")[0]),
                                                            double.parse(restaurants[
                                                                    index]
                                                                .coordinates
                                                                .split(",")[1]),
                                                            restaurants[index]
                                                                .name),
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TravelWyze(),
                                                      ),
                                                    ),
                                                  ],
                                                  child: const Icon(
                                                    Icons.directions,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
