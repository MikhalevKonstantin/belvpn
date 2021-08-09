import 'package:flutter/material.dart';
import 'package:open_belvpn/screens/eula/components/accept_component.dart';
import 'package:open_belvpn/screens/eula/components/eula_scroll_view.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen(
    this.onAccepted, {
    Key key,
  }) : super(key: key);

  final VoidCallback onAccepted;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: Style.Colors.gradientDecoration,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 8,
          centerTitle: true,
          title: Text(
            'Terms of Use & Privacy Policy',
            // style: Style.TextStyles.appBarTitleStyle,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: EulaScrollView()),
              AcceptComponent(onAccepted: onAccepted)
            ],
          ),
        ),
      ),
    );
  }
}
