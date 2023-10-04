import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cuisine_set.dart';
import '../providers/file_controller.dart';

class CuisineView extends StatelessWidget {
  const CuisineView({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Future<List<CuisineSet>> fetchData() async {
      List<CuisineSet> sortedList =
          context.watch<FileController>().cuisineSorted;
      await Future.delayed(const Duration(seconds: 2));
      return sortedList;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.999,
      minChildSize: 0.99,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.only(right: 2, left: 2),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 19, 19, 19),
          ),
          child: FutureBuilder<List<CuisineSet>>(
            future: fetchData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<CuisineSet>> snapshot) {
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
                                  ? const Color.fromARGB(255, 33, 33, 33)
                                  : const Color.fromARGB(255, 19, 19, 19),
                              margin: const EdgeInsets.only(
                                bottom: 2,
                              ),
                              child: ListTile(
                                onTap: () {
                                  context
                                      .read<FileController>()
                                      .filterRestaurants(
                                        snapshot.data![index].cuisine,
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
                                      Icons.restaurant_menu,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                title: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data![index].cuisine,
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
