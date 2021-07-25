import 'package:bloc/bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class SubscriptionBloc
    extends Bloc<SubscriptionBlocEvent, SubscriptionBlocState> {
  SubscriptionBloc() : super(SubscriptionBlocStateInitial());

  initListeners(skus) async {

    FlutterInappPurchase.purchaseUpdated.listen((item) async {
      print('Purchase status updated for product id: ${item.productId}');
      var status = item.purchaseStateAndroid;
      if (status == PurchaseState.purchased && item != null) {
        print('Product [${item.productId}] is purchased successfully');

        add(PurchaseAcknowledged());
        String purchaseResult =
            await FlutterInappPurchase.instance.acknowledgePurchaseAndroid(
          item.purchaseToken,
        );

      } else {
        print('purchase failed');
        _onPurchaseFailed();
      }

      print('New status is: ${status.toString()}');
    });

    FlutterInappPurchase.purchaseError.listen((event) async {
      print('purchaseError: $event');
      _onPurchaseFailed();
    });

    FlutterInappPurchase.purchasePromoted.listen((event) {
      print('purchasePromoted: $event');
    });

    // add(ProductsReadyEvent(skus));
  }

  _onPurchaseFailed() {
    add(PurchaseFailedEvent());
  }

  @override
  Stream<SubscriptionBlocState> mapEventToState(
      SubscriptionBlocEvent event) async* {
    // initial / loading
    if (event is SubscriptionBlocFirstEvent) {
      // processFirstEvent();
      yield state;
    }

    // loaded
    else if (event is ProductsReadyEvent) {
      final products = await processSecondEvent(event);
      yield SubscriptionBlocStateReady(
        products: products,
        selected: 0,
      );
    }


    // selected another product
    else if (event is ProductSelectedEvent) {
      final int index =
          state.products.indexWhere((p) => p.productId == event.sku);

      yield SubscriptionBlocStateReady(
        products: state.products,
        selected: index,
      );
    }

    // clicked purchase
    else if (event is PurchaseEvent) {
      //yield PurchaseProgress
      yield SubscriptionPurchaseProgressState(
          state.products, state.selectedIndex);
      _purchase(event.sku);
    } else if (event is PurchaseFailedEvent) {
      print('purchase failed');
      yield PurchaseFailed(state.products, state.selectedIndex);
      yield SubscriptionBlocStateReady(
        products: state.products,
        selected: state.selectedIndex,
      );
      // yield SubscriptionBlocStateReady(some: state.products, thing: state.selectedIndex);
    }
    // purchase ready, close modal
    else if (event is PurchaseAcknowledged) {
      // todo: close modal somehow
      yield FinalizePurchase();
    }
    // do nothing
    else
      yield state;
  }

  // @override
  // Stream<SubscriptionBlocEvent> transform(
  //     Stream<SubscriptionBlocEvent> events) {
  //   return (events as Observable<SubscriptionBlocEvent>)
  //       // .throttle(Duration(milliseconds: 40)
  //       // .debounce... etc
  //       ;
  // }
  Future<List<IAPItem>> getSubscriptions(List<String> skus) async {
    final available =
        await FlutterInappPurchase.instance.getSubscriptions(skus);

    return available;
  }

  Future _purchase(String sku) async {
    // todo upgrade subscription (sku + oldSku)
    try {
      // IMPORTANT! by this moment
      // await FlutterInappPurchase.instance.getSubscriptions(skus);
      // should've been called at least once
      // todo: needed? await getSubscriptions([sku]);
      // print(available);

      FlutterInappPurchase.instance.requestSubscription(
        sku,
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  processFirstEvent(SubscriptionBlocFirstEvent event) {}

  Future<List<IAPItem>> processSecondEvent(ProductsReadyEvent event) async {
    initListeners(event.skus);
    final subscriptions = await getSubscriptions(event.skus);
    return subscriptions;
  }

  void purchase() {
    final index = state.selectedIndex;
    final products = state.products;

    if (index >= 0 && products.length >= 1)
      add(
        PurchaseEvent(
          products[index].productId,
        ),
      );
  }

  void select(sku) {
    add(ProductSelectedEvent(sku));
  }

  void updateProducts(List<String> skus) {
    add(ProductsReadyEvent(skus));
  }

  showProductsAfterFailure() {
    add(ShowProductsAfterFailure());
  }
}

class ShowProductsAfterFailure extends SubscriptionBlocEvent {}

class PurchaseFailedEvent extends SubscriptionBlocEvent {}

class PurchaseFailed extends SubscriptionBlocState {
  PurchaseFailed(List<IAPItem> products, selectedIndex)
      : super(products, selectedIndex);
}

class SubscriptionPurchaseProgressState extends SubscriptionBlocState {
  SubscriptionPurchaseProgressState(List<IAPItem> products, thing)
      : super(products, thing);
}

// ---------------
// region  events (todo: move separate file)
// -----------------------------------------------------------------------------

/// Base event for SubscriptionBloc input
abstract class SubscriptionBlocEvent {}

class SubscriptionBlocFirstEvent extends SubscriptionBlocEvent {}

class ProductsReadyEvent extends SubscriptionBlocEvent {
  final skus;

  ProductsReadyEvent(
    this.skus,
  );
}

class ProductSelectedEvent extends SubscriptionBlocEvent {
  final sku;

  ProductSelectedEvent(this.sku);
}

class PurchaseAcknowledged extends SubscriptionBlocEvent {}

class PurchaseEvent extends SubscriptionBlocEvent {
  PurchaseEvent(this.sku) : super();

  final String sku;
}

// -----------------------------------------------------------------------------
// endregion

// ---------------
// region  states (todo: move separate file)
// -----------------------------------------------------------------------------
abstract class SubscriptionBlocState {
  final List<IAPItem> products;
  final selectedIndex;

  SubscriptionBlocState(
    this.products,
    this.selectedIndex,
  );
}

class SubscriptionBlocStateInitial extends SubscriptionBlocState {
  SubscriptionBlocStateInitial({
    products,
    selected,
  }) : super(
          products,
          selected,
        );
}

class SubscriptionBlocStateReady extends SubscriptionBlocState {
  SubscriptionBlocStateReady({
    products,
    selected,
  }) : super(
          products,
          selected,
        );
}

// Listen to this state with BlocListener to pop the modal
class FinalizePurchase extends SubscriptionBlocState {
  FinalizePurchase() : super(null, null);
}

// -----------------------------------------------------------------------------
// endregion
