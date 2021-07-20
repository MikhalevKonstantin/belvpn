import 'package:bloc/bloc.dart';
import 'package:dart_ipify/dart_ipify.dart';

// abstract class IpAddressEvent {}
//
// class FirstIpAddressEvent extends IpAddressEvent {
//
// }
//
// class IpAddressBloc extends Bloc<IpAddressEvent, IpAddressState> {
//   IpAddressBloc(initialState) : super(initialState);
//
//   @override
//   IpAddressState get initialState => IpLoading();
//
//   @override
//   Stream<IpAddressState> mapEventToState(
//        IpAddressEvent event) async* {
//
//
//   }
// }
//
//
//
// abstract class IpAddressState {
//
// }
//
// class IpLoading extends IpAddressState{
//
// }
//
// class IpLoaded extends IpAddressState{
//
// }
//
// class IpError extends IpAddressState{
//
// }
//
// class IpUnknown extends IpAddressState{
//
// }

class IpAddressBloc extends Cubit<String>{
  IpAddressBloc() : super('');


  refresh() async {

    // final ip = await IpAddress().getIp();//Ipify.geo('at_BfFn5Fg6iMjEOCn6RT8X1FGET6DD1');

    await Future.delayed(Duration(milliseconds: 2000));
    // final ip = await Dio().get('https://api64.ipify.org');
    final ip = await Ipify.ipv4();
    //
    print('new ip i ${ip}');
    emit(" ${ip}");
  }

}