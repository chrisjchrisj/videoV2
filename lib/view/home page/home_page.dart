import 'package:flutter/material.dart';
import 'package:video/Data/shared%20pref/shared_pref.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => UserPref.removeUser(),
      ),
    );
  }
}
