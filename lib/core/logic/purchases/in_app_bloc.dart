import 'package:bloc/bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:rxdart/rxdart.dart';

class InAppBloc extends Bloc<InAppBlocEvent, InAppBlocState> {

  InAppBloc() : super(InAppBlocStateInitial());


  init() => this.add(InitializeInApp());
  

  @override
  Stream<InAppBlocState> mapEventToState(InAppBlocEvent event) async* {
    if (event is InitializeInApp) {
      yield InAppStateLoading();
      try {
        await FlutterInappPurchase.instance.initConnection;
      }catch (e){
        print(e);
      }
      yield InAppStateReady();
    }
  }

  // with Rx
  // @override
  // Stream<InAppBlocEvent> transform(Stream<InAppBlocEvent> events) {
  //   return (events as Observable<InAppBlocEvent>)
  //   // .throttle(Duration(milliseconds: 40)
  //   // .debounce... etc
  //       ;
  // }

  processFirstEvent(InitializeInApp event) {}


  // todo: call somewhere in parent stateful widget
  void dispose() async {
    await FlutterInappPurchase.instance.endConnection;
  }

}

// ---------------
// region  events (todo: move separate file)
// -----------------------------------------------------------------------------

/// Base event for InAppBloc input
abstract class InAppBlocEvent {}

class InitializeInApp extends InAppBlocEvent {}

// -----------------------------------------------------------------------------
// endregion

// ---------------
// region  states (todo: move separate file)
// -----------------------------------------------------------------------------
abstract class InAppBlocState {}

class InAppBlocStateInitial extends InAppBlocState {}

class InAppStateLoading extends InAppBlocState{}

class InAppStateReady extends InAppBlocState {}

class InAppBlocError {}

// -----------------------------------------------------------------------------
// endregion
