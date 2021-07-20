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
    final servers =
        await Future.wait(querySnapshot.docs.map((doc) async {
      // get url from gs:// link
      final flagRef = storage.refFromURL(doc['flag']);
      final flagUrl = await flagRef.getDownloadURL();

      return ServerInfo(
        country: doc['country'],
        config: doc['config'],
        flag: flagUrl,
      );
    }).toList());

    print('Servers list fetched');
    return servers;
  }
}

class ServerInfo {
  final String country;
  final String config;
  final String flag;

  const ServerInfo({this.country, this.config, this.flag});
}
