import 'package:flutter/material.dart';

class RoundShadowButton extends StatelessWidget {
  const RoundShadowButton({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 3,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
        color: Color(0xff007aff),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xff007aff),
            blurRadius: 32.0,
            // spreadRadius: 10.0,
          ),
        ],
      ),
    child: child
    );
  }
}
