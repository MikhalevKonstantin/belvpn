import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ServersRepository {
  Firestore dataProvider = Firestore.instance;
  FirebaseStorage storage = FirebaseStorage();

  static const String kTopic = "ovpn";
  static const String collectionName = "ovpn";

  Future<List<ServerInfo>> fetchTopics() async {
    String path = '$kTopic';

    final response =
        await dataProvider.collection(path).getDocuments().catchError((err) {
      print(err);
    });

    // load servers collection and map doc -> List<ServerInfo>
    List<ServerInfo> servers =
        await Future.wait(response.documents.map((doc) async {

      // get url from gs:// link
      final StorageReference flagReference =
          await storage.getReferenceFromUrl(doc.data['flag']);
      final flagUrl = await flagReference.getDownloadURL();

      return ServerInfo(
        country: doc.data['country'],
        config: doc.data['config'],
        flag: flagUrl,
      );
    }).toList());

    print(servers);
    return servers;
  }
}

class ServerInfo {
  final String country;
  final String config;
  final String flag;

  const ServerInfo({this.country, this.config, this.flag});
}
