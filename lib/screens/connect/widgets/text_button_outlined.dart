import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlineTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final Widget icon;

  const OutlineTextButton({
    Key key,
    this.onPressed,
    this.text,
    this.width,
    this.icon,
  }) : super(key: key);

  static final buttonTextStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final outlineButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 2.5,
          color: Color(0xFF007AFF),
        ),
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width - 64,
      child: TextButton(
        onPressed: onPressed,
        style: outlineButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon!=null) Padding(
              padding: const EdgeInsets.symmetric(horizontal:0.0),
              child: icon,
            ),
            Text(
              text,
              style: buttonTextStyle,

            ),
          ],
        ),
      ),
    );
  }
}
