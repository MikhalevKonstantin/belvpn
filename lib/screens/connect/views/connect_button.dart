import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_belvpn/core/logic/connect_button_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/screens/connect/widgets/round_shadow_button.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundShadowButton(
      child: BlocBuilder(
        bloc: BlocProvider.of<VpnBloc>(context).connectButtonBloc,
        builder: (context, state) {
          var icon;
          var text = '';

          if (state is Disconnected) {
            icon = _SvgIcon('power.svg');
          }

          if (state is Connecting) {
            icon = _ProgressSpinner();
          }

          if (state is Connected) {
            icon = _SvgIcon('connected.svg');
            text = state.duration;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon
              IconButton(
                icon: icon,
                onPressed: () {
                  BlocProvider.of<VpnBloc>(context, listen: false).connect();
                },
              ),
              // status text
              if (state is Connected)
                Text(
                  text,
                  style: TextStyle(color: Colors.white),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressSpinner extends StatelessWidget {
  const _ProgressSpinner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: Colors.white,
      size: MediaQuery.of(context).size.width / 10,
      lineWidth: 3,
    );
  }
}

class _SvgIcon extends StatelessWidget {
  const _SvgIcon(this.iconName, {Key key}) : super(key: key);
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg_icons/$iconName',
      color: Colors.white,
      height: MediaQuery.of(context).size.width / 10,
    );
  }
}
