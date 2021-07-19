import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';

abstract class ConnectButtonEvent {}

class StageChangeEvent extends ConnectButtonEvent {
  StageChangeEvent(this.stage);

  final String stage;
}

class StatusChangeEvent extends ConnectButtonEvent {
  StatusChangeEvent(this.status);

  final VpnStatus status;
}

abstract class ConnectButtonState {
  const ConnectButtonState();
}

class Disconnected extends ConnectButtonState {}

class Reconnecting extends ConnectButtonState {}

class Connected extends ConnectButtonState {
  const Connected(this.duration);

  final String duration;

  Connected.copyWith({this.duration});
}

class Connecting extends ConnectButtonState {}

class ConnectButtonBloc extends Bloc<ConnectButtonEvent, ConnectButtonState> {
  ConnectButtonBloc() : super(Disconnected());

  @override
  Stream<ConnectButtonState> mapEventToState(ConnectButtonEvent event) async* {



    if (event is StageChangeEvent) {

      final newState = mapStage(event.stage);
      // reconnect state is when:
      // 1. connected,
      // 2. got switch event
      // ...
      // 3. should last till 'connected' event in 'reconnection' state
      if (event.stage == 'switch') {
        if (state is !Disconnected) {
          yield Connecting();
          return;
        }
        // reconnect
      }

      if (state is Connecting) {
        // todo skip disconnect only in reconnection state
        if (newState is Disconnected) {
          // skip-ignore a disconnect
          yield state;
          return;
        } else {
          yield newState;
          return;
        }
      }

      yield newState;
    }

    if (event is StatusChangeEvent) {
      if (state is Connected) {
        yield Connected(event.status.duration);
      }
    }
  }

  mapStage(String stage) {
    switch (stage) {
      case NizVpn.vpnConnected:
        return Connected('00:00:00');
        break;
      case NizVpn.vpnNoConnection:
      case NizVpn.vpnDenied:
      case NizVpn.vpnDisconnected:
        return Disconnected();
        break;
      // these states return same widget, no break needed:
      case NizVpn.vpnConnecting:
      case NizVpn.vpnWaitConnection:
      case NizVpn.vpnPrepare:
      case NizVpn.vpnAuthenticating:
      case NizVpn.vpnReconnect:
      case 'switch':
        return Connecting();
        break;
      default:
        return Disconnected();
        break;
    }
  }

  updateStage(String stage) => add(StageChangeEvent(stage));
  updateStatus(VpnStatus status) => add(StatusChangeEvent(status));

  void switchServer() {
    add(StageChangeEvent('switch'));
    print('switch server emitted "switch" event');
    //add(Reconnecting());
  }

}
