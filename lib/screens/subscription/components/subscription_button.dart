import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductButton extends StatelessWidget {
  const ProductButton({
    Key key,
    this.selected,
    this.price,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final bool selected;
  final String price;
  final String title;
  final VoidCallback onPressed;

  static final titleStyle = GoogleFonts.lato(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: Color(0xFF101010),
  );

  static final priceStyle = GoogleFonts.lato(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: Color(0xFF101010),
  );

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Color(0xFF007AFF),
        //0xFF007AFF
        backgroundColor: selected ? Color(0xFFF2F2F7) : Color(0xFFE7E7EC),
        elevation: selected?4:0,
        minimumSize: Size(54.0, 54.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        side: BorderSide(
          color: selected ? Color(0xFF007AFF) : Color(0xFFE7E7EC),
          width: 1.5,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.substring(0, 22),
            style: titleStyle,
          ),
          Text(
            "\$" + price,
            style: priceStyle,
          ),
        ],
      ),
    );
  }
}