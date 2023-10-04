import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/models/activity_type.dart';

import '../providers/file_controller.dart';

class ActivityTypeView extends StatelessWidget {
  const ActivityTypeView({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Future<List<TypeSet>> fetchData() async {
      List<TypeSet> sortedActivity = context.watch<FileController>().typeSorted;
      await Future.delayed(const Duration(seconds: 2));
      return sortedActivity;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.999,
      minChildSize: 0.99,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.only(right: 2, left: 2),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 30, 63),
          ),
          child: FutureBuilder<List<TypeSet>>(
            future: fetchData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<TypeSet>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  heightFactor: 5,
                  child: CircularProgressIndicator(),
                ); // Display a loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data?.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: index.isEven
                                  ? const Color.fromARGB(255, 0, 30, 63)
                                  : const Color.fromARGB(255, 12, 27, 47),
                              margin: const EdgeInsets.only(
                                bottom: 2,
                              ),
                              child: ListTile(
                                onTap: () {
                                  context
                                      .read<FileController>()
                                      .filterActivities(
                                        snapshot.data![index].type,
                                      );
                                  onTap();

                                  debugPrint("running from listView");
                                },
                                splashColor: Colors.amber,
                                leading: const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.hiking,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                title: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data![index].type,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      " (${snapshot.data![index].quantity.toString()})",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
