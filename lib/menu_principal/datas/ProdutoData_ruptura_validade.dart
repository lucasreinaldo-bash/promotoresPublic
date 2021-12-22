import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDataRupturaValidade {
  String linha, produto, id, validade;
  int quantidade, ruptura, depoisReposicao, antesReposicao;

  ProductDataRupturaValidade.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    linha = snapshot.data["linha"];
    produto = snapshot.data["produto"];
    antesReposicao = snapshot.data["antesReposicao"];
    depoisReposicao = snapshot.data["depoisReposicao"];
    quantidade = snapshot.data["quantidade"];
    validade = snapshot.data["validade"];
    ruptura = snapshot.data["ruptura"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "linha": linha,
      "antesReposicao": antesReposicao,
      "depoisReposicao": depoisReposicao,
      "produto": produto,
      "quantidade": quantidade,
      "validade": validade,
      "ruptura": ruptura,
    };
  }
}
