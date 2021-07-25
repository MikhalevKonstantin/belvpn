import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_belvpn/core/models/geo_ip.dart';

typedef Future<T> FutureGenerator<T>();

class IpAddressRepository {


  getGeo() async {
    try {
      final result = await retry(
        3,
        () => _lookupUserCountry(),
        delay: Duration(milliseconds: 500),
      );

      return GeoIP(
        result['ip'],
        result['location']['country']['code'],
      );
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<Map<String, dynamic>> _lookupUserCountry() async {
    var response;
    response = await http
        .get(Uri.parse('https://api.ipregistry.co?key=xte60fakobf0qt'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user country from IP address');
    }
  }

  Future<T> retry<T>(int retries, FutureGenerator aFuture,
      {Duration delay}) async {
    try {
      return await aFuture();
    } catch (e) {
      if (retries > 1) {
        if (delay != null) {
          await Future.delayed(delay);
        }
        return retry(retries - 1, aFuture);
      }
      rethrow;
    }
  }
}
