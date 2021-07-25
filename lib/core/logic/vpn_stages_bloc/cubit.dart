import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:rxdart/rxdart.dart';

/// This bloc is controlled by NizVpn in VpnBloc
class VpnStagesBloc extends Cubit<String> {

  VpnStagesBloc() : super(NizVpn.vpnDisconnected){
   NizVpn.vpnStageSnapshot().listen(emit);
  }
}
