import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  static Widget defaultLayoutBuilder(
      Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) children = children.toList()..add(currentChild);
    return Stack(
      children: children,
      alignment: Alignment.center,
    );
  }

  @override
  _ServerPickerState createState() => _ServerPickerState();
}

class _ServerPickerState extends State<ServerPicker> {
  int lastIndex, nextIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lastIndex = widget.servers.indexOf(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black38),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              AnimatedSwitcher(
                layoutBuilder: ServerPicker.defaultLayoutBuilder,
                transitionBuilder: (child, animation) {
                  int dir = lastIndex >= nextIndex ? 1 : -1;
                  final inAnimation = Tween<Offset>(
                          begin: Offset(0.0, 1.0 * dir), end: Offset(0.0, 0.0))
                      .animate(animation);
                  final outAnimation = Tween<Offset>(
                          begin: Offset(0.0, -1.0 * dir), end: Offset(0.0, 0.0))
                      .animate(animation);

                  if (child.key == ValueKey(widget.selected.country)) {
                    return ClipRect(
                      child: SlideTransition(
                        position: inAnimation,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                          child: child,
                        ),
                      ),
                    );
                  } else {
                    return ClipRect(
                      child: SlideTransition(
                        position: outAnimation,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
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
                    SizedBox(height: 32),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white54,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.selected.flag,
                        cacheManager: DefaultCacheManager(),
                      ),
                      // Image(widget.selected.flag, image: null, ).image
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(widget.selected.country,
                        key: ValueKey(widget.selected.country),
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              // SizedBox(height: 4),
              Text('Current location',
                  style: GoogleFonts.lato(
                      color: Color(0x80101010).withOpacity(0.1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 16,
              ),
              Divider(
                height: 1,
                color: Color(0xffd1d1d6),
              ),
              Divider(
                height: 1,
                color: Color(0xffd1d1d6),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: widget.servers.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          onChanged: (String value) {
                            // if(nextIndex!=i) {
                            //   lastIndex = nextIndex;
                            //   nextIndex = i;
                            // }
                            lastIndex = nextIndex;
                            nextIndex = i;

                            // todo: show dialog for non-pro instead of connecting
                            widget.onChanged(widget.servers[i]);
                            // print(value);
                          },
                          subtitle: i == 0
                              ? Text('Best for general browsing',
                                  style: GoogleFonts.lato(
                                      color: Color(0x33000000),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500))
                              : null,
                          value: widget.servers[i].country,
                          secondary: CircleAvatar(
                            radius: 16,
                            backgroundImage: CachedNetworkImageProvider(
                              widget.servers[i].flag,
                            ),
                          ),
                          groupValue: widget.selected.country,
                          title: Text(
                            widget.servers[i].country,
                            style: GoogleFonts.lato(
                                color: Color(0xff101010),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                        if (i == 0)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                'Locations (${widget.servers.length - 1})',
                                style: GoogleFonts.lato(
                                    color: Color(0x80101010),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
