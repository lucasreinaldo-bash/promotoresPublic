import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String nomeLinha, nomeProduto, id, qtdMinAreaEstoque, qtdMinAreaVenda;
  int codigoBarras;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nomeProduto = snapshot.data["nomeProduto"];
    nomeLinha = snapshot.data["nomeLinha"];
    qtdMinAreaEstoque = snapshot.data["qtdMinAreaEstoque"];
    qtdMinAreaVenda = snapshot.data["qtdMinAreaVenda"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nomeLinha": nomeLinha,
      "nomeProduto": nomeProduto,
      "qtdMinAreaEstoque": qtdMinAreaEstoque,
      "qtdMinAreaVenda": qtdMinAreaVenda,
    };
  }
}
