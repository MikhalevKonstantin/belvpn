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
    remoteConfig.addListener(fetch);
    _updateState();
  }

  @override
  Future<Function> close() {
    remoteConfig.removeListener(fetch);
    return super.close();
  }

  fetch() async {
    bool updated = await remoteConfig.fetchAndActivate();

    if (updated) {
      _updateState();
      // the config has been updated, new parameter values are available.
    } else {
      // the config values were previously updated.
    }
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
