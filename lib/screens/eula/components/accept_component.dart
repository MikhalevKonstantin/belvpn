import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/screens/connect/widgets/rounded_box.dart';

class AcceptComponent extends StatefulWidget {
  const AcceptComponent({Key key, this.onAccepted}) : super(key: key);

  final VoidCallback onAccepted;

  @override
  _AcceptComponentState createState() => _AcceptComponentState();
}

class _AcceptComponentState extends State<AcceptComponent> {
  bool agreeTos = false;
  bool agreePrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              agreeTos = !agreeTos;
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Checkbox(
                value: agreeTos,
                onChanged: (value) {
                  setState(() {
                    agreeTos = value;
                  });
                },
              ),
              Text(
                'I have read and accept terms and conditions',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            setState(() {
              agreePrivacy = !agreePrivacy;
            });
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Checkbox(
                value: agreePrivacy,
                onChanged: (value) {
                  setState(() {
                    agreePrivacy = value;
                  });
                },
              ),
              Text(
                'I have read and accept Privacy Policy',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(

            duration: Duration(milliseconds: 420),
            opacity: agreeTos && agreePrivacy? 1.0 : 0.33,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: agreeTos&&agreePrivacy ? widget.onAccepted : null,
              child: RoundedBox(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Accept',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black ,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
