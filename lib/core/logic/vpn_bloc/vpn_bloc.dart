import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/logic/connect_button_bloc.dart';
import 'package:open_belvpn/core/logic/connection_bloc/connection_bloc.dart';
import 'package:open_belvpn/core/logic/ip_address_bloc/ip_address_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/in_app_bloc.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/remote_servers_bloc.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/selected_server_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_stages_bloc/cubit.dart';
import 'package:open_belvpn/core/logic/vpn_status_bloc/vpn_status_bloc.dart';
import 'package:open_belvpn/core/models/dnsConfig.dart';
import 'package:open_belvpn/core/models/vpnConfig.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
// import 'package:rxdart/rxdart.dart';

class VpnBloc extends Bloc<VpnBlocEvent, VpnBlocState> {
  VpnStatusBLoc vpnStatusBloc;
  VpnStagesBloc vpnStagesBloc;
  RemoteServersBloc remoteServersBloc;
  SelectedServerBloc selectedServerBloc;
  InAppBloc inAppBloc;
  ProBloc proBloc;
  IpAddressBloc ipAddressBloc;

  ConnectionBloc connectionBloc;
  ConnectButtonBloc connectButtonBloc;

  VpnBloc() : super(VpnBlocStateInitial()) {
    // InApps
    inAppBloc = new InAppBloc();
    proBloc = new ProBloc();

    inAppBloc.init();
    inAppBloc.stream.listen((event) {
      if (event is InAppStateLoading) {
        print('doing nothing');
      }
      if (event is InAppStateReady) {
        proBloc.init();
      }
    });

    // NizVpn
    vpnStatusBloc = VpnStatusBLoc();
    vpnStagesBloc = VpnStagesBloc();
    // NizVpn.vpnStageSnapshot().listen((stage) {
    //   print('emitting stage: ${stage}');
    //   vpnStagesBloc.emit(stage);
    // });
    // NizVpn.vpnStatusSnapshot().listen((state){
    //
    //   print("==================");
    //   print(state.totalOut + state.totalIn);
    //   print("==================");
    //   vpnStatusBloc.emit(state);
    // });

    selectedServerBloc = new SelectedServerBloc();

    // loads servers from firebase
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

    connectButtonBloc = new ConnectButtonBloc();
    connectionBloc = new ConnectionBloc();

    // should refresh when pro && connection status changes to connected;
    ipAddressBloc = IpAddressBloc();

    // pipes new stages and statuses as events to connectButtonBloc and others
    vpnStatusBloc.stream
        .listen((status) => connectButtonBloc.updateStatus(status));

    vpnStagesBloc.stream.listen((stage) {
      print('stage changed $stage');
      connectionBloc.add(stage);
      connectButtonBloc.updateStage(stage);
    });

    connectionBloc.stream.listen((event) {
      // todo handle pro purchase case somehow
      final proState = proBloc.state;
      if (proState is Ready) {
        // todo handle pro purchase case somehow
        if (proState.isPro) {
          ipAddressBloc.refresh();
        }
      }
    });
  }

  get currentVpnConfig => VpnConfig(
      name: selectedServerBloc.state.country,
      config: selectedServerBloc.state.config);

  connect() => _connect();

  rotateServer() {
   // add(RotateServerEvent());

    _rotateServer();
  }

  _rotateServer() async {
    final currentCountry = selectedServerBloc.state.country;
    final list = remoteServersBloc.servers;

    var index = list.indexWhere((s) => s.country == currentCountry) + 1;
    if (index >= list.length) {
      index = 0;
    }
    print('stopping');
    // NizVpn.stopVpn();
    print('stopped');

    selectedServerBloc.select(list[index]);

    // await _statusSubscription.cancel();
    // await _stagesSubscription.cancel();

    connectButtonBloc.switchServer();
    connectionBloc.switchServer();

    NizVpn.stopVpn();


    print('changed server config');
    // _connect();
    await Future.delayed(Duration(milliseconds: 33));
    print('1 second passed, initating connection to ${selectedServerBloc.state.country}');
    // _connect();

    _connect();
    print('connect finished');
  }

  StreamSubscription _stagesSubscription;
  StreamSubscription _statusSubscription;

  _connect() async {
    if (vpnStagesBloc.state != NizVpn.vpnDisconnected) {
      // disconnect
      NizVpn.stopVpn();
    } else {
      // connect
      NizVpn.startVpn(
        currentVpnConfig,
        dns: DnsConfig("23.253.163.53", "198.101.242.72"),
      );

      // listen stages stream
      if (_stagesSubscription == null)
        _stagesSubscription = NizVpn.vpnStageSnapshot().listen(
          (stage) {
            vpnStagesBloc.emit(stage);
          },
        );

      // listen status stream
      if (_statusSubscription == null)
        _statusSubscription = NizVpn.vpnStatusSnapshot().listen(
          (state) {
            vpnStatusBloc.emit(state);
          },
        );
    }
  }

  // wait for servers list
  // initialize NizKit
  // load last server from prefs
  // wait for pro??
  // subscribe other blocs to NizVpn

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
class RotateServerEvent extends VpnBlocEvent{

}

// -----------------------------------------------------------------------------
// endregion

// ---------------
// region  states (todo: move separate file)
// -----------------------------------------------------------------------------
abstract class VpnBlocState {}

class VpnBlocStateInitial extends VpnBlocState {}
// -----------------------------------------------------------------------------
// endregion
