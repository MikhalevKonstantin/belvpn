import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/logic/ip_address_bloc/ip_address_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/in_app_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/remote_products_config.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/remote_servers_bloc.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/selected_server_bloc.dart';
import 'package:open_belvpn/core/logic/traffic_counter/traffic_counter_bloc.dart';
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

    // productsBloc.stream.listen((skus) {
    //   subscriptionBloc.updateProducts(skus.values.toList());
    // });

    // fetches products SKUs from "Firebase Remote Config"
    productsBloc.init();

    // establishes the connection to IAPService is
    inAppBloc.init();

    trafficCounterBloc = TrafficCounterBloc();
    // emits status from NizVpn
    vpnStatusBloc = VpnStatusBLoc();
    // emits stages from NizVpn
    vpnStagesBloc = VpnStagesBloc();
    // timer
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
          // selectedServerBloc.emit(state.servers.first);
        }
      },
    );

    // React to VPN stages & status changes and emit states for button & details
    connectionBloc = new ConnectionBloc();

    // should refresh when pro && connection status changes to connected;
    ipAddressBloc = IpAddressBloc();

    // pipes new stages and statuses as events to connectButtonBloc and others
    vpnStatusBloc.stream.listen((status) {

      // connectionBloc.updateStatus(status);
      final libDuration = status.duration.parseDuration();
      if (libDuration != null) {
        vpnTimeBloc.onStatusUpdate(libDuration);
      }

      if (proBloc.state is Ready && (proBloc.state as Ready).isPro == false) {

        final total = status.totalIn + status.totalOut;
        trafficCounterBloc.updateTraffic(total);
      }
    });


    vpnStagesBloc.stream.listen((stage) {
      connectionBloc.updateStage(stage);
      print(stage);

      // on disconnect ->
      // if (stage == NizVpn.vpnDisconnected) {

      // if (total >= 0) {
      //   trafficCounterBloc.state.
      // }
      // }
    });

    NizVpn.refreshStage();

    // IP should be refreshed only in pro
    connectionBloc.stream.listen((state) async {
      // todo handle pro purchase case somehow

      final proState = proBloc.state;
      if (proState is Ready && proState.isPro) {
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
      }
      else {
        vpnTimeBloc.stop();
      }


      if (state is Reconnecting) {
        print('fire reconnect logic');
        try {
          // await _stagesSubscription.cancel();
          _connect();

          // todo test extensively & probably remove
          await for (var xz in vpnStagesBloc.stream) {
            if (xz == NizVpn.vpnDisconnected) {
              print('disconnected');
              break;
            }
            // break;
          }
        } catch (e) {
          print(e);
        }
        // stopvpn future can't be awaited for some reason
        // await Future.delayed(Duration(milliseconds: 2000));
        print(
            '1 second passed, initating connection to ${selectedServerBloc.state.country}');
        _connect();
      }
    });

    // Change location should work only when Pro subscription active
    selectedServerBloc.stream.listen((event) {
      final proState = proBloc.state;

      if (proState is Ready && proState.isPro) {
        _reconnect();
      }
    });

    proBloc.stream.listen((state) {
      //refresh
      if (state is ProUpdate && (state as ProLoaded).isPro) {
        ipAddressBloc.refresh();
      }
    });
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
    // await _statusSubscription.cancel();
    // await _stagesSubscription.cancel();
    connectionBloc.switchServer();
  }

  _connect() async {
    if (vpnStagesBloc.state != NizVpn.vpnDisconnected) {
      // disconnect
      print('disconnecting');
      NizVpn.stopVpn();
    } else {
      // connect
      print('connecting to ' + (currentVpnConfig as VpnConfig).name);
      connectionBloc.onConnectionRequested();

      NizVpn.startVpn(
        currentVpnConfig,
        dns: DnsConfig("23.253.163.53", "198.101.242.72"),
      );
    }
  }

  @override
  Stream<VpnBlocState> mapEventToState(VpnBlocEvent event) async* {
    // if(event is RotateServerEvent){
    //   print('rotate');
    //  await _rotateServer();
    //  yield state;
    // }
    //
    // yield state;
  }

  _disconnect() {
    connectionBloc.disconnect();
    //_connect();
  }

//
// @override
// Stream<VpnBlocEvent> transform(Stream<VpnBlocEvent> events) {
//   return (events as Observable<VpnBlocEvent>)
//       // .throttle(Duration(milliseconds: 40)
//       // .debounce... etc
//       ;
// }
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
