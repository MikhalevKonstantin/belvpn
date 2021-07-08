import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/screens/subscription/subscription.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Settings',
            style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('VPN Security',
                            style: GoogleFonts.lato(
                                color: Color(0xFF101010),
                                fontSize: 19,
                                fontWeight: FontWeight.bold)),
                        Text(' Premium',
                            style: GoogleFonts.lato(
                                color: Color(0xFF007aff),
                                fontSize: 19,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  // (!premium)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            ),
                            Text('   More vitrual locations'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            ),
                            Text('   Ultra-fast connection speed'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            ),
                            Text('   Ad-free experience'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // (!premium)
                  TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Subscription(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'More about Premium',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: null,
                    title: Text('Support'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    onTap: null,
                    title: Text('Privacy policy'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    title: Text('Terms of use'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    title: Text('About Us'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: MediaQuery.of(context).size.width - 37,
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                label: Text(
                  'Get Premium',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
