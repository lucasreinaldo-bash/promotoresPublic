import 'package:cloud_firestore/cloud_firestore.dart';

class PontoExtraData {
  bool existe;
  String id, imagemAntes, imagemDepois;

  PontoExtraData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    imagemAntes = snapshot.data["imagemAntes"];
    imagemDepois = snapshot.data["imagemDepois"];
    existe = snapshot.data["existe"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "existe": existe,
      "imagemAntes": imagemAntes,
      "imagemDepois": imagemDepois,
    };
  }
}
