import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

class TrafficCounterBloc extends Cubit<int> {
  TrafficCounterBloc() : super(0) {
    try {
      updateFromStorage();
    } catch (e) {
      print(e);
    }
  }

  updateFromStorage()async {
    final saved = await _get();
    if(saved!=null) emit(saved);
  }

  _get() async {
    final storage = LocalStorage('free');
    await storage.ready;
    return storage.getItem('traffic') as int;
  }

  _put(int traffic) async {
    final storage = LocalStorage('free');
    await storage.ready;
    if (traffic != null && traffic > 0) {
      storage.setItem('traffic', traffic);
    }
  }

  updateTraffic(traffic) async {
    // try saving
    if (traffic != null && traffic > 0) {
      _put(traffic);
    }
    updateFromStorage();
  }
}
