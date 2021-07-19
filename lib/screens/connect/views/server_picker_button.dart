import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/selected_server_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';
import 'package:open_belvpn/screens/connect/widgets/rounded_box.dart';

class ServerPickerButton extends StatelessWidget {
  const ServerPickerButton({Key key, this.onTap,}) : super(key: key);

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
            leading: Image.network(server.flag,width: 32,),
            title: Text(
              server.country,
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: SvgPicture.asset('assets/svg_icons/stroke3.svg'),
          );
        },
      ),
    );
  }
}