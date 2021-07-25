import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';

class VpnStatusBLoc extends Cubit<VpnStatus>{
  VpnStatusBLoc() :  super(VpnStatus()){

    NizVpn.vpnStatusSnapshot().listen(emit);
  }
}