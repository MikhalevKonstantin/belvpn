import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/models/geo_ip.dart';
import 'package:open_belvpn/core/repository/ip_address_repository.dart';

class IpAddressBloc extends Cubit<GeoIP> {
  final IpAddressRepository repo;

  IpAddressBloc()
      : repo = new IpAddressRepository(),
        super(null) {
    refresh();
  }

  refresh() async {
    // final ip = await IpAddress().getIp();//Ipify.geo('at_BfFn5Fg6iMjEOCn6RT8X1FGET6DD1');

    // final ip = await Dio().get('https://api64.ipify.org');

    // emit(null);
    // Rx.retry(() => Rx.fromCallable(() => lookupUserCountry()), 5)
    //     .take(5)
    //     .listen((result) {
    //   emit(
    //     GeoIP(
    //       result['ip'],
    //       result['location']['country']['code'],
    //     ),
    //   );
    // });

    // final ip = await Ipify.ipv4();
    //

    final geo = await repo.getGeo();
    emit(geo);
  }
}
