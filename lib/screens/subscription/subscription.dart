import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/screens/subscription/bloc/subscription_bloc.dart';

import 'components/subscription_buttons.dart';

class Subscription extends StatefulWidget {
  Subscription({
    Key key,
    this.onPurchasedMonthly,
    this.onPurchasedYearly,
  }) : super(key: key);

  final Function onPurchasedMonthly;
  final Function onPurchasedYearly;

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  static final bottomButtonTextStyle = GoogleFonts.lato(
      fontSize: 10, fontWeight: FontWeight.w400, color: Color(0x80101010));

  static final bottomButtonTextStylePressed = GoogleFonts.lato(
      fontSize: 11, fontWeight: FontWeight.w400, color: Color(0x101010));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Stack(fit: StackFit.expand, children: [
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                          child: SvgPicture.asset(
                              'assets/svg_icons/Illustration.svg')
                          // Image.asset('assets/images/subscription.png'),
                          ),
                    ),

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
                    SizedBox(height: 8),
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
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocListener(
                          bloc: BlocProvider.of<VpnBloc>(context)
                              .subscriptionBloc,
                          listener: (BuildContext context, state) {
                            // close this modal
                            if (state is FinalizePurchase) {
                              Navigator.of(context).pop();
                            }

                            if (state is PurchaseFailed) {}
                          },
                          child: SubscriptionButtons(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Plan automatically renews weekly untill cancelled.",
                              style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0x80101010))),
                        ),
                      ],
                    ),
                    // SizedBox(height:8),

                    MaterialButton(
                      color: Color(0xFF007AFF),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        BlocProvider.of<VpnBloc>(context, listen: false)
                            .subscriptionBloc
                            .purchase();

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
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {},
                            // style:  ButtonStyle(padding: EdgeInsets.vertical),
                            child: Text(
                              'Privacy Policy',
                              style: bottomButtonTextStyle,
                            ),
                          ),
                          RowDivider(),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Restore',
                              style: bottomButtonTextStyle,
                            ),
                          ),
                          RowDivider(),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Terms of Use',
                              style: bottomButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class RowDivider extends StatelessWidget {
  const RowDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: VerticalDivider(
        thickness: 2,
      ),
    );
  }
}
