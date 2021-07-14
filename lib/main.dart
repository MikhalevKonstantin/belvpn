import 'package:flutter/material.dart';
import 'ui/screens/mainScreen.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'screens/main/main_off.dart' as MainScreen2;

main() {
  // runApp(MaterialApp(home: Root()));
  // if (defaultTargetPlatform == TargetPlatform.android) {
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

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
