import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_wyze/navpages/root_page.dart';

import '../models/user.dart';
import 'Auth/auth_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StreetWyzeUser?>(context, listen: true);

    // change route based on weather the user is logged on not
    if (user == null) {
      return const AuthScreen();
    } else {
      return const RootPage(root: 0);
    }
  }
}
