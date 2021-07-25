import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/logic/purchases/pro_bloc.dart';
import 'package:open_belvpn/core/logic/remote_servers_list_bloc/remote_servers_bloc.dart';
import 'package:open_belvpn/core/logic/vpn_bloc/vpn_bloc.dart';
import 'package:open_belvpn/core/utils/nizvpn_engine.dart';
import 'package:open_belvpn/screens/connect/views/connect_button.dart';
import 'package:open_belvpn/screens/connect/views/connection_details.dart';
import 'package:open_belvpn/screens/connect/views/connection_status_message.dart';
import 'package:open_belvpn/screens/connect/views/server_picker_button.dart';
import 'package:open_belvpn/screens/connect/views/server_picker_modal.dart';
import 'package:open_belvpn/screens/connect/views/title.dart';
import 'package:open_belvpn/screens/subscription/subscription.dart';
// import 'package:loading_gifs/loading_gifs.dart';

const String vpnConnected = NizVpn.vpnConnected;
const String vpnDisconnected = NizVpn.vpnDisconnected;
const String vpnWaitConnection = NizVpn.vpnWaitConnection;
const String vpnAuthenticating = NizVpn.vpnAuthenticating;
const String vpnReconnect = NizVpn.vpnReconnect;
const String vpnNoConnection = NizVpn.vpnNoConnection;
const String vpnConnecting = NizVpn.vpnConnecting;
const String vpnPrepare = NizVpn.vpnPrepare;
const String vpnDenied = NizVpn.vpnDenied;

class ConnectScreen extends StatefulWidget {
  ConnectScreen({
    Key key,
    this.onPurchased,
  }) : super(key: key);
  bool premium = false;
  final Function() onPurchased;

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  buildScreen() {
    bool isPro;

    // blocs: vpnBloc, stagesBloc
    // ButtonView: onTap, stage
    if (isPro) {
      // MessageViewPro
    } else {
      // MessageView
    }

    // ServerPicker

    if (isPro) {
      // ConnectionDetailsView
    } else {
      // ConnectionDetailsProView
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ConnectScreenTitle(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConnectButton(),
                    ConnectionStatusMessage(),
                  ],
                ),
              ),
              Column(
                children: [
                  ServerPickerButton(
                    onTap: () {
                      showServersPicker(context);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ConnectionDetails(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showServersPicker(ctx) {
    final vpnBloc = BlocProvider.of<VpnBloc>(ctx);
    final serversBloc = vpnBloc.remoteServersBloc;
    showGeneralDialog(

      context: ctx,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width,
            height: MediaQuery.of(ctx).size.height,
            // padding: EdgeInsets.all(20),
            color: Colors.white,
            child: BlocBuilder(
              bloc: serversBloc,
              builder: (BuildContext context, state) {
                if (state is RemoteServersLoaded) {
                  return BlocBuilder(
                    bloc: vpnBloc.selectedServerBloc,
                    builder: (ctx, st) {
                      return ServerPicker(
                        servers: state.servers,
                        selected: st,
                        onChanged: (serverInfo) {
                          // todo: show purchase dialog if not pro
                          final proState = BlocProvider.of<VpnBloc>(ctx, listen: false).proBloc.state;
                          if(proState is Ready && proState.isPro){
                            vpnBloc.selectedServerBloc.select(serverInfo);
                            Navigator.pop(context);
                          } else {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => Subscription(),
                              ),
                            );
                            // show dialog
                          }

                        },
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
    );
  }


}
