import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';

/// This bloc reduces all 9 NizVpn stages down to 3 :
/// Disconnected
/// Connecting
/// Connected
///
/// Used as an intermediate bloc to avoid code duplication

abstract class ConnectionState {}

class Connected extends ConnectionState {
  @override
  String toString() => 'connected';
}

class Connecting extends ConnectionState {
  @override
  String toString() => 'connecting';
}

class Reconnecting extends ConnectionState {
  @override
  String toString() => 'reconnecting';
}

class Disconnected extends ConnectionState {
  @override
  String toString() => 'disconnected';
}

class ConnectionBloc extends Bloc<String, ConnectionState> {
  ConnectionBloc() : super(Disconnected());

  @override
  Stream<ConnectionState> mapEventToState(String event) async* {
    final newState = mapStage(event);

    // reconnect state is when:
    // 1. connected,
    // 2. got switch event
    // ...
    // 3. should last till 'connected' event in 'reconnection' state
    if (event == 'switch') {
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



    if (newState.toString() != state.toString()) {
      yield newState;
    }
    // yield
  }

  mapStage(String stage) {
    switch (stage) {
      case NizVpn.vpnConnected:
        return Connected();
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
        return Connecting();
        break;
      default:
        return Disconnected();
        break;
    }
  }

  void switchServer() {
    add('switch');
  }
}
