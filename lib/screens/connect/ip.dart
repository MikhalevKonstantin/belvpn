import 'package:flutter/material.dart';
import 'package:dart_ipify/dart_ipify.dart';

class GetIP extends StatefulWidget {
  const GetIP({Key key}) : super(key: key);

  @override
  _GetIPState createState() => _GetIPState();
}

class _GetIPState extends State<GetIP> {
  String _ip = '';
  bool isLoading = false;

  @override
  void initState() {
    getIp();
    super.initState();
  }

  getIp() async {
    // todo: show progress setstate(loading = true)
    // todo: try
    try {
      String _ip = await Ipify.ipv4();
      print(_ip);
    } on Exception catch (_) {
      print('never reached');
    }

    // todo: catch errors

    setState(() {
      // check ip != null +  mb regexp ip pattern
      if (_ip != null) {
        isLoading = false;
        // todo: hide progress (loading = false)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if loading -> show circularProgress (indeterminate: true)
    // else Text
    // check string != null Text(ip ?? 'Unknown IP')
    return Text(isLoading ? 'checking IP ' : _ip);
  }
}
