part of 'vpn_time_bloc.dart';

@immutable
abstract class VpnTimeState {}

class VpnTimeInitial extends VpnTimeState {}

class VpnTimerRunning extends VpnTimeState {
  final Duration time;

  VpnTimerRunning(this.time);
}

class VpnTimerStopped extends VpnTimeState {}
