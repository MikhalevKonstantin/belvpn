import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';

class IpAddressView extends StatelessWidget {
  IpAddressView({Key key}) : super(key: key);

  final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {

    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).ipAddressBloc,
      builder: (context, ip) {
        return GestureDetector(
          onTap: () {
            print('ok');
            BlocProvider.of<VpnBloc>(context, listen: false)
                .ipAddressBloc
                .refresh();
          },
          child: Container(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                  text: "Current IP:",
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                  TextSpan(
                    text: "$ip",
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
