import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_belvpn/screens/connect/connect.dart';

class Subscription extends StatefulWidget {
  Subscription({
    Key key,
    this.onPurchased,
  }) : super(key: key);

  final Function() onPurchased;

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool monthly = true;

  void setMonthly() {
    monthly = true;
  }

  void setYearly() {
    monthly = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(' VPN Security',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/subscription.png'),
                    Column(
                      children: [
                        Text("Start Your",
                            style: GoogleFonts.lato(
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF101010))),
                        Text('Subscription',
                            style: GoogleFonts.lato(
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF007AFF))),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Faster VPN servers, more virtual locations, ',
                            style: GoogleFonts.lato(
                                fontSize: 13, color: Color(0xFF101010))),
                        Text("ad-free experience",
                            style: GoogleFonts.lato(
                                fontSize: 13, color: Color(0xFF101010))),
                      ],
                    ),
                    // TODO buttons
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6, bottom: 6),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              // primary: Color(0xFF007AFF), //0xFF007AFF
                              backgroundColor: monthly
                                  ? Color(0xFFF2F2F7)
                                  : Color(0xFFE7E7EC),
                              //0xFFE7E7EC gray 0xFFF2F2F7 white
                              elevation: 4,
                              minimumSize: Size(54.0, 54.0),

                              side: BorderSide(
                                  color: monthly
                                      ? Color(0xFF007AFF)
                                      : Color(0xFFE7E7EC),
                                  width: 1.5),
                            ),
                            onPressed: () {
                              setState(() {
                                monthly = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monthly',
                                    style: GoogleFonts.lato(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF101010))),
                                Text("\$7.99",
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF101010))),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6, bottom: 6),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Color(0xFF007AFF),
                              //0xFF007AFF
                              backgroundColor: !monthly
                                  ? Color(0xFFF2F2F7)
                                  : Color(0xFFE7E7EC),
                              //0xFFE7E7EC gray 0xFFF2F2F7 white
                              elevation: 4,
                              minimumSize: Size(54.0, 54.0),

                              side: BorderSide(
                                  color: !monthly
                                      ? Color(0xFF007AFF)
                                      : Color(0xFFE7E7EC),
                                  width: 1.5),
                            ),
                            onPressed: () {
                              setState(() {
                                monthly = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Yearly',
                                    style: GoogleFonts.lato(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF101010))),
                                Text("\$49.99",
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF101010))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("Plan automatically renews weekly untill cancelled.",
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0x80101010))),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF007AFF),
                          padding: EdgeInsets.only(top: 16, bottom: 16)),
                      onPressed: () {
                        setState(() {
                          widget.onPurchased();
                        });

                        // Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SvgPicture.asset(
                              "assets/svg_icons/crown.svg",
                            ),
                          ),
                          Text('Get Premium',
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFFFFFF))),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF101010)),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Privacy Policy',
                              style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF101010)),
                            )),
                        // Divider(height: 22, thickness: 25, color: Colors.red),
                        TextButton(
                            onPressed: () {},
                            child: Text('Restore',
                                style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF101010)))),
                        // Divider(color: Colors.black),
                        TextButton(
                            onPressed: () {},
                            child: Text('Terms of Use',
                                style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF101010)))),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
