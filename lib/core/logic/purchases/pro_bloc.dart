import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class ProBloc extends Bloc<ProEvent, ProState> {
  ProBloc() : super(Loading());


  /// called when the list with products ids is fetched or updated
  Future init(Map<String, String> products) async {
    var skus = products.values.toList();
    var item = await _findProPurchase(skus);

    add(ProLoaded(item!=null));
  }

  Future consumePurchase() async {
    add(ProCancelRequested());
  }

  Future<PurchasedItem> _findProPurchase(List<String> skus) async {
    // todo compare firebase & availablePurchases
    List<PurchasedItem> purchases;
    try {
      purchases = await FlutterInappPurchase.instance.getAvailablePurchases();
    } catch (e) {
      print(e);
    }
    var item;
    if (purchases == null) {
      purchases = [];
    }

    try {
      item = purchases.lastWhere(
        (p)=>skus.contains(p.productId),
            orElse: null,
          );
    } on StateError catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }

    return item;
  }

  @override
  Stream<ProState> mapEventToState(ProEvent event) async* {
    if (event is ProLoaded) {
      yield Ready(isPro: event.isPro);
    }
  }
}

// ---------------
// region  events
// -----------------------------------------------------------------------------

/// Base event for ProBloc inputs
abstract class ProEvent {}

/// Means don't show anymore
class ProUpdate extends ProEvent {}

/// Fired when loaded from prefs
class ProLoaded extends ProEvent {
  ProLoaded(this.isPro);

  final bool isPro;
}


class ProCancelRequested extends ProEvent {}
// -----------------------------------------------------------------------------
// endregion

// ---------------
// region states
// -----------------------------------------------------------------------------

abstract class ProState {}

class Loading extends ProState {}

class Ready extends ProState {
  final bool isPro;

  Ready({
    this.isPro,
  });
}
// -----------------------------------------------------------------------------
// endregion
