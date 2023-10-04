import 'package:flutter/material.dart';
import 'package:street_wyze/navpages/root_selector.dart';
import 'package:street_wyze/screens/feedback.dart';

import '../screens/about.dart';
import '../screens/profile_page.dart';
import '../screens/travel_wyze.dart';
import '../widgets/wyze_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const About()));
              },
              icon: const Icon(
                Icons.menu,
                size: 40,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyProfile()));
              },
              child: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 25, 72, 33),
                    blurRadius: 2,
                  )
                ], borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Image(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              width: width * 0.97,
              height: height * 0.08,
              alignment: Alignment.center,
              margin: EdgeInsets.all(width * 0.015),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 0, 67, 26),
                  Color.fromARGB(255, 0, 45, 123)
                ]),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 25, 72, 33),
                    blurRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "  FEEDBACK AND SUGGESTION",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
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
                  )
                ],
              ),
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 243, 243),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TravelWyze(),
                            ),
                          );
                        },
                        child: const WyzeButton(
                          pic: "assets/Travelwyze.png",
                          text: "TravelWyze",
                          color: Color.fromARGB(255, 2, 131, 6),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RootSelector(
                                root: 1,
                              ),
                            ),
                          );
                        },
                        child: const WyzeButton(
                          pic: "assets/Playwyze.png",
                          text: "PlayWyze",
                          color: Color.fromARGB(255, 2, 29, 165),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RootSelector(
                                root: 2,
                              ),
                            ),
                          );
                        },
                        child: const WyzeButton(
                          pic: "assets/Eatwyze.png",
                          text: "EatWyze",
                          color: Color.fromARGB(255, 245, 169, 1),
                        ),
                      ),
                      const WyzeButton(
                        pic: "assets/Shopwyze.png",
                        text: "ShopWyze",
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
