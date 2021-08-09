part of 'eula_cubit.dart';

@immutable
abstract class EulaState {}

class EulaInitial extends EulaState {}

class EulaPending extends EulaState {}

class EulaAccepted extends EulaState {}

