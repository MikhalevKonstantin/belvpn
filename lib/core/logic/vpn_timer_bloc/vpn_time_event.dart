part of 'vpn_time_bloc.dart';

@immutable
abstract class VpnTimeEvent {}

class TickEvent extends VpnTimeEvent {
  final Duration time;

  TickEvent(this.time);
}

class StatusUpdateEvent extends VpnTimeEvent {
  final Duration time;

  StatusUpdateEvent(this.time);
}

class StopTimerEvent extends VpnTimeEvent{}

