import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/providers/mapbox_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../providers/google_maps_controller.dart';
import '../screens/travel_wyze.dart';

class ShowActivityInfo extends StatefulWidget {
  const ShowActivityInfo(
      {super.key,
      required this.name,
      required this.about,
      required this.type,
      required this.address,
      required this.website,
      required this.contact,
      required this.lat,
      required this.lng});

  final String name;
  final String about;
  final String type;
  final String address;
  final String website;
  final String contact;
  final double lat;
  final double lng;

  @override
  State<ShowActivityInfo> createState() => _ShowActivityInfoState();
}

class _ShowActivityInfoState extends State<ShowActivityInfo> {
  Future<void> _launchWeb(String website) async {
    Uri url = Uri.parse(website);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
        scheme: 'tel', path: phoneNumber.toString().replaceAll(" ", "").trim());
    if (await canLaunchUrlString(
        phoneUri.toString().replaceAll(" ", "").trim())) {
      await launchUrlString(phoneUri.toString().replaceAll(" ", "").trim());
    } else {
      return;
    }
  }

  bool webMode = true;
  Color mainColor = const Color.fromARGB(255, 0, 121, 220);
  bool travelMode = true;
  String link = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    String distance = context.watch<GoogleController>().distance;
    String time = context.watch<GoogleController>().time;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: mainColor,
          ),
        ),
        title: Container(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Icon(
            Icons.directions,
            color: mainColor,
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(5),
                child: const Image(
                  image: AssetImage("assets/bo-kaap.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              height: 6,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: mainColor,
                  size: 14,
                ),
                const SizedBox(
                  width: 3,
                ),
                Flexible(
                  child: Text(
                    widget.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: mainColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Container(
              height: 2,
              width: width,
              color: mainColor,
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("5.0",
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold)),
                        RatingBar.builder(
                          itemSize: 14,
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.8),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                    Text("Safety score",
                        style: TextStyle(
                            color: mainColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  height: 30,
                  width: 2,
                  color: mainColor,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("4.5",
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold)),
                        RatingBar.builder(
                          itemSize: 14,
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                    Text(
                      "Experience",
                      style: TextStyle(
                          color: mainColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 213, 234, 254),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            travelMode = true;
                          });
                        },
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Icon(
                              Icons.directions,
                              color: mainColor,
                              size: 30,
                            ),
                            Text(
                              "TravelWyze",
                              style: TextStyle(color: mainColor, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            webMode = true;

                            if (widget.website.length >= 5) {
                              link = widget.website;
                            } else {
                              link = "No website for this restaurant";
                            }

                            travelMode = false;
                            debugPrint(link);
                          });
                        },
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Icon(
                              Icons.integration_instructions_rounded,
                              color: mainColor,
                              size: 30,
                            ),
                            Text(
                              "Website",
                              style: TextStyle(color: mainColor, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            webMode = false;

                            if (widget.contact.length >= 5) {
                              link = widget.contact;
                            } else {
                              link = "No phone number for this restaurant";
                            }
                            travelMode = false;
                            debugPrint(link);
                          });
                        },
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Icon(
                              Icons.call,
                              color: mainColor,
                              size: 30,
                            ),
                            Text(
                              "Call",
                              style: TextStyle(color: mainColor, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  !travelMode
                      ? GestureDetector(
                          onTap: () {
                            webMode
                                ? _launchWeb(widget.website)
                                : _makePhoneCall(widget.contact);
                          },
                          child: Wrap(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  link,
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        )
                      : travelMode
                          ? Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: Wrap(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.time_to_leave_outlined,
                                        size: 20,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        distance,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Icon(
                                        Icons.access_time_outlined,
                                        color: Colors.blueGrey,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        time,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
            Container(
              width: width,
              margin: const EdgeInsets.only(top: 20),
              padding:
                  const EdgeInsets.only(right: 8, left: 8, top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 213, 234, 254),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Wrap(
                children: [
                  Text(
                    widget.about,
                    style: TextStyle(color: mainColor),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding:
                  const EdgeInsets.only(right: 8, left: 8, top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 213, 234, 254),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: mainColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.local_parking_outlined,
                                size: 18,
                                color: mainColor,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Limited Parking",
                            style: TextStyle(color: mainColor, fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Wrap(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: mainColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                size: 18,
                                color: mainColor,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.type,
                            style: TextStyle(color: mainColor, fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
              width: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => [
                    Provider.of<GoogleController>(context, listen: false)
                        .saveMarker(widget.lat, widget.lng, widget.name),
                    Provider.of<TravelWyzeController>(context, listen: false)
                        .changeWyzeState(true),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TravelWyze(),
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: mainColor,
                    ),
                    alignment: Alignment.center,
                    height: 40,
                    child: const Wrap(
                      children: [
                        Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'TRAVEL-WYZE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                    height: 40,
                    child: const Wrap(
                      children: [
                        Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'CLOSE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
