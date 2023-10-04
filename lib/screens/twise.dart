// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:provider/provider.dart';

// import '../models/google_place.dart';
// import '../models/place.dart';
// import '../providers/google_maps_controller.dart';

// class TravelWyze extends StatefulWidget {
//   const TravelWyze({
//     super.key,
//   });

//   @override
//   State<TravelWyze> createState() => _TravelWyzeState();
// }

// class _TravelWyzeState extends State<TravelWyze> {
//   String? _instruction;
//   MapBoxNavigationViewController? _controller;
//   bool _routeBuilt = false;
//   bool _isNavigating = false;
//   final bool _isMultipleStop = false;
//   final bool _isSearchView = false;

//   final bool _inFreeDrive = false;
//   late MapBoxOptions _navigationOption;
//   final _formKey = GlobalKey<FormState>();
//   bool isResponseForDestination = false;
//   late final TextEditingController startSearch;
//   late final TextEditingController destSearch;
//   late final Place startPoint;
//   late final Place destination;
//   late final bool isSearching;
//   late GoogleController _googleController;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Save a reference to the ancestor widget
//     _googleController = Provider.of<GoogleController>(context);
//   }

//   @override
//   void dispose() {
//     startSearch.dispose();
//     destSearch.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//     startSearch = TextEditingController(
//       text: Provider.of<GoogleController>(context, listen: false)
//           .startPoint
//           .formattedAddress,
//     );
//     destSearch = TextEditingController(
//       text: Provider.of<GoogleController>(context, listen: false)
//           .destination
//           .formattedAddress,
//     );
//   }

//   Future<void> initialize() async {
//     if (!mounted) return;
//     _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
//     MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
//     MapBoxNavigation.instance.setDefaultOptions(_navigationOption);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     late List<GoogleSearchedPlace> responses =
//         context.watch<GoogleController>().responses;

//     final startPoint = Provider.of<GoogleController>(context).startPoint;
//     final destination = Provider.of<GoogleController>(context).destination;
//     final isSearching = Provider.of<GoogleController>(context).isSearching;

//     final start = WayPoint(
//         name: startPoint.formattedAddress,
//         latitude: startPoint.lat,
//         longitude: startPoint.lng,
//         isSilent: false);
//     final dest = WayPoint(
//         name: destination.formattedAddress,
//         latitude: destination.lat,
//         longitude: destination.lng,
//         isSilent: false);
//     bool isEmpty = responses.isEmpty;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(destination.formattedAddress),
//       ),
//       body: isSearching
//           ? Stack(
//               children: [
//                 Positioned(
//                   top: 0,
//                   child: Container(
//                     height: 150,
//                     width: width,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(8.0),
//                     child: RepaintBoundary(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextFormField(
//                             onTap: () {
//                               isResponseForDestination = false;
//                               debugPrint("starting point");
//                             },
//                             onChanged: (value) {
//                               context
//                                   .read<GoogleController>()
//                                   .onSearchTextChanged(value);
//                             },
//                             controller: startSearch,
//                             textCapitalization: TextCapitalization.words,
//                             decoration: InputDecoration(
//                               labelText: 'Where from ?',
//                               icon: const Icon(Icons.location_on_outlined),
//                               suffixIcon: IconButton(
//                                 icon: const Icon(
//                                   Icons.location_searching_sharp,
//                                   color: Colors.green,
//                                 ),
//                                 onPressed: () {
//                                   startSearch.text =
//                                       startPoint.formattedAddress;
//                                   context
//                                       .read<GoogleController>()
//                                       .saveCurrentLoc();
//                                 },
//                               ),
//                             ),
//                           ),
//                           TextFormField(
//                             onTap: () {
//                               isResponseForDestination = true;
//                             },
//                             onChanged: (value) {
//                               context
//                                   .read<GoogleController>()
//                                   .onSearchTextChanged(value);
//                             },
//                             textCapitalization: TextCapitalization.words,
//                             style: const TextStyle(fontSize: 14),
//                             controller: destSearch,
//                             decoration: const InputDecoration(
//                               labelText: 'Destination',
//                               icon: Icon(Icons.route_outlined),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 isEmpty
//                     ? Positioned(
//                         top: height * 0.2,
//                         child: GestureDetector(
//                           onTap: _isNavigating
//                               ? null
//                               : () {
//                                   context
//                                       .read<GoogleController>()
//                                       .searchState(false);
//                                 },
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 60,
//                             width: width,
//                             decoration: const BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                             ),
//                             padding: const EdgeInsets.all(8.0),
//                             child: const Text(
//                               "Travel Wyze",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     : Positioned(
//                         top: height * 0.2,
//                         width: width,
//                         child: searchListView(
//                           responses,
//                           isResponseForDestination,
//                           destSearch,
//                           startSearch,
//                         ),
//                       ),
//               ],
//             )
//           : Center(
//               child: Stack(
//                 children: <Widget>[
//                   Positioned.fill(
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: MapBoxNavigationView(
//                         options: _navigationOption,
//                         onRouteEvent: _onEmbeddedRouteEvent,
//                         onCreated:
//                             (MapBoxNavigationViewController controller) async {
//                           try {
//                             _controller = controller;
//                             controller.initialize();
//                             _controller?.buildRoute(wayPoints: [
//                               start,
//                               dest,
//                             ], options: _navigationOption);
//                           } catch (e, stackTrace) {
//                             print('An error occurred: $e');
//                             print('Stack trace: $stackTrace');
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> _onEmbeddedRouteEvent(e) async {
//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;

//         if (progressEvent.currentStepInstruction != null) {
//           _instruction = progressEvent.currentStepInstruction;
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         setState(() {
//           _routeBuilt = true;
//         });
//         break;
//       case MapBoxEvent.route_build_failed:
//         setState(() {
//           _routeBuilt = false;
//         });
//         break;
//       case MapBoxEvent.navigation_running:
//         setState(() {
//           _isNavigating = true;
//           context.read<GoogleController>().searchState(false);
//         });
//         break;
//       case MapBoxEvent.on_arrival:
//         if (!_isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller?.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         setState(() {
//           try {
//             _routeBuilt = false;
//             _isNavigating = false;

//             Provider.of<GoogleController>(context, listen: false)
//                 .searchState(true);
//           } catch (e) {}
//         });

//         break;
//       default:
//         break;
//     }
//     setState(() {});
//   }
// }

// Widget searchListView(
//   List<GoogleSearchedPlace> responses,
//   bool isResponseForDestination,
//   TextEditingController destinationController,
//   TextEditingController sourceController,
// ) {
//   return Container(
//     color: const Color.fromARGB(255, 0, 0, 0),
//     child: ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: responses.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Column(
//           children: responses.map((result) {
//             return ListTile(
//               tileColor: Colors.black,
//               onTap: () {
//                 String text = result.place.split(",")[0].trim();
//                 if (isResponseForDestination) {
//                   destinationController.text = text;
//                   context
//                       .read<GoogleController>()
//                       .savePlace(isResponseForDestination, result.placeId);
//                 } else {
//                   sourceController.text = text;
//                   context
//                       .read<GoogleController>()
//                       .savePlace(isResponseForDestination, result.placeId);
//                 }
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//               leading: const SizedBox(
//                 height: double.infinity,
//                 child: CircleAvatar(child: Icon(Icons.map)),
//               ),
//               title: Text(result.place,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.white)),
//             );
//           }).toList(),
//         );
//       },
//     ),
//   );
// }
