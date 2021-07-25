import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
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

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(Disconnected());


  @override
  void onChange(Change<ConnectionState> change) {
    super.onChange(change);

    print("[CONNECTION_BLOC STATE]:  ${change.currentState.runtimeType} => ${change.nextState.runtimeType}");
  }

  @override
  void onEvent(ConnectionEvent event) {
    super.onEvent(event);

    print("[CONNECTION_BLOC EVENT]: ${event.runtimeType} ${(event is StageChangeEvent? 'wants push ${event.stage} over ${state.runtimeType}':'')}");
  }

  @override
  Stream<ConnectionState> mapEventToState(ConnectionEvent event) async* {
    // stage changes =>
    // reduce stage to:  disconnected / connecting / connected

    // if(event is Toggle){
    // state is Disconnected?
    //     connect() : disconnect();
    // }
    //

    if(event is DisconnectRequested){
      yield Disconnected();
      NizVpn.stopVpn();
    }

    if(event is ConnectionRequested){
      if(state is !Reconnecting) {
        yield Connecting();
      }
    }

    if (event is StageChangeEvent) {
      final newState = mapStage(event);

      if (state is Reconnecting) {

        // todo skip disconnect only in reconnection state
        if (newState is Disconnected) {
          // skip-ignore a disconnect
          yield state;
          return;
        }
        else if(newState is !Connecting){
          yield newState;
          return;
        }
      } else {

        if (newState.toString() != state.toString()) {
          yield newState;
        }
      }
    }

    // reconnect state is when:
    // 1. connected,
    // 2. got switch event
    // ...
    // 3. should last till 'connected' event in 'reconnection' state
    if (event is SwitchServerEvent) {
      // if (state is! Disconnected) {
        yield Reconnecting();
        return;
      // }
      // reconnect
    }
  }

  mapStage(StageChangeEvent event) {
    switch (event.stage) {
      case NizVpn.vpnConnected:
        return Connected();
        break;
      case NizVpn.vpnDisconnected:
        return Disconnected();
        break;
      // these states return same widget, no break needed:
      case NizVpn.vpnNoConnection:
      case NizVpn.vpnDenied:
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

  updateStage(String stage) => add(StageChangeEvent(stage));

  // updateStatus(VpnStatus status) => add(StatusChangeEvent(status));

  void switchServer() {
    add(SwitchServerEvent());
  }

  void onConnectionRequested()=>add(ConnectionRequested());

  // void connect() => _connect();

  void disconnect()=> add(DisconnectRequested());

  void limitReached() => add(LimitReached());





}

class LimitReached extends ConnectionEvent {
}

class Toggle extends ConnectionEvent {
}

class DisconnectRequested extends ConnectionEvent {
}

class ConnectionRequested extends ConnectionEvent {
}

abstract class ConnectionEvent {}

class StageChangeEvent extends ConnectionEvent {
  StageChangeEvent(this.stage);

  final String stage;
}

class SwitchServerEvent extends ConnectionEvent {
  SwitchServerEvent();
}

class StatusChangeEvent extends ConnectionEvent {
  StatusChangeEvent(this.status);

  final VpnStatus status;
}
