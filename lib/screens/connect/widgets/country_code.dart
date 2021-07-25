import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/ip_address_bloc/ip_address_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/models/geo_ip.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

class CountryCode extends StatelessWidget {
  const CountryCode({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CountryCodeRemote();
  }
}

class CountryCodeLocal extends StatelessWidget {
  const CountryCodeLocal({Key key}) : super(key: key);

  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).selectedServerBloc,
      builder: (ctx, ServerInfo state) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 420,),
          opacity:  state != null? 1:0,
          child: Row(children: [
            Text('Country: '),
            state != null
                ? Text(
              // state.countryCode,
              state.country,

              style: textStyle,
            )
                : Container(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
              height: 13,
              width: 13,
            )
          ]),
        );
      },
    );
  }
}


class CountryCodeRemote extends StatelessWidget {
  const CountryCodeRemote({Key key}) : super(key: key);

  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).ipAddressBloc,
      builder: (ctx, GeoIP geo) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 420,),
          opacity:  geo != null? 1:0,
          child: Row(children: [
            Text('Country: '),
            geo != null
                ? Text(
              // state.countryCode,
              geo.countryCode?? '',

              style: textStyle,
            )
                : Container(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
              height: 13,
              width: 13,
            )
          ]),
        );
      },
    );
  }
}

