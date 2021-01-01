import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDataRupturaValidade {
  String linha, produto, id, validade;
  int quantidade, ruptura;

  ProductDataRupturaValidade.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    linha = snapshot.data["linha"];
    produto = snapshot.data["produto"];
    quantidade = snapshot.data["quantidade"];
    validade = snapshot.data["validade"];
    ruptura = snapshot.data["ruptura"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "linha": linha,
      "produto": produto,
      "quantidade": quantidade,
      "validade": validade,
      "ruptura": ruptura,
    };
  }
}
