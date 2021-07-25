import 'package:flutter/material.dart';

class RoundShadowButton extends StatefulWidget {

  const RoundShadowButton({
    Key key,
    this.child,
    this.onPressed,
    this.willDisconnect,
  }) : super(key: key);

  final Widget child;
  final bool willDisconnect;
  final VoidCallback onPressed;

  @override
  _RoundShadowButtonState createState() => _RoundShadowButtonState();
}

class _RoundShadowButtonState extends State<RoundShadowButton>
    with TickerProviderStateMixin {

  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    final colorStrength = _controller.value * 10;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapCancel: _tapUp,
      onTapUp: (tud) {
        _tapUp(tud);
        widget.onPressed();
      },
      // onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: AnimatedContainer(
          height: MediaQuery
              .of(context)
              .size
              .width / 3,
          width: MediaQuery
              .of(context)
              .size
              .width / 3,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 122,
                255 - (32 * colorStrength).floor(), 1), // Color(0xff007aff),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _calculateShadowColor(colorStrength), //0xff007aff),
                blurRadius: 32.0 - 8 * colorStrength,
                // spreadRadius: 10.0,
              ),
            ],
          ),
          duration: Duration(milliseconds: 1000),
          child: _animatedButton(),
        ),
      ),
    );
  }

  _calculateShadowColor(double value) =>
      widget.willDisconnect ?
      Color.fromRGBO(
        0 +(255* value).floor(), 122, 255-(100*value).floor(), 1,) :
      Color.fromRGBO(
          0, 122 , 255-(255*value).floor(), 1);

  _colorValue(int base, double value )=> (base * value).floor();




Widget _animatedButton() {
  return widget.child;
}

void _tapDown(TapDownDetails details) {
  _controller.forward();
}

void _tapUp([TapUpDetails details]) {
  _controller.reverse();
}}
