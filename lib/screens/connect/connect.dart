import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/ui/screens/mainScreen.dart';

import 'package:open_belvpn/core/models/dnsConfig.dart';
import 'package:open_belvpn/core/models/vpnConfig.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_belvpn/screens/connect/connect.dart';
// import 'package:loading_gifs/loading_gifs.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _OneScreenState createState() => _OneScreenState();
}

class _OneScreenState extends State<ConnectScreen> {
  String _vpnState = NizVpn.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig _selectedVpn;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpnstate
    NizVpn.vpnStageSnapshot().listen((event) {
      setState(() {
        _vpnState = event;
      });
    });

    ///Call initVpn
    initVpn();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(' VPN Security',
            style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.end,
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
                    child: IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {}),
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
                          _selectedVpn = _listVpn[0];
                          connectClick();
                        },
                        leading: Image.asset('assets/images/Oval.png'),
                        // ('assets/svg_icons/usa2.svg'),
                        title: Text('Netherlands',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        trailing:
                            SvgPicture.asset('assets/svg_icons/stroke3.svg')),
                  ),
                ),
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
                          _selectedVpn = _listVpn[1];
                          connectClick();
                        },
                        leading: Image.asset('assets/images/Oval.png'),
                        // ('assets/svg_icons/usa2.svg'),
                        title: Text('Singapore',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        trailing:
                            SvgPicture.asset('assets/svg_icons/stroke3.svg')),
                  ),
                ),
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
                          _selectedVpn = _listVpn[2];
                          connectClick();
                        },
                        leading: Image.asset('assets/images/Oval.png'),
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
                        ListTile(
                          title: Text('Current IP: 193.84.63.60',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          trailing: Text('Country: US',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                        ),
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
                                        borderRadius: BorderRadius.circular(8),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeLocation extends StatefulWidget {
  // ChangeLocation({Key? key}) : super(key: key);

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
