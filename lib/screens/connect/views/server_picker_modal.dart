import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

class ServerPicker extends StatefulWidget {
  final List<ServerInfo> servers;

  const ServerPicker({
    Key key,
    this.servers,
    this.selected,
    this.onChanged,
  }) : super(key: key);

  final ServerInfo selected;
  final Function(ServerInfo) onChanged;

  static Widget defaultLayoutBuilder(Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null)
      children = children.toList()..add(currentChild);
    return Stack(
      children: children,
      alignment: Alignment.center,
    );
  }

  @override
  _ServerPickerState createState() => _ServerPickerState();
}

class _ServerPickerState extends State<ServerPicker> {

  int lastIndex, nextIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lastIndex = widget.servers.indexOf(widget.selected);

  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            AnimatedSwitcher(
              layoutBuilder: ServerPicker.defaultLayoutBuilder,
              transitionBuilder: (child, animation) {

                int dir = lastIndex>= nextIndex? 1: -1;
                final inAnimation =
                Tween<Offset>(begin: Offset(0.0, 1.0*dir), end: Offset(0.0, 0.0))
                    .animate(animation);
                final outAnimation =
                Tween<Offset>(begin: Offset(0.0, -1.0*dir), end: Offset(0.0, 0.0))
                    .animate(animation);



                if (child.key == ValueKey(widget.selected.country)) {
                  return ClipRect(
                    child: SlideTransition(
                      position: inAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                } else {
                  return ClipRect(
                    child: SlideTransition(
                      position: outAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                }
              },
              // transitionBuilder:()=> FadeTransition(),
              duration: Duration(milliseconds: 250),
              child: Column(
                key: ValueKey(widget.selected.country),
                children: [
                  Image.network(widget.selected.flag),
                  Text(widget.selected.country,
                      key: ValueKey(widget.selected.country),
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Text('Current location',
                style: GoogleFonts.lato(
                    color: Color(0x80101010),
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
            Divider(
              height: 1,
              color: Color(0xffd1d1d6),
            ),

            Divider(
              height: 1,
              color: Color(0xffd1d1d6),
            ),
            ListView.builder(
              itemCount: widget.servers.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return RadioListTile<String>(
                  onChanged: (String value) {
                    // if(nextIndex!=i) {
                    //   lastIndex = nextIndex;
                    //   nextIndex = i;
                    // }
                    lastIndex = nextIndex;
                    nextIndex = i;

                    // todo: show dialog for non-pro insrtead of connecting
                    widget.onChanged(widget.servers[i]);
                    // print(value);
                  },
                  value: widget.servers[i].country,
                  secondary: Image.network(widget.servers[i].flag),
                  groupValue: widget.selected.country,
                  title: Text(
                    widget.servers[i].country,
                    style: GoogleFonts.lato(
                        color: Color(0xff101010),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
