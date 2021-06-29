/*
 * Copyright (c) 2020 Mochamad Nizwar Syafuan
 * Distributed under the GNU GPL v2 with additional terms. For full terms see the file doc/LICENSE.txt
 */

import 'package:flutter/material.dart';
import 'ui/screens/mainScreen.dart';

import 'screens/main/main_screen.dart' as MainScreen2;

main() {
  runApp(MaterialApp(home: Root()));

  // runApp(MainScreen2.MainScreen());
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}
