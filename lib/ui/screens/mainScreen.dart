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
  // String _vpnState = NizVpn.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig _selectedVpn;

  @override
  void initState() {
    super.initState();

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
              // Center(
              //   child: FlatButton(
              //     shape: StadiumBorder(),
              //     child: Text(
              //       _vpnState == NizVpn.vpnDisconnected
              //           ? "Connect VPN!"
              //           : _vpnState.replaceAll("_", " ").toUpperCase(),
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     onPressed: connectClick,
              //     color: Theme.of(context).primaryColor,
              //   ),
              // ),

              // SHOW NETWORK SPEED N TRAFFIC USED
              // StreamBuilder<VpnStatus>(
              //   initialData: VpnStatus(),
              //   stream: NizVpn.vpnStatusSnapshot(),
              //   builder: (context, snapshot) => Text(
              //       "${snapshot?.data?.byteIn ?? ""}, ${snapshot?.data?.byteOut ?? ""}",
              //       textAlign: TextAlign.center),
              // ),
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

}
