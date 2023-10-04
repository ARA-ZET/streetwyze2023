import 'package:flutter/material.dart';

class TripLine extends StatelessWidget {
  const TripLine(
      {super.key,
      required this.heading,
      required this.date,
      required this.body});
  final String heading;
  final String date;
  final String body;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border:
            Border.all(width: 2, style: BorderStyle.solid, color: Colors.black),
      ),
      padding: EdgeInsets.all(width * 0.04),
      margin: EdgeInsets.all(width * 0.02),
      alignment: Alignment.centerLeft,
      width: width * 0.99,
      height: 120,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              body,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
