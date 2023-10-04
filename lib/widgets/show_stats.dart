import 'package:flutter/material.dart';

class ShowStats extends StatelessWidget {
  const ShowStats({super.key, required this.police});
  final String police;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      title: Center(
        child: Text(
          police,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "2023 Annual Statistics:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            RichText(
                text: const TextSpan(
                    text: "4125",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                    children: [
                  TextSpan(
                    text: "  Crimes in total",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ])),
            const Divider(),
            const Text(
              "Coverage and Population",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            RichText(
              text: TextSpan(
                text: '20',
                style: const TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  const TextSpan(
                    text: ' km',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0, -4),
                      child: const Text(
                        '2',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: "  | 20 447",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => [],
          child: SizedBox(
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.green,
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 100,
              height: 40,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blueGrey,
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 100,
              height: 40,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
