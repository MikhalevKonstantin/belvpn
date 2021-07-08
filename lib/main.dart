import 'package:flutter/material.dart';
import 'ui/screens/mainScreen.dart';

import 'screens/main/main_off.dart' as MainScreen2;

main() {
  // runApp(MaterialApp(home: Root()));

  runApp(MainScreen2.MainOff());
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
