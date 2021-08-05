import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Cubit<Map<String, String>> {
  static final defaults = <String, String>{
    // 'premium_button_1': 'monthly',
    // 'premium_button_2': 'yearly',
  };

  ProductsBloc()
      : remoteConfig = RemoteConfig.instance
          ..setDefaults(defaults)
          ..setConfigSettings(RemoteConfigSettings(
              fetchTimeout: Duration(seconds: 3),
              minimumFetchInterval: Duration(seconds: 5))),
        super(defaults);

  final RemoteConfig remoteConfig;

  init() async {
    _updateState();
    remoteConfig.addListener(_updateState);
    remoteConfig.fetchAndActivate();
  }

  @override
  Future<Function> close() {
    remoteConfig.removeListener(_updateState);
    return super.close();
  }

  _updateState() {
    // decode current config
    final config = remoteConfig.getAll().map(
          (key, value) => MapEntry(
            key,
            value.asString(),
          ),
        );
    emit(config);
  }
}
