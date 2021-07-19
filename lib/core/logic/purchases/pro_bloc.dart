import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:localstorage/localstorage.dart';

class ProBloc extends Bloc<ProEvent, ProState> {
  ProBloc() : super(Loading());

  init() async {
    var item = await _findProPurchase();

    FlutterInappPurchase.purchaseUpdated.listen((event) async {
      final purchased =
          await FlutterInappPurchase.instance.getPurchaseHistory();

      print(purchased);

      final purchase = purchased.lastWhere(
          (p) => p.productId == 'monthly' || p.productId == 'monthly');


      //
      // if(purchase==true){
      //   yield Ready(isPro: true);
      // } else {
      //   yield Ready(isPro: false);
      // }

      final productId = purchase.productId;

      LocalStorage storage = LocalStorage('pro');
      await storage.ready;
      storage.setItem('purchaseKey', purchased[0].purchaseToken);

      add(ProLoaded(purchase != null));
    });

    FlutterInappPurchase.purchaseError.listen((event) {
      print('===purchaseError: $event');
    });

    FlutterInappPurchase.purchasePromoted.listen((event) {
      print('===purchasePromoted: $event');
    });

    if (item != null) {
      add(ProLoaded(true));
    } else {
      add(ProLoaded(false));
    }
    _saveStatusToLocal(item);
  }

  _saveStatusToLocal(PurchasedItem item) async {
    final storage = LocalStorage('pro');
    await storage.ready;
    if (item != null && item.purchaseToken != null) {
      storage.setItem('purchaseKey', item.purchaseToken);
    } else {
      storage.setItem('purchaseKey', null);
    }
  }

  Future consumePurchase() async {
    add(ProCancelRequested());
  }

  Future<PurchasedItem> _findProPurchase() async {
    var purchases;
    var subscriptions;
    try {
      purchases = await FlutterInappPurchase.instance.getAvailablePurchases();
//      FlutterInappPurchase.
    } catch (e) {
      print(e);
    }
    var item;
    if (purchases == null) {
      purchases = [];
    }

    try {
      item = purchases.lastWhere(
          (p) => p.productId == 'monthly' ||p.productId == 'yearly' ,
          orElse: null);
    } on StateError catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }

    return item;
  }

  @override
  Stream<ProState> mapEventToState(ProEvent event) async* {
    print('mapping event to state');
    /** possible events:
     *  - Loaded(from prefs), default to false if empty?
     *  - Status Updated (means pro purchased / restored / ??canceled?? )
     */

    if (event is ProLoaded) {
      yield Ready(isPro: event.isPro);
    }

    if (event is ProPurchaseRequested) {
      LocalStorage storage = LocalStorage('pro');
      await storage.ready;
      if (storage.getItem('purchaseKey') == null) {
        yield Loading();
        _purchase(event.sku);
      } else {
        var item = await _findProPurchase();
        if (item != null) {
          yield Ready(isPro: true);
        } else {
          yield Loading();
          _purchase(event.sku);
        }
      }
    }

    if (event is ProCancelRequested) {
      // print('Cancelling');
      yield Loading();
      PurchasedItem result;

      // check if purchase token is in storage
      LocalStorage storage = LocalStorage('pro');
      await storage.ready;
      String token = storage.getItem('purchaseKey');

      // get it from billing service
      if (token == null) {
        result = await _findProPurchase();
        if (result != null && result.purchaseToken != null) {
          token = result.purchaseToken;
        }
      }

      // if any token present it's possible to cancel (consume)
      String consumeResult;
      if (token != null) {
        try {
          consumeResult =
              await FlutterInappPurchase.instance.consumePurchaseAndroid(token);
        } catch (e) {
          print(e);
        }

        if (consumeResult != null) {
          // means item was consumed
          yield Ready(isPro: false);
        }
      } else {
        // means item was not found and we return the state back
        yield Ready(isPro: result != null);
      }
    }
  }

  Future<bool> _purchase(String sku) async {
    // todo upgrade subscription (sku + oldSku)
    var result;
    try {
      final available = await FlutterInappPurchase.instance
          .getSubscriptions(['monthly', 'yearly']);
      print(available);
      FlutterInappPurchase.instance.requestSubscription(
        sku,
      );
    } catch (e) {
      print(e);
    }
    return result != null;
  }

  @override
  void onChange(Change change) {
    print(change);
  }


  void purchaseProMonthly() => add(ProPurchaseRequested('monthly'));

  void purchaseProYearly() => add(ProPurchaseRequested('yearly'));

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

class ProPurchaseRequested extends ProEvent {
  String sku;

  ProPurchaseRequested(this.sku);
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
