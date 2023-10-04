import 'package:flutter/material.dart';

import '../widgets/trip_line.dart';

class MyTripsPage extends StatelessWidget {
  const MyTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_ios),
              Text("My Trips"),
              Icon(Icons.route_outlined)
            ],
          ),
        ),
        body: const Column(
          children: [
            TripLine(
                heading: "Caution",
                date: "12 May 2023",
                body:
                    "You are approaching M7 and Viking Road, make sure doors are locked and windows Be vigilant and avoid hit and grab.")
          ],
        ),
      ),
    );
  }
}
