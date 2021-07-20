import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';

class VpnStatusBLoc extends Cubit<VpnStatus>{
  VpnStatusBLoc() : super(VpnStatus());
}