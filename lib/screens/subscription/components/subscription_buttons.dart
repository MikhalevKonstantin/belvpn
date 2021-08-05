import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/screens/subscription/bloc/subscription_bloc.dart';
import 'package:open_belvpn/screens/subscription/components/subscription_button.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class SubscriptionButtons extends StatelessWidget {
  const SubscriptionButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<VpnBloc>(context).subscriptionBloc,
        builder: (context, SubscriptionBlocState state) {
          if (state is SubscriptionBlocStateInitial) {
            return Text('pro already');
          } else if (state is SubscriptionBlocStateReady ||
              state is SubscriptionPurchaseProgressState) {
            // print(state.products[0].)

            final purchasing = state is SubscriptionPurchaseProgressState;

            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: state.products.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = state.products[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: ProductButton(
                      selected: state.selectedIndex == index,
                      title: item.title,
                      price: '${item.price}',
                      onPressed: purchasing
                          ? null
                          : () {
                              context
                                  .read<VpnBloc>()
                                  .subscriptionBloc
                                  .select(item.productId);
                            },
                    ),
                  );
                });
          } else if (state is SubscriptionPurchaseProgressState) {
            return Text('Processing purchase');
          } else {
            return Text('pro already');
          }
        });
  }
}
