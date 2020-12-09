import 'package:cloud_firestore/cloud_firestore.dart';

class LojaData {
  String email, nomeLoja, nomeRede, id;
  int telefone;

  LojaData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    email = snapshot.data["emailEmpresa"];
    nomeLoja = snapshot.data["nomeLoja"];
    nomeRede = snapshot.data["nomeRede"];
    telefone = snapshot.data["telefone"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nomeLoja": nomeLoja,
      "nomeRede": nomeRede,
      "emailEmpresa": email,
      "telefone": telefone,
    };
  }
}
