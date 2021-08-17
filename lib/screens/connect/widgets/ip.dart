import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/ip_address_bloc/ip_address_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/models/geo_ip.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IpAddressView extends StatelessWidget {
  const IpAddressView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IpAddressViewRemote();
  }
}

class IpAddressViewLocal extends StatelessWidget {
  const IpAddressViewLocal({Key key}) : super(key: key);

  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).selectedServerBloc,
      builder: (context, ServerInfo geo) {
        return Container(
          child: AnimatedOpacity(
            curve: Curves.easeInOutCubic,
            duration: Duration(
              milliseconds: 420,
            ),
            opacity: geo != null ? 1 : 0,
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      t.currentIP + ": ",
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (geo == null)
                      Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                        height: 12,
                        width: 12,
                      )
                    else
                      Text(
                        "${geo.ip}",
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IpAddressViewRemote extends StatelessWidget {
  const IpAddressViewRemote({Key key}) : super(key: key);

  static final textStyle = GoogleFonts.lato(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return BlocBuilder(
      bloc: BlocProvider.of<VpnBloc>(context).ipAddressBloc,
      builder: (context, GeoIP server) {
        return Container(
          child: AnimatedOpacity(
            curve: Curves.easeInOutCubic,
            duration: Duration(
              milliseconds: 420,
            ),
            opacity: server != null ? 1 : 0,
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      t.currentIP + ": ",
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (server == null)
                      Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                        height: 12,
                        width: 12,
                      )
                    else
                      Text(
                        "${server.ip}",
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
