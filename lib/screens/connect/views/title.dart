import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';

class ConnectScreenTitle extends StatelessWidget {
  static final titleStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 19,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VpnBloc>(context).proBloc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VPN Vital Security',
          style: titleStyle,
        ),
        BlocBuilder(
            bloc: bloc,
            builder: (_, proState) {
              var text = '';
              if (proState is Ready && proState.isPro) {
                text = ' Premium';
              }
              return Text(text,
                  style: titleStyle.copyWith(
                    color: Color(0xFF007aff),
                  ));
            }),
      ],
    );
  }
}
