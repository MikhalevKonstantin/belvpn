import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/logic/ip_address_bloc/ip_address_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/in_app_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/remote_products_config.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/remote_servers_bloc.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/selected_server_bloc.dart';
import 'package:open_belvpn/core/logic/traffic_counter/traffic_counter_bloc.dart';
import 'package:open_belvpn/core/logic/traffic_limit/traffic_limit_cubit.dart';
import 'package:open_belvpn/core/logic/vpn_connection_bloc/connection_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_stages_bloc/cubit.dart';
import 'package:open_belvpn/core/logic/vpn_status_bloc/vpn_status_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_timer_bloc/vpn_time_bloc.dart';
import 'package:open_belvpn/core/models/dnsConfig.dart';
import 'package:open_belvpn/core/models/geo_ip.dart';
import 'package:open_belvpn/core/models/vpnConfig.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:open_belvpn/screens/subscription/bloc/subscription_bloc.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:rxdart/rxdart.dart';

class VpnBloc extends Bloc<VpnBlocEvent, VpnBlocState> {
  ConnectionBloc connectionBloc;

  InAppBloc inAppBloc;

  IpAddressBloc ipAddressBloc;

  ProBloc proBloc;

  ProductsBloc productsBloc;
  RemoteServersBloc remoteServersBloc;
  SelectedServerBloc selectedServerBloc;

  SubscriptionBloc subscriptionBloc;

  TrafficCounterBloc trafficCounterBloc;
  TrafficLimitCubit trafficLimit;

  VpnStatusBLoc vpnStatusBloc;
  VpnStagesBloc vpnStagesBloc;

  StreamSubscription proReadyStream;

  VpnTimeBloc vpnTimeBloc;

  VpnBloc() : super(VpnBlocStateInitial()) {
    // Remote config for products
    productsBloc = ProductsBloc();
    // InApps connection;
    inAppBloc = new InAppBloc();
    // Pro subscriptions
    proBloc = new ProBloc();

    // wait until 2 blocs emit readiness states: FB Remote Config & IAP Service
    proReadyStream = Rx.combineLatest2<InAppBlocState, Map<String, String>,
        Map<String, String>>(
      inAppBloc.stream,
      productsBloc.stream,
      (inAppState, products) {
        bool ready = inAppState is InAppStateReady && products != null;
        if (ready)
          return products;
        else
          return null;
      },
    ).listen((products) {
      // start checking state of subscriptions if lib & product_ids ready
      if (products != null) {
        proBloc.init(products);
        subscriptionBloc.updateProducts(products.values.toList());
      } else {
        print('Trying to determine subscription status');
      }
    });

    subscriptionBloc = SubscriptionBloc();
    subscriptionBloc.stream.listen((state) {
      // todo think of cases when purchase fails but pro should be enabled
      if (state is PurchaseFailed) {
        proBloc.add(ProLoaded(false));
      }

      if (state is FinalizePurchase) {
        proBloc.add(ProLoaded(true));
      }
    });


    // fetches products SKUs from "Firebase Remote Config"
    productsBloc.init();

    // establishes the connection to IAPService
    inAppBloc.init();

    trafficCounterBloc = TrafficCounterBloc();
    // emits status from NizVpn
    vpnStatusBloc = VpnStatusBLoc();
    // emits stages from NizVpn
    vpnStagesBloc = VpnStagesBloc();
    // timer logic
    vpnTimeBloc = VpnTimeBloc();

    // holds the state of currently selected server (modal/change location btn)
    selectedServerBloc = new SelectedServerBloc();

    // fetches VPN ServerInfo`s from Firestore
    remoteServersBloc = RemoteServersBloc();
    remoteServersBloc.fetch();
    remoteServersBloc.stream.listen(
      (RemoteServersState state) {
        if (state is RemoteServersLoaded) {
          // todo last saved from prefs?
          selectedServerBloc.emit(state.servers.first);
        }
      },
    );

    // React to VPN stages & status changes and emit states for button & details
    connectionBloc = new ConnectionBloc();

    // should refresh when pro && connection status changes to connected;
    ipAddressBloc = IpAddressBloc();

    // pipes new stages and statuses as events to timer and traffic blocs
    vpnStatusBloc.stream.listen((status) {
      // connectionBloc.updateStatus(status);
      final libDuration = status.duration.parseDuration();
      if (libDuration != null) {
        vpnTimeBloc.onStatusUpdate(libDuration);
      }

      if (isPro == false) {
        final total = status.totalIn + status.totalOut;
        trafficCounterBloc.updateTraffic(total);
      }
    });

    // pipe vpn connection state
    vpnStagesBloc.stream.listen(connectionBloc.updateStage);
    NizVpn.refreshStage();

    // IP should be refreshed only in pro
    connectionBloc.stream.listen((state) async {
      // todo handle pro purchase case somehow
      // ip refresh logic
      if (isPro) {
        if (state is Disconnected) {
          ipAddressBloc.refresh();
        }
        if (state is Connecting || state is Reconnecting) {
          ipAddressBloc.emit(GeoIP(selectedServerBloc.state.ip, null));
        }
      }

      // Timer logic
      if (state is Connected) {
        vpnTimeBloc.onConnected();
      } else {
        vpnTimeBloc.stop();
      }

      if (state is Reconnecting) {

        try {
          // disconnect ->
          _connect();
          // wait for disconnected stage
          await for (var stage in vpnStagesBloc.stream) {
            if (stage == NizVpn.vpnDisconnected) {
              print('disconnected');
              break;
            }
          }
        } catch (e) {
          print(e);
        }
        // -> connect to new server
        _connect();
      }
    });

    // Change location should work only when Pro subscription active
    selectedServerBloc.stream.listen((event) {
      if (isPro) {
        _reconnect();
      }
    });


    proBloc.stream.listen(
      (state) {
        if (isPro) {
          // refresh ip
          ipAddressBloc.refresh();
        }
      },
    );

    trafficLimit = TrafficLimitCubit();

    trafficCounterBloc.stream.listen((event) {
      trafficLimit.onTraffic(event, isPro);
    });

    trafficLimit.stream.listen(
      (limitReached) {
        if (limitReached) {
          disconnect();
        }
      },
    );
  }

