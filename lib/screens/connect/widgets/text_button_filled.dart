import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilledTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;

  const FilledTextButton({
    Key key,
    this.onPressed,
    this.text,
    this.width,
  }) : super(key: key);

  static final buttonTextStyle = GoogleFonts.lato(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final outlineButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states){

      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.disabled,
      };

      if(states.any(interactiveStates.contains)){
        return Colors.black54;
      }
      return Colors.blue;
    }),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),

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
        child: Text(
          text,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
