import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

class AnimatedSlideSwitcher extends StatelessWidget {
  const AnimatedSlideSwitcher({
    Key key,
    this.child,
    this.reverse,
  }) : super(key: key);

  final Widget child;
  final bool reverse;

  static Widget defaultLayoutBuilder(
      Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) children = children.toList()..add(currentChild);
    return Stack(
      children: children,
      alignment: Alignment.centerLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).selectedServerBloc,
      builder: (context, ServerInfo state) {
        return AnimatedSwitcher(
          layoutBuilder: defaultLayoutBuilder,
          transitionBuilder: (child, animation) {
            int dir = reverse != null && reverse ? -1 : 1;
            final inAnimation = Tween<Offset>(
                    begin: Offset(0.0, 1.0 * dir), end: Offset(0.0, 0.0))
                .animate(animation);
            final outAnimation = Tween<Offset>(
                    begin: Offset(0.0, -1.0 * dir), end: Offset(0.0, 0.0))
                .animate(animation);

            final opacityIn =
                Tween<double>(begin: 1, end: 0).animate(animation);
            final opacityOut =
                Tween<double>(begin: 1, end: 0).animate(animation);

            if (child.key == ValueKey(state.country)) {
              return ClipRect(
                child: SlideTransition(
                  position: inAnimation,
                  child: AnimatedOpacity(
                    curve: Curves.easeIn,
                    opacity: animation.isCompleted? 1.0: opacityIn.value,
                    duration: const Duration(milliseconds: 1000),
                    child: child,
                  ),
                ),
              );
            } else {
              return ClipRect(
                child: SlideTransition(
                  position: outAnimation,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacityOut.value,
                    child: child,
                  ),
                ),
              );
            }
          },
          // transitionBuilder:()=> FadeTransition(),
          duration: const Duration(milliseconds: 250),
          child: child,
        );
      },
    );
  }
}
