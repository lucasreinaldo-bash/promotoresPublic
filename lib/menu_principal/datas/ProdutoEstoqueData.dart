import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoEstoqueData {
  String antesReposicao = "null";
  String id;

  ProdutoEstoqueData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    antesReposicao = snapshot.data["antesReposicao"].toString() == null
        ? "null"
        : snapshot.data["antesReposicao"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "antesReposicao": antesReposicao,
    };
  }
}
