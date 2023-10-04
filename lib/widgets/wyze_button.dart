import 'package:flutter/material.dart';

class WyzeButton extends StatelessWidget {
  const WyzeButton(
      {super.key, required this.pic, required this.text, required this.color});
  final String pic;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Column(
        children: [
          SizedBox(
            width: width * 0.45,
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: color,
                    blurRadius: 3,
                  )
                ], borderRadius: BorderRadius.circular(5)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: AssetImage(pic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 6,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: color,
                blurRadius: 1,
              )
            ], borderRadius: BorderRadius.circular(5)),
            width: width * 0.45,
            height: 48,
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}


// ListTile(
//                 title: Container(
//                   height: 160,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromARGB(255, 213, 213, 213),
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       )
//                     ],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(children: [
//                     Container(
//                       alignment: Alignment.center,
//                       margin: const EdgeInsets.all(1),
//                       decoration: BoxDecoration(boxShadow: const [
//                         BoxShadow(
//                           color: Color.fromARGB(255, 248, 248, 248),
//                           blurRadius: 3,
//                         )
//                       ], borderRadius: BorderRadius.circular(5)),
//                       width: 110,
//                       height: 130,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(5),
//                         child: const Image(
//                           image: AssetImage("assets/tigers.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         const Text(
//                           "Tiger's Milk Claremont",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         const Row(
//                           children: [
//                             Icon(Icons.pin_drop, color: Colors.orange),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("21 Dyrer Street Claremont",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                     )),
//                                 Text('5.2 Km from here',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                     )),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const Row(
//                           children: [
//                             Icon(Icons.watch_later_outlined,
//                                 color: Colors.orange),
//                             Text("Open Now"),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text('Closes at 12.00 am',
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               color: Colors.grey,
//                               child: const Wrap(
//                                 children: [
//                                   Text(
//                                     'Breakfast',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               color: Colors.grey,
//                               child: const Wrap(
//                                 children: [
//                                   Text(
//                                     'Lunch',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               color: Colors.grey,
//                               child: const Wrap(
//                                 children: [
//                                   Text(
//                                     'Bar',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     )
//                   ]),
//                 ),
//               )