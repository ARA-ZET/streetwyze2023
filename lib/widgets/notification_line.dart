import 'package:flutter/material.dart';

class NotificationLine extends StatelessWidget {
  const NotificationLine(
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
    // double height = MediaQuery.of(context).size.height;

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 255, 255, 255),
                blurRadius: 1,
                spreadRadius: 0.1,
              )
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            alignment: Alignment.centerLeft,
            width: width * 0.99,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 61, 91),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 18,
                      child: const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  children: [
                    Text(
                      body,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_outlined,
                            size: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Helpfull",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.face_6),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Not helpfull",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ])
              ],
            ),
          ),
        ),
      ],
    );
  }
}
