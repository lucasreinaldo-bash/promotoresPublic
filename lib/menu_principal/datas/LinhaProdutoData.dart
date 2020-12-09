import 'package:cloud_firestore/cloud_firestore.dart';

class LinhaProdutoData {
  String nomeLinha, id;

  LinhaProdutoData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nomeLinha = snapshot.data["nomeLinha"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nomeLinha": nomeLinha,
    };
  }
}