  // gets current selected config (to start VPN)
  get currentVpnConfig => VpnConfig(
      name: selectedServerBloc.state.country,
      config: selectedServerBloc.state.config);

  connect() => _connect();

  disconnect() => _disconnect();

  // picks next server from the list, in a circular way
  rotateServer() {
    final currentCountry = selectedServerBloc.state.country;
    final list = remoteServersBloc.servers;

    var index = list.indexWhere((s) => s.country == currentCountry) + 1;
    if (index >= list.length) {
      index = 0;
    }

    selectedServerBloc.select(list[index]);
  }

  _reconnect() async {
    connectionBloc.switchServer();
  }

  _connect() async {
    if (vpnStagesBloc.state != NizVpn.vpnDisconnected) {
      // disconnect
      print('disconnecting');
      NizVpn.stopVpn();
    } else {
      // do not connect if traffic limit reached

      if (!trafficLimit.state || isPro) {
        print('connecting to ' + (currentVpnConfig as VpnConfig).name);
        connectionBloc.onConnectionRequested();
        NizVpn.startVpn(
          currentVpnConfig,
          dns: DnsConfig("23.253.163.53", "198.101.242.72"),
        );
      } else {
        connectionBloc.limitReached();
      }
    }
  }

  bool get isPro => (proBloc.state is Ready) && (proBloc.state as Ready).isPro;

  @override
  Stream<VpnBlocState> mapEventToState(VpnBlocEvent event) async* {
  }

  _disconnect() {
    connectionBloc.disconnect();
    //_connect();
  }

}

// ---------------
// region  events (todo: move separate file)
// -----------------------------------------------------------------------------

/// Base event for VpnBloc input
abstract class VpnBlocEvent {}

class RotateServerEvent extends VpnBlocEvent {}

// -----------------------------------------------------------------------------
// endregion

// ---------------
// region  states (todo: move separate file)
// -----------------------------------------------------------------------------
abstract class VpnBlocState {}

class VpnBlocStateInitial extends VpnBlocState {}
// -----------------------------------------------------------------------------
// endregion

extension on String {
  Duration parseDuration() {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    List<String> parts = this.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = int.parse(parts[parts.length - 1]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
