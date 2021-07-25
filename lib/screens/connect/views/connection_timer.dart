import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_timer_bloc/vpn_time_bloc.dart';

extension on Duration {
  String printDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class ConnectionTimer extends StatefulWidget {
  static final textStyle = GoogleFonts.lato(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  const ConnectionTimer({Key key, this.time}) : super(key: key);

  final Duration time;

  @override
  _ConnectionTimerState createState() => _ConnectionTimerState();
}

class _ConnectionTimerState extends State<ConnectionTimer>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).vpnTimeBloc,
      builder: (context, state) {
        final running = state is VpnTimerRunning;

        return AnimatedOpacity(
          opacity: running ? 1.0 : 0.0,
          duration: const Duration(
            milliseconds: 400,
          ),
          child: AnimatedSize(
            vsync: this,
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 400),
            child: running
                ? Text(
                    (state as VpnTimerRunning).time.printDuration(),
                    style: ConnectionTimer.textStyle,
                  )
                : Container(),
          ),
        );
      },
    );
  }
}
