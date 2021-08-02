import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/screens/subscription/subscription.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _launched;
  String _phone = '';
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      // 'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      // 'version.release': build.version.release,
      // 'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      // 'version.baseOS': build.version.baseOS,
      // 'board': build.board,
      // 'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      // 'display': build.display,
      // 'fingerprint': build.fingerprint,
      // 'hardware': build.hardware,
      // 'host': build.host,
      // 'id': build.id,
      // 'manufacturer': build.manufacturer,
      // 'model': build.model,
      // 'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      // 'isPhysicalDevice': build.isPhysicalDevice,
      // 'androidId': build.androidId,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  final _urlPrivacy = 'https://amazon.com';
  final _urlTerms = 'https://google.com';
  final _urlAbout = 'https://yandex.ru';
  final _mail =
      'mailto:vpnocean2021@gmail.com?subject=Topic&body=<Type your message here>';

  void _launchURL(url) async => await canLaunch(url) ? await launch(url) : null;

  // : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTitle(),
              buildPremiumPlate(),
              buildSettingsButtons(),
              buildPremiumButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPremiumPlate() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
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
            BlocBuilder(
                bloc: BlocProvider.of<VpnBloc>(context).proBloc,
                builder: (ctx, state) {
                  final isPro = (state is Ready && state.isPro);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('VPN Vital Security',
                                style: GoogleFonts.lato(
                                    color: Color(0xFF101010),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            Text(' Premium',
                                style: GoogleFonts.lato(
                                    color: Color(0xFF007aff),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      // todo (!premium)
                      if (!isPro)
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF007aff),
                                  ),
                                  Text('   More vitrual locations',
                                      style: GoogleFonts.lato(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.55)),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF007aff),
                                  ),
                                  Text('   Ultra-fast connection speed',
                                      style: GoogleFonts.lato(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.55)),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF007aff),
                                  ),
                                  Text('   Ad-free experience',
                                      style: GoogleFonts.lato(
                                          color: Color(0xFF000000),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.55)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      // todo (!premium)
                      if (!isPro)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Subscription(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/svg_icons/crown.svg',
                            width: 24,
                            height: 24,
                            color: Color(0xff007aff),
                          ),
                          label: Text(
                            'More about Premium',
                            style: GoogleFonts.lato(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.55,
                              color: Color(0xff007aff),
                            ),
                          ),
                        )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text('Settings',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold)),
    );
  }

  buildSettingsButton({VoidCallback onTap, String title}) {
    return ListTile(
      onTap: onTap,
      title: Text(title,
          style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.55,
              color: Color(0xFF000000))),
      trailing: SvgPicture.asset(
        'assets/svg_icons/stroke3.svg',
        width: 16,
        height: 16,
        color: Color(0x4d101010),
      ),
    );
  }

  buildSettingsButtons() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          buildSettingsButton(
            title: "Support",
            onTap: () {
              _launched = _launchInBrowser(_mail + _deviceData.toString());
            },
          ),
          buildSettingsButton(
            title: "Privacy Policy",
            onTap: () {
              _launched = _launchInBrowser(_urlPrivacy);
            },
          ),
          buildSettingsButton(
            title: "Terms of use",
            onTap: () {
              _launched = _launchInBrowser(_urlTerms);
            },
          ),
          buildSettingsButton(
            title: "About Us",
            onTap: () {
              _launched = _launchInBrowser(_urlAbout);
            },
          ),
        ],
      ),
    );
  }

  buildPremiumButton() {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).proBloc,
      builder: (context, state) {
        if (state is Ready && state.isPro) {
          return SizedBox();
        }
        return Container(
          decoration: BoxDecoration(
            color: Color(0xff007aff),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          width: MediaQuery.of(context).size.width - 32,
          child: TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => Subscription(),
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/svg_icons/crown.svg',
              color: Colors.white,
            ),
            label: Text(
              'Get Premium',
              style: GoogleFonts.lato(
                  color: Color(0xffffffff),
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
