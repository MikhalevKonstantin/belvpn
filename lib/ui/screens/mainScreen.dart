/*
 * Copyright (c) 2020 Mochamad Nizwar Syafuan
 * Distributed under the GNU GPL v2 with additional terms. For full terms see the file doc/LICENSE.txt
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/models/dnsConfig.dart';
import 'package:open_belvpn/core/models/vpnConfig.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_belvpn/screens/connect/connect.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        child: Column(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SHOW START BUTTON W STATUS
              Center(
                child: FlatButton(
                  shape: StadiumBorder(),
                  child: Text(
                    _vpnState == NizVpn.vpnDisconnected
                        ? "Connect VPN!"
                        : _vpnState.replaceAll("_", " ").toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: connectClick,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // SHOW NETWORK SPEED N TRAFFIC USED
              StreamBuilder<VpnStatus>(
                initialData: VpnStatus(),
                stream: NizVpn.vpnStatusSnapshot(),
                builder: (context, snapshot) => Text(
                    "${snapshot?.data?.byteIn ?? ""}, ${snapshot?.data?.byteOut ?? ""}",
                    textAlign: TextAlign.center),
              ),
            ]
            // SHOW AVAILABLE SERVERS
            //i just make it simple, hope i'm not making you to much confuse
            // ..addAll(
            //   _listVpn != null && _listVpn.length > 0
            //       ? _listVpn.map(
            //           (e) => ListTile(
            //             title: Text(e.name),
            //             leading: SizedBox(
            //               height: 20,
            //               width: 20,
            //               child: Center(
            //                   child: _selectedVpn == e
            //                       ? CircleAvatar(backgroundColor: Colors.green)
            //                       : CircleAvatar(backgroundColor: Colors.grey)),
            //             ),
            //             onTap: () {
            //               if (_selectedVpn == e) return;
            //               log("${e.name} is selected");
            //               // NizVpn.stopVpn();
            //               setState(
            //                 () {
            //                   _selectedVpn = e;
            //                 },
            //               );
            //             },
            //           ),
            //         )
            //       : [],
            // ),
            ),
      ),
    );
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
}
