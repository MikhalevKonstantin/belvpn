import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vpn_time_event.dart';

part 'vpn_time_state.dart';

class VpnTimeBloc extends Bloc<VpnTimeEvent, VpnTimeState> {
  VpnTimeBloc() : super(VpnTimerStopped());

  @override
  Stream<VpnTimeState> mapEventToState(
    VpnTimeEvent event,
  ) async* {
    if (event is StatusUpdateEvent) {
      final time = event.time;

      if (state is VpnTimerRunning) {
        // find diff
        // NizVpn 'connected event' and 'status.duration' have 0-4 seconds diff
        final diff = time - (state as VpnTimerRunning).time;
        if (diff.abs().inSeconds > 60) {
          print('syncing time');
          launchTimer(time);
        }
      } else {
        launchTimer(time);
      }
    }

    if (event is TickEvent) {
      yield VpnTimerRunning(event.time);
    }

    if (event is StopTimerEvent) {
      subscription?.cancel();
      yield VpnTimerStopped();
    }
  }

  Stream<Duration> ticker;
  StreamSubscription<Duration> subscription;

  launchTimer(time) async {
    if (subscription != null) await subscription.cancel();
    subscription = Ticker.tick(time).listen((event) {
      add(TickEvent(event));
    });
  }

  onStatusUpdate(Duration time) {
    if (time.inSeconds == 0) {
      return;
    }

    add(StatusUpdateEvent(time));
  }

  onConnected() {
    add(StatusUpdateEvent(Duration.zero));
  }

  void stop() => add(StopTimerEvent());
}

class Ticker {
  static Stream<Duration> tick(Duration startTime) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => startTime + Duration(seconds: x),
    );
  }
}
