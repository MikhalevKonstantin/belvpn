import 'package:bloc/bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

part 'eula_state.dart';

class EulaCubit extends Cubit<EulaState> {
  EulaCubit() : super(EulaInitial()) {
    try {
      updateFromStorage();
    } catch (e) {
      print(e);
    }
  }

  updateFromStorage() async {
    final accepted = await _get();
    if (accepted != null && accepted) {
      emit(EulaAccepted());
    } else
      emit(EulaPending());
  }

  _get() async {
    final storage = LocalStorage('eula');
    await storage.ready;
    return storage.getItem('accepted') as bool;
  }

  _put(bool accepted) async {
    final storage = LocalStorage('eula');
    await storage.ready;
    if (accepted != null) {
      storage.setItem('accepted', accepted);
    }
  }

  accept() async {
    // try saving

    _put(true);

    updateFromStorage();
  }
}
