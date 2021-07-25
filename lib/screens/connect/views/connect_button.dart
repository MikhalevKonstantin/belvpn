import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_connection_bloc/connection_bloc.dart';
import 'package:open_belvpn/screens/connect/views/connection_timer.dart';
import 'package:open_belvpn/screens/connect/widgets/round_shadow_button.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).connectionBloc,
      builder: (context, state) {
        Widget icon;

        if (state is Disconnected) {
          icon = _SvgIcon(
            'power.svg',
            key: ValueKey('disconnected'),
          );
        }

        if (state is Connecting || state is Reconnecting) {
          icon = CircularProgressIndicator(
              key: ValueKey('connecting'),
              strokeWidth: 3.0,
              color: Colors.white);
        }

        if (state is Connected) {
          icon = _SvgIcon(
            'connected.svg',
            key: ValueKey('connected'),
          );
          // text = state.duration;
        }

        return RoundShadowButton(
          willDisconnect: state is! Disconnected,
          onPressed: () {
            if (state is! Disconnected)
              BlocProvider.of<VpnBloc>(context, listen: false)
                  .connectionBloc
                  .disconnect();
            else
              BlocProvider.of<VpnBloc>(context, listen: false).connect();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 420),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: icon,
                ),
              ),
              // status text
              if (state is Connected) ConnectionTimer(),
            ],
          ),
        );
      },
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
