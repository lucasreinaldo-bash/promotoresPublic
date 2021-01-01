import 'package:cloud_firestore/cloud_firestore.dart';

class estoqueDepositoData {
  String linha, produto, id;
  int antesReposicao, aposReposicao;

  estoqueDepositoData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    linha = snapshot.data["linha"];
    produto = snapshot.data["produto"];
    antesReposicao = snapshot.data["antesReposicao"];
    aposReposicao = snapshot.data["aposReposicao"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "linha": linha,
      "produto": produto,
      "antesReposicao": antesReposicao,
      "aposReposicao": aposReposicao,
    };
  }
}
