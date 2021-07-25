import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/vpn_connection_bloc/connection_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';

class ConnectionStatusMessage extends StatelessWidget {
  const ConnectionStatusMessage({Key key}) : super(key: key);

  static final _defaultTextStyle = GoogleFonts.lato(
    color: Color(0x99101010),
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final proBloc = BlocProvider.of<VpnBloc>(context).proBloc;

    return DefaultTextStyle(
      style: _defaultTextStyle,
      child: BlocBuilder(
        bloc: proBloc,
        builder: (BuildContext context, ProState state) {
          if (state is Ready) {
            return state.isPro
                ? ConnectionStatusMessagePro()
                : ConnectionStatusMessageFree();
          } else {
            // loading etc
            return Container();
          }
        },
      ),
    );
  }
}

class ConnectionStatusMessagePro extends StatelessWidget {
  const ConnectionStatusMessagePro({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConnectionBloc bloc =
        BlocProvider.of<VpnBloc>(context).connectionBloc;

    return BlocBuilder(
        bloc: bloc,
        builder: (context, ConnectionState state) {
          var message, icon=false;
          if (state is Disconnected) {
            message = 'TAP TO CONNECT';
          }

          if (state is Connecting || state is Reconnecting) {
            message = 'CONNECTING';
          }

          if (state is Connected) {
            message = 'CONNECTED';
            icon = true;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon)
                Container(
                  alignment: Alignment.center,
                  width: 8,
                  height: 8,
                  decoration: new BoxDecoration(
                    color: Color(0xff4ED12D),
                    shape: BoxShape.circle,
                  ),
                ),
              SizedBox(width: 8,),
              Text(
                message,
              ),
            ],
          );
        });
  }
}

class ConnectionStatusMessageFree extends StatelessWidget {
  const ConnectionStatusMessageFree({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConnectionBloc bloc =
        BlocProvider.of<VpnBloc>(context).connectionBloc;

    return BlocBuilder(
        bloc: bloc,
        builder: (context, ConnectionState state) {
          String message = '';

          if (state is Connecting|| state is Reconnecting) {
            message = 'CONNECTING';
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
              ),
            ],
          );
        });
  }
}
