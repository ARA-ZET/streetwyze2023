import 'package:flutter/material.dart';
import '../widgets/notification_line.dart';
import 'root_selector.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RootSelector(
                    root: 0,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blueGrey,
            ),
          ),
          title: Container(
              alignment: Alignment.center, child: const Text("Notifications")),
          actions: const [
            Icon(Icons.notifications),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                width: width,
                height: 3,
                margin: const EdgeInsets.only(top: 4, bottom: 10),
                color: Colors.white,
              ),
              const NotificationLine(
                  heading: "Safety Tips",
                  date: "M7 & Viking Road",
                  body:
                      "You are approaching M7 and Viking Road, make sure doors are locked and windows Be vigilant and avoid hit and grab.")
            ],
          ),
        ),
      ),
    );
  }
}
