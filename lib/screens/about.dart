import 'package:flutter/material.dart';
import 'package:street_wyze/screens/feedback.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int currentIndex = 0;
  bool tripData = true;
  bool tripHistory = true;
  changeIndex(index) {
    setState(() {
      if (currentIndex != index) {
        currentIndex = index;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserFeedback(
                    receiverId: "MO8KcaC1kZRNKH8lDPnQHbZ3il13",
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            color: Colors.black,
            width: width,
            height: height,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(top: 24, left: 8),
            child: Column(
              children: [
                Container(
                  width: width * 0.86,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 21, 21),
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 60,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage("assets/logofullblack.png"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "STREET-WYZE",
                            style: TextStyle(color: Colors.green, fontSize: 24),
                          ),
                          Text(
                            "Your Guardian on the go!",
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                          Text(
                            "V 1.01.06",
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                            size: 32,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: width * 0.86,
                  height: 2,
                  color: Colors.green,
                ),
                Container(
                  width: width * 0.86,
                  height: 320,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 21, 21),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          changeIndex(1);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.green,
                              size: 28,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "About",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                currentIndex == 1
                                    ? Container(
                                        width: width * 0.7,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color.fromARGB(
                                              255, 5, 38, 0),
                                        ),
                                        child: Wrap(
                                          runAlignment:
                                              WrapAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons
                                                        .integration_instructions_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.facebook_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.insert_chart,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: width * 0.7,
                                        height: 2,
                                        color: const Color.fromARGB(
                                            255, 9, 79, 11),
                                        margin: const EdgeInsets.only(
                                          top: 3,
                                        ),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeIndex(2);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.settings,
                              color: Colors.green,
                              size: 28,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Setting",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                currentIndex == 2
                                    ? Container(
                                        width: width * 0.7,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color.fromARGB(
                                              255, 5, 38, 0),
                                        ),
                                        child: Wrap(
                                          runAlignment:
                                              WrapAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Trip Data",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Switch(
                                                  value: tripData,
                                                  activeColor: Colors.white,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      tripData = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Trip History",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Switch(
                                                  value: tripHistory,
                                                  activeColor: Colors.white,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      tripHistory = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: width * 0.7,
                                        height: 2,
                                        color: const Color.fromARGB(
                                            255, 9, 79, 11),
                                        margin: const EdgeInsets.only(
                                          top: 3,
                                        ),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.help_center_rounded,
                            color: Colors.green,
                            size: 28,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Need help",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                              Container(
                                width: width * 0.7,
                                height: 2,
                                color: const Color.fromARGB(255, 9, 79, 11),
                                margin: const EdgeInsets.only(
                                  top: 3,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.lock_person_outlined,
                            color: Colors.green,
                            size: 28,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                              Container(
                                width: width * 0.7,
                                height: 2,
                                color: const Color.fromARGB(255, 9, 79, 11),
                                margin: const EdgeInsets.only(
                                  top: 3,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.library_books_outlined,
                            color: Colors.green,
                            size: 28,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Terms and condition",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                              Container(
                                width: width * 0.7,
                                height: 2,
                                color: const Color.fromARGB(255, 9, 79, 11),
                                margin: const EdgeInsets.only(
                                  top: 3,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 0.86,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 21, 21),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Wrap(
                    children: [
                      Text(
                        "This is our first release of the app can you kindly give us your feedback based on your experience while using the app.\n  (1) what should be changed. \n  (2) what should be added.",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
