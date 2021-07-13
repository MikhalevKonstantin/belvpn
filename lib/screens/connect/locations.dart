import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

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
        children: [
          Image.asset('assets/images/netherlands.png'),
          Text('Netherlands',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
          Text('Current location',
              style: GoogleFonts.lato(
                  color: Color(0x80101010),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          Divider(
            height: 1,
            color: Color(0xffd1d1d6),
          ),
          ListTile(
            trailing: Icon(
              Icons.add_circle_rounded,
              color: Color(0xff007aff),
            ),
            leading: Image.asset('assets/images/netherlands.png'),
            subtitle: Text(
              'Best for general browsing',
              style: GoogleFonts.lato(
                  color: Color(0x33000000),
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
            title: Text(
              'Netherlands(Auto)',
              style: GoogleFonts.lato(
                  color: Color(0xff101010),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            'Location(3)',
            style: GoogleFonts.lato(
                color: Color(0x33101010),
                fontSize: 13,
                fontWeight: FontWeight.w400),
          ),
          ListTile(
            trailing: Icon(Icons.circle_outlined),
            leading: Image.asset('assets/images/netherlands.png'),
            title: Text(
              'Netherlands',
              style: GoogleFonts.lato(
                  color: Color(0xff101010),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            trailing: Icon(Icons.circle_outlined),
            leading: Image.asset('assets/images/singapore.png'),
            title: Text(
              'Singapore',
              style: GoogleFonts.lato(
                  color: Color(0xff101010),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            trailing: Icon(Icons.circle_outlined),
            leading: Image.asset('assets/images/canada.png'),
            title: Text(
              'Canada',
              style: GoogleFonts.lato(
                  color: Color(0xff101010),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
