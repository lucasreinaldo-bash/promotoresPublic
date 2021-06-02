import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String nomeLinha, nomeProduto, id;
  int codigoBarras,
      antesReposicao,
      aposReposicao,
      qtdMinAreaEstoque,
      qtdMinAreaVenda;
  bool rupturaInicial;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nomeProduto = snapshot.data["nomeProduto"];
    rupturaInicial = snapshot.data["rupturaInicial"];
    nomeLinha = snapshot.data["nomeLinha"];
    qtdMinAreaEstoque = snapshot.data["qtdMinAreaEstoque"];
    qtdMinAreaVenda = snapshot.data["qtdMinAreaVenda"];
    antesReposicao = snapshot.data["antesReposicao"];
    aposReposicao = snapshot.data["aposReposicao"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nomeLinha": nomeLinha,
      "aposReposicao": aposReposicao,
      "nomeProduto": nomeProduto,
      "rupturaInicial": rupturaInicial,
      "qtdMinAreaEstoque": qtdMinAreaEstoque,
      "qtdMinAreaVenda": qtdMinAreaVenda,
      "antesReposicao": antesReposicao,
    };
  }
}
