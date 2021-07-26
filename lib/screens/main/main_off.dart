import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/screens/connect/connect.dart';
import 'package:open_belvpn/screens/settings/settings.dart';
import 'package:open_belvpn/screens/splash/splash.dart';

class MainOff extends StatefulWidget {
  // const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainOff> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VpnBloc>(
      create: (_) => VpnBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: Colors.black,
            unselectedItemColor: Color(0x66101010),
            selectedItemColor: Color(0xFF101010),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg_icons/home.svg',
                    color: _selectedIndex == 0
                        ? Color(0xFF101010)
                        : Color(0x66101010),
                  ),
                  label: '1'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg_icons/setting.svg',
                    color: _selectedIndex == 1
                        ? Color(0xFF101010)
                        : Color(0x66101010),
                  ),
                  label: '2'),
            ],
          ),
          body: AppBody(
            pageIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  static List<Widget> _widgetOptions = <Widget>[
    ConnectScreen(),
    SettingsScreen(),
  ];

  const AppBody({
    Key key,
    this.pageIndex,
  }) : super(key: key);
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).proBloc,
      builder: (BuildContext context, ProState state) {
        if (state is Ready && state.isPro) {
          return _widgetOptions[pageIndex];
        } else {
          return Splash();
        }
      },
    );
  }
}

// Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Text(' VPN Security',
//               style: GoogleFonts.lato(
//                   color: Colors.black,
//                   fontSize: 19,
//                   fontWeight: FontWeight.bold)),
//         ),
//         body: Column(
//           children: [
//             Center(
//               child: TextButton(
//                 child: Text("aa"),
//                 onPressed: () {},
//               ),
//             ),
//             TextButton(onPressed: () {}, child: Text('data'))
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           selectedItemColor: Color(0xFF101010),
//           unselectedItemColor: Color(0x66101010),
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           items: [
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/svg_icons/home.svg",
//                 ),
//                 label: '1'),
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/svg_icons/setting.svg",
//                 ),
//                 label: '2'),
//           ],
//         ),
//       ),
