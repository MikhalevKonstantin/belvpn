import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';
import 'package:open_belvpn/screens/connect/widgets/animated_slide_switcher.dart';
import 'package:open_belvpn/screens/connect/widgets/rounded_box.dart';

class ServerPickerButton extends StatelessWidget {
  const ServerPickerButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VpnBloc>(context).selectedServerBloc;

    return RoundedBox(
      child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext ctx, ServerInfo server) {



          return ListTile(
            onTap: onTap,
            leading: AnimatedSlideSwitcher(
              reverse: false,
              child: CircleAvatar(
                key: ValueKey(server.country),
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(
                  server.flag,

                  // progressIndicatorBuilder: (context, url, downloadProgress) =>
                  //     CircularProgressIndicator(value: downloadProgress.progress),
                  // errorWidget: (context, url, error) => Icon(Icons.error),
                  // width: 32,
                ),
              ),
            ),
            title: AnimatedSlideSwitcher(
              reverse: false,
              child: Text(
                server.country,
                textAlign: TextAlign.start,
                key: ValueKey(server.country),
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: SvgPicture.asset('assets/svg_icons/stroke3.svg'),
          );
        },
      ),
    );
  }
}
