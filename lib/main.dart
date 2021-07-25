import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_belvpn/screens/splash/splash.dart';
import 'ui/screens/mainScreen.dart';

import 'screens/main/main_off.dart' as MainScreen2;

main() async {
  // runApp(MaterialApp(home: Root()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Root());
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Splash();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MainScreen2.MainOff();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Splash();
      },
    );
  }
}
