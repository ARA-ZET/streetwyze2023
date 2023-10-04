import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import 'Auth/auth_screen.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final user = Provider.of<StreetWyzeUser?>(context, listen: true);

    final AuthService auth = AuthService();
    return user != null
        ? Scaffold(
            backgroundColor: const Color.fromARGB(255, 0, 18, 9),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              title: Container(
                alignment: Alignment.center,
                child: const Text(
                  "USER PROFILE",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              actions: const [
                Icon(
                  Icons.perm_contact_cal_sharp,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 20,
                )
              ],
              backgroundColor: const Color.fromARGB(255, 0, 18, 9),
            ),
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color.fromARGB(255, 0, 18, 9),
                ),
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.all(16),
                width: width,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 239, 238),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 187, 208, 195),
                              blurRadius: 3,
                            )
                          ], borderRadius: BorderRadius.circular(60)),
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: const Image(
                              image: AssetImage("assets/logo.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 16,
                        ),
                        const Text(
                          "Arazet Design",
                          style: TextStyle(fontSize: 24),
                        ),
                        const Text(
                          "Cape Town",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10)),
                    child: Wrap(
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
                                Icons.person,
                                color: Colors.green,
                                size: 28,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Personal Information",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                  const Text(
                                    "Username, email, phone number, city",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 135, 185, 137)),
                                  ),
                                  currentIndex == 1
                                      ? Container(
                                          width: width * 0.75,
                                          height: 90,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: const Color.fromARGB(
                                                255, 5, 38, 0),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.3,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      "NAME:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Richard Zuzeyo",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.3,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      "EMAIL:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "arazet@gmail.com",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.3,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      "CONTACT:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Null",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: width * 0.75,
                                          height: 2,
                                          color: const Color.fromARGB(
                                              255, 230, 230, 230),
                                          margin: const EdgeInsets.only(
                                              top: 3, bottom: 16),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                Icons.favorite,
                                color: Colors.green,
                                size: 28,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "My Places",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                  const Text(
                                    "City, Police Station, favorite places",
                                    softWrap: true,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 135, 185, 137)),
                                  ),
                                  Container(
                                    width: width * 0.75,
                                    height: 2,
                                    color: const Color.fromARGB(
                                        255, 230, 230, 230),
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeIndex(3);
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
                                  const Text(
                                    "Data sharing, tracking information",
                                    softWrap: true,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 135, 185, 137)),
                                  ),
                                  currentIndex == 3
                                      ? Container(
                                          width: width * 0.75,
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
                                          width: width * 0.75,
                                          height: 2,
                                          color: const Color.fromARGB(
                                              255, 230, 230, 230),
                                          margin: const EdgeInsets.only(
                                              top: 3, bottom: 16),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 12),
                    width: width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Container(
                        height: 50,
                        width: 200,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: TextButton.icon(
                            onPressed: () async {
                              await auth.signOut();
                            },
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: Colors.green,
                              size: 24,
                            ),
                            label: const Text(
                              "Signout",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 24),
                            )),
                      ),
                    ]),
                  )
                ]),
              ),
            ),
          )
        : const AuthScreen();
  }
}
