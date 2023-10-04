import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/models/activity.dart';
import 'package:street_wyze/widgets/activity_info.dart';
import '../providers/file_controller.dart';
import '../providers/google_maps_controller.dart';
import '../screens/travel_wyze.dart';

class ActivityContainer extends StatefulWidget {
  const ActivityContainer({super.key});

  @override
  State<ActivityContainer> createState() => _ActivityContainerState();
}

class _ActivityContainerState extends State<ActivityContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _sheetFraction = 0.028; // Initial sheet size

  void changeSheetSize() {
    _scaffoldKey.currentState?.setState(() {
      _sheetFraction = 0.7; // Change the sheet size here
    });
  }

  Color mainColor = const Color.fromARGB(255, 0, 121, 220);

  @override
  Widget build(BuildContext context) {
    late List<Activity> activities =
        context.watch<FileController>().filteredActivities;
    String currentActivity = context.watch<FileController>().currentCActivity;
    double width = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: _sheetFraction,
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
          child: ListView.builder(
            controller: scrollController,
            itemCount: activities.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        changeSheetSize();
                      },
                      child: Container(
                        height: 5,
                        width: 100,
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: mainColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 205, 231, 255),
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
                        color: mainColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 199, 204, 255),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        currentActivity,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: width,
                      color: mainColor,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                    )
                  ],
                );
              } else {
                index = index - 1;
                return Card(
                  color: index.isEven
                      ? const Color.fromARGB(255, 240, 244, 249)
                      : const Color.fromARGB(255, 255, 255, 255),
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.read<GoogleController>().calculateDistanceAndTime(
                          activities[index].coordinates);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowActivityInfo(
                                name: activities[index].name,
                                about: activities[index].info,
                                type: activities[index].type,
                                address: activities[index].location,
                                website: activities[index].website,
                                contact: activities[index].contact,
                                lat: double.parse(activities[index]
                                    .coordinates
                                    .split(",")[0]),
                                lng: double.parse(activities[index]
                                    .coordinates
                                    .split(",")[1]));
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 6, left: 4),
                      height: 170,
                      child: Row(
                        children: [
                          // Container(
                          //   // Image container
                          //   alignment: Alignment.center,
                          //   margin: const EdgeInsets.all(1),
                          //   decoration: BoxDecoration(
                          //     boxShadow: const [
                          //       BoxShadow(
                          //         color:
                          //             Color.fromARGB(255, 235, 240, 246),
                          //         blurRadius: 3,
                          //       ),
                          //     ],
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   width: 80,

                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(5),
                          //     child: const Image(
                          //       image:
                          //           AssetImage("assets/placeholder.png"),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(width: 12),
                          Expanded(
                            // Wrap the column with Expanded
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activities[index].name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                          color: mainColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Wrap(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color.fromARGB(
                                              255, 141, 159, 191),
                                          size: 14,
                                        ),
                                        Text(
                                          activities[index].address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 141, 159, 191),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Wrap(children: [
                                  Text(
                                    activities[index].info,
                                    softWrap: true,
                                    maxLines: 4,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      color: mainColor,
                                    ),
                                  ),
                                ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8, top: 4, bottom: 4),
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 229, 229, 229),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            activities[index].type,
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
                                          right: 8, left: 8, top: 4, bottom: 4),
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 229, 229, 229),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Wrap(
                                        children: [
                                          GestureDetector(
                                            onTap: () => [
                                              Provider.of<GoogleController>(
                                                      context,
                                                      listen: false)
                                                  .saveMarker(
                                                      double.parse(
                                                          activities[index]
                                                              .coordinates
                                                              .split(",")[0]),
                                                      double.parse(
                                                          activities[index]
                                                              .coordinates
                                                              .split(",")[1]),
                                                      activities[index].name),
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
        );
      },
    );
  }
}
