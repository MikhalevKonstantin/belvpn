import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/models/vpnStatus.dart';

class TrafficCounterBloc extends Cubit<VpnStatus>{
  TrafficCounterBloc() : super(VpnStatus());

  // listens to vpn status bloc
  // sums up the traffic periodically
  //

@override
  void onChange(Change<VpnStatus> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change.nextState.byteOut);

  }
}