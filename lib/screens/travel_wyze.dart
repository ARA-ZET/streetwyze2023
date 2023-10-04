import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/providers/mapbox_controller.dart';
import '../models/google_place.dart';
import '../providers/google_maps_controller.dart';

class TravelWyze extends StatefulWidget {
  const TravelWyze({super.key});

  @override
  State<TravelWyze> createState() => _TravelWyzeState();
}

class _TravelWyzeState extends State<TravelWyze> {
  String? _platformVersion;
  String? _instruction;

  final _formKey = GlobalKey<FormState>();
  bool isResponseForDestination = false;
  TextEditingController startSearch = TextEditingController();
  TextEditingController destSearch = TextEditingController();
  bool isSearching = false;

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;

  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.units = VoiceUnits.metric;

    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    MapBoxNavigation.instance.setDefaultOptions(_navigationOption);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final startPoint = context.watch<GoogleController>().startPoint;
    final destination = context.watch<GoogleController>().destination;
    final isLoading = context.watch<GoogleController>().isLoading;
    bool wyzeState = context.watch<TravelWyzeController>().travelWyzeState;
    final List<GoogleSearchedPlace> responses =
        context.watch<GoogleController>().responses;

    final start = WayPoint(
        name: startPoint.formattedAddress,
        latitude: startPoint.lat,
        longitude: startPoint.lng,
        isSilent: false);
    final dest = WayPoint(
        name: destination.formattedAddress,
        latitude: destination.lat,
        longitude: destination.lng,
        isSilent: false);
    bool isEmpty = responses.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Wrap(
          children: [
            Text(
              destination.formattedAddress,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.green,
                size: 30,
              ))
        ],
      ),
      body: Stack(
        children: [
          MapBoxNavigationView(
            options: _navigationOption,
            onRouteEvent: _onEmbeddedRouteEvent,
            onCreated: (MapBoxNavigationViewController controller) async {
              _controller = controller;
              controller.initialize();
              if (wyzeState == true) {
                MapBoxNavigation.instance.finishNavigation();
                _controller?.clearRoute();
                var wayPoints = <WayPoint>[];
                wayPoints.add(start);
                wayPoints.add(dest);
                _isMultipleStop = wayPoints.length > 2;
                _controller
                    ?.buildRoute(
                        wayPoints: wayPoints, options: _navigationOption)
                    .whenComplete(() => _controller?.startNavigation());
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: _routeBuilt && _isNavigating
                ? Container()
                : Container(
                    height: 80,
                    width: width,
                    color: const Color.fromARGB(255, 24, 75, 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isNavigating
                              ? null
                              : () {
                                  if (_routeBuilt) {
                                    _controller?.clearRoute();
                                  } else {
                                    var wayPoints = <WayPoint>[];
                                    wayPoints.add(start);
                                    wayPoints.add(dest);
                                    _isMultipleStop = wayPoints.length > 2;
                                    _controller?.buildRoute(
                                        wayPoints: wayPoints,
                                        options: _navigationOption);
                                    Provider.of<TravelWyzeController>(context,
                                            listen: false)
                                        .changeWyzeState(true);
                                  }
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Background color
                            foregroundColor: Colors.white, // Text (Icon) color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Border radius
                            ),
                          ),
                          child: Text(_routeBuilt && !_isNavigating
                              ? "Clear Route"
                              : "Travel Wyze"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: _routeBuilt && !_isNavigating
                              ? () {
                                  _controller?.startNavigation();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Background color
                            foregroundColor: Colors.white, // Text (Icon) color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Border radius
                              side: BorderSide(
                                color: _routeBuilt && !_isNavigating
                                    ? Colors
                                        .white // White border color when active
                                    : const Color.fromARGB(255, 136, 136,
                                        136), // No border color when not active
                              ),
                            ),
                          ),
                          child: Transform.rotate(
                            angle: 45 *
                                (3.141592653589793 /
                                    180), // 45 degrees in radians
                            child: Icon(
                              Icons.navigation_outlined,
                              color: _routeBuilt && !_isNavigating
                                  ? Colors
                                      .white // White border color when active
                                  : const Color.fromARGB(255, 136, 136, 136),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            child: isSearching
                ? Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: Container(
                          height: 165,
                          width: width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RepaintBoundary(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  onTap: () {
                                    setState(() {
                                      isResponseForDestination = false;
                                    });
                                    debugPrint("starting point");
                                  },
                                  onChanged: (value) {
                                    context
                                        .read<GoogleController>()
                                        .onSearchTextChanged(value);
                                  },
                                  controller: startSearch,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    labelText: 'Where from ?',
                                    icon:
                                        const Icon(Icons.location_on_outlined),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.location_searching_sharp,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        startSearch.text =
                                            startPoint.formattedAddress;
                                        context
                                            .read<GoogleController>()
                                            .saveCurrentLoc();
                                      },
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  onTap: () {
                                    setState(() {
                                      isResponseForDestination = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    context
                                        .read<GoogleController>()
                                        .onSearchTextChanged(value);
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  style: const TextStyle(fontSize: 14),
                                  controller: destSearch,
                                  decoration: const InputDecoration(
                                    labelText: 'Destination',
                                    icon: Icon(Icons.route_outlined),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                isLoading
                                    ? const LinearProgressIndicator() // Display the loading bar
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isEmpty
                          ? Container()
                          : Positioned(
                              top: height * 0.2,
                              width: width,
                              height: height,
                              child: searchListView(
                                responses,
                                isResponseForDestination,
                                destSearch,
                                startSearch,
                              ),
                            ),
                    ],
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        Provider.of<TravelWyzeController>(context, listen: false)
            .changeWyzeState(false);
        MapBoxNavigation.instance.finishNavigation();
        _controller?.dispose;
        _controller = null;
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        _controller?.clearRoute();

        break;
      default:
        break;
    }
    setState(() {});
  }
}

Widget searchListView(
  List<GoogleSearchedPlace> responses,
  bool isResponseForDestination,
  TextEditingController destinationController,
  TextEditingController sourceController,
) {
  return Container(
    color: const Color.fromARGB(255, 0, 0, 0),
    child: ListView.builder(
      itemCount:
          responses.length > 5 ? 5 : responses.length, // Limit to five items
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final result = responses[index]; // Get the specific item
        return ListTile(
          onTap: () {
            String text = result.place;
            if (isResponseForDestination) {
              destinationController.text = text;
              context
                  .read<GoogleController>()
                  .savePlace(isResponseForDestination, result.placeId);
              debugPrint("Placeid destination");
            } else {
              sourceController.text = text;
              context
                  .read<GoogleController>()
                  .savePlace(isResponseForDestination, result.placeId);
              debugPrint("Placeid start");
            }
            FocusManager.instance.primaryFocus?.unfocus();
          },
          splashColor: Colors.amber,
          leading: const SizedBox(
            height: double.infinity,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(result.place,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text(
            result.address,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    ),
  );
}
