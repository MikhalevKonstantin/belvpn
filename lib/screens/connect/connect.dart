import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/screens/connect/ip.dart';
import 'package:open_belvpn/screens/connect/locations.dart';
import 'package:open_belvpn/screens/subscription/subscription.dart';
import 'package:open_belvpn/ui/screens/mainScreen.dart';
import 'package:open_belvpn/screens/main/main_off.dart' as main_off;
import 'package:open_belvpn/core/models/dnsConfig.dart';
import 'package:open_belvpn/core/models/vpnConfig.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_belvpn/screens/connect/connect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:loading_gifs/loading_gifs.dart';

class ConnectScreen extends StatefulWidget {
  ConnectScreen({
    Key key,
    this.onPurchased,
  }) : super(key: key);
  bool premium = false;
  final Function() onPurchased;

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  String _vpnState = NizVpn.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig _selectedVpn;
  int show = 1;
  bool premium = false;

  void buyPremium() {
    setState(() {
      premium = !premium;
    });
  }

  @override
  void initState() {
    ///Add listener to update vpnstate
    NizVpn.vpnStageSnapshot().listen((event) {
      print('stage snapshot update');
      setState(() {
        _vpnState = event;
        print('${_vpnState}');
      });
    });

    NizVpn.vpnStatusSnapshot().listen((event) {
      print('status snapshot update');
      setState(() {
        //_vpnState = event.toString();
        print('${event}');
      });
    });

    ///Call initVpn
    initVpn();

    super.initState();
  }

  ///Here you can start fill the listVpn, for this simple app, i'm using free vpn from https://www.vpngate.net/
  void initVpn() async {
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString("assets/vpn/nl.ovpn"),
        name: "Netherlands"));
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString("assets/vpn/sg.ovpn"),
        name: "Singapore"));
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString("assets/vpn/ca.ovpn"),
        name: "Canada"));
    if (mounted)
      setState(() {
        _selectedVpn = _listVpn.first;
      });
  }

  void connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_vpnState == NizVpn.vpnDisconnected) {
      ///Start if stage is disconnected
      NizVpn.startVpn(
        _selectedVpn,
        // dns: DnsConfig("8.8.8.8", "8.8.4.4"),
        dns: DnsConfig("23.253.163.53", "198.101.242.72"),
      );
    } else {
      ///Stop if stage is "not" disconnected
      NizVpn.stopVpn();
    }
  }

  static const String vpnConnected = "connected";
  static const String vpnDisconnected = "disconnected";
  static const String vpnWaitConnection = "wait_connection";
  static const String vpnAuthenticating = "authenticating";
  static const String vpnReconnect = "reconnect";
  static const String vpnNoConnection = "no_connection";
  static const String vpnConnecting = "connecting";
  static const String vpnPrepare = "prepare";
  static const String vpnDenied = "denied";

  buildSvgIcon(String iconName) {
    return SvgPicture.asset(
      'assets/svg_icons/$iconName',
      color: Colors.white,
      height: MediaQuery.of(context).size.width / 10,
    );
  }

  buildVpnStatus(String vpnState) {
    switch (vpnState) {
      case vpnConnected:
        return buildSvgIcon('connected.svg');
        break;
      case vpnNoConnection:
      case vpnDenied:
      case vpnDisconnected:
        return buildSvgIcon('power.svg');
        break;
      // these states return same widget, no break needed:
      case vpnConnecting:
      case vpnWaitConnection:
      case vpnPrepare:
      case vpnAuthenticating:
      case vpnReconnect:
        return SpinKitRing(
          color: Colors.white,
          size: MediaQuery.of(context).size.width / 10,
          lineWidth: 3,
        );
        break;
      default:
        return SpinKitRing(
          color: Colors.white,
          size: MediaQuery.of(context).size.width / 10,
          lineWidth: 3,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(' VPN Security',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
            if (premium)
              Text(' Premium',
                  style: GoogleFonts.lato(
                      color: Color(0xFF007aff),
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Color(0xff007aff),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff007aff),
                          blurRadius: 32.0,
                          // spreadRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: buildVpnStatus(_vpnState),
                          onPressed: () {
                            _selectedVpn = _listVpn[0];
                            connectClick();
                          },
                        ),
                        show == 3
                            ? Text('Data',
                                style: TextStyle(color: Colors.white))
                            : Center()
                      ],
                    ),
                  ),
                  // Image.asset(cupertinoActivityIndicator, scale: i),
                  Text('TAP TO CONNECT',
                      style: GoogleFonts.lato(
                          color: Color(0x99101010),
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                  // MainScreen()
                ],
              ),
            ),
            Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(bottom: 16),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Color(0xFFE5E5EA),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(16),
                //       ),
                //     ),
                //     child: ListTile(
                //         onTap: () {
                //           _selectedVpn = _listVpn[0];
                //           connectClick();
                //         },
                //         leading: Image.asset('assets/images/netherlands.png'),
                //         // ('assets/svg_icons/usa2.svg'),
                //         title: Text('Netherlands',
                //             style: GoogleFonts.lato(
                //                 color: Colors.black,
                //                 fontSize: 17,
                //                 fontWeight: FontWeight.w500)),
                //         trailing:
                //             SvgPicture.asset('assets/svg_icons/stroke3.svg')),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 16),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Color(0xFFE5E5EA),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(16),
                //       ),
                //     ),
                //     child: ListTile(
                //         onTap: () {
                //           _selectedVpn = _listVpn[1];
                //           connectClick();
                //         },
                //         leading: Image.asset('assets/images/singapore.png'),
                //         // ('assets/svg_icons/usa2.svg'),
                //         title: Text('Singapore',
                //             style: GoogleFonts.lato(
                //                 color: Colors.black,
                //                 fontSize: 17,
                //                 fontWeight: FontWeight.w500)),
                //         trailing:
                //             SvgPicture.asset('assets/svg_icons/stroke3.svg')),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeLocation()),
                          );
                        },
                        leading: Image.asset('assets/images/canada.png'),
                        // ('assets/svg_icons/usa2.svg'),
                        title: Text('Canada',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        trailing:
                            SvgPicture.asset('assets/svg_icons/stroke3.svg')),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 16,
                  // height: 106,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (premium) GetIP(),

                        // ListTile(
                        //   title: Text('Current IP: 193.84.63.60',
                        //       style: GoogleFonts.lato(
                        //           color: Colors.black,
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w500)),
                        //   trailing: Text('Country: US',
                        //       style: GoogleFonts.lato(
                        //           color: Colors.black,
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w500)),
                        // ),
                        if (premium)
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangeLocation()),
                                );
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              width: 2.5,
                                              color: Color(0xFF007AFF))))),
                              child: Text('Tap to change location',
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        if (!premium)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text('19 MB of 50 MB used',
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ),
                        if (!premium)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 64,
                              lineHeight: 14.0,
                              percent: 0.4,
                              progressColor: Colors.blue,
                            ),
                          ),

                        if (!premium)
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 64,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Subscription(
                                      onPurchased: () {
                                        buyPremium();
                                        print('premium now is $premium');
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              width: 2.5,
                                              color: Color(0xFF007AFF))))),
                              child: Text('Upgrade',
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
