import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_connection_bloc/connection_bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/screens/connect/widgets/country_code.dart';
import 'package:open_belvpn/screens/connect/widgets/ip.dart';
import 'package:open_belvpn/screens/connect/widgets/rounded_box.dart';
import 'package:open_belvpn/screens/connect/widgets/text_button_filled.dart';
import 'package:open_belvpn/screens/connect/widgets/text_button_outlined.dart';
import 'package:open_belvpn/screens/subscription/subscription.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ConnectionDetails extends StatelessWidget {
  const ConnectionDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final proBloc = BlocProvider.of<VpnBloc>(context).proBloc;

    return RoundedBox(
      child: BlocBuilder(
        bloc: proBloc,
        builder: (context, ProState state) {
          if (state is Ready) {
            return state.isPro
                ? ConnectionDetailsPro()
                : ConnectionDetailsFree();
          } else {
            // loading etc
            return Container();
          }
        },
      ),
    );
  }
}

class ConnectionDetailsPro extends StatelessWidget {
  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  const ConnectionDetailsPro({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3 states:
    // [disconnected]:
    // -> ip address + country + outline button tap_to_change

    // [connecting]
    // -> ip address + change_location(:disabled(onTap=null))

    // [connected]
    // -> ip address + change_location(:active)

    final vpnBloc = BlocProvider.of<VpnBloc>(context);
    final bloc = vpnBloc.connectionBloc;

    return BlocBuilder(
      bloc: bloc,
      builder: (context, connectionState) {
        final handleTap = (connectionState is Connected)
            ? () {
                if (connectionState is Connected) {
                  // rotate location

                  BlocProvider.of<VpnBloc>(context, listen: false)
                      .rotateServer();
                  print('change location');
                }
              }
            : null;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment:
                (connectionState is Disconnected)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  IpAddressView(),
                  if(connectionState is Disconnected ) CountryCode(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              (connectionState is Disconnected)
                  ? OutlineTextButton(
                      text: 'Tap to change location',
                      onPressed:
                          BlocProvider.of<VpnBloc>(context, listen: false)
                              .connect,
                    )
                  : FilledTextButton(
                      text: 'Change location',
                      onPressed: handleTap,
                    ),
            ],
          ),
        );
      },
    );
  }
}

class ConnectionDetailsFree extends StatelessWidget {
  const ConnectionDetailsFree({Key key}) : super(key: key);

  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).trafficCounterBloc,
      builder: (context, int total) {
        // total, limit and % calculation

        var percent = 0.0;
        final limit = 50 * 1024 * 1024;
        // final total = status.totalOut + status.totalIn;
        if (total > 0) {
          percent = (total / limit);
        }

        final totalMB = formatBytes(total, 1);
        final limitMB = formatBytes(limit, 0);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('$totalMB  of $limitMB used', style: textStyle),
              SizedBox(height: 16),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 64,
                lineHeight: 14.0,
                percent: percent ?? 0.4,
                progressColor: Colors.blue,
              ),
              SizedBox(
                height: 8,
              ),
              OutlineTextButton(
                text: "Upgrade",
                icon: SvgPicture.asset(
                  'assets/svg_icons/crown.svg',
                  color: Color(0xff007AFF),
                  width: 16,
                  height: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => Subscription(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  buyPremiumMonthly() {}

  buyPremiumYearly() {}

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
