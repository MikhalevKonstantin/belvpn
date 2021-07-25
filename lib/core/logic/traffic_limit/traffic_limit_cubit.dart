import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'traffic_limit_state.dart';

class TrafficLimitCubit extends Cubit<bool> {
  TrafficLimitCubit() : super(false);

  static const _limit = 50 * 1024 * 1024;

  limitReached() {
    emit(true);
  }

  void onTraffic(int event, bool isPro) {
    if (event > _limit) {
      if (!state) limitReached();
    }
    if (isPro && state) emit(false);
  }
}
