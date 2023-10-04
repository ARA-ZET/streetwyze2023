import 'package:flutter/material.dart';
import 'package:street_wyze/navpages/root_page.dart';

class RootSelector extends StatelessWidget {
  const RootSelector({super.key, required this.root});
  final int root;

  @override
  // select open navpages on selected index
  Widget build(BuildContext context) {
    if (root == 0) {
      return const RootPage(root: 0);
    }
    if (root == 1) {
      return const RootPage(root: 1);
    }
    if (root == 2) {
      return const RootPage(root: 2);
    } else {
      return const RootPage(root: 3);
    }
  }
}
