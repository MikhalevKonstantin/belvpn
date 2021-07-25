import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ServersRepository {
  FirebaseFirestore dataProvider = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  static const String kTopic = "ovpn";
  static const String collectionName = "ovpn";

  Future<List<ServerInfo>> fetchTopics() async {
    String path = '$kTopic';

    final querySnapshot =
        await dataProvider.collection(path).get() /*.catchError(onError)*/;

    // load servers collection and map doc -> List<ServerInfo>
    final servers = await Future.wait(querySnapshot.docs.map((doc) async {
      // get url from gs:// link
      final flagRef = storage.refFromURL(doc['flag']);
      final flagUrl = await flagRef.getDownloadURL();

      final config = (doc['config'] as String).replaceAll('\\n', '\n');

      var ip;
      try {
        ip = findIp(config);
      } catch (e) {
        print(e);
      }

      return ServerInfo(
        country: doc['country'],
        config: config,
        ip: ip,
        flag: flagUrl,
      );
    }).toList());

    return servers;
  }

  findIp(String config) {
    RegExp regExp = new RegExp(
      r"\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b",
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.firstMatch(config).group(0);
  }
}

class ServerInfo {
  final String country;
  final String config;
  final String flag;
  final String ip;

  const ServerInfo({this.country, this.config, this.flag, this.ip});
}
