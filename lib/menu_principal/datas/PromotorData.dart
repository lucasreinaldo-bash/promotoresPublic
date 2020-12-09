import 'package:cloud_firestore/cloud_firestore.dart';

class PromotorData {
  String id, nomePromotor, imagem, endereco, email, tipoContrato;
  int telefone;

  PromotorData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    email = snapshot.data["email"];
    nomePromotor = snapshot.data["nomePromotor"];
    imagem = snapshot.data["imagem"];
    telefone = snapshot.data["telefone"];
    endereco = snapshot.data["endereco"];
    tipoContrato = snapshot.data["tipoContrato"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "email": email,
      "nomePromotor": nomePromotor,
      "imagem": imagem,
      "endereco": endereco,
      "tipoContrato": tipoContrato,
      "telefone": telefone,
    };
  }
}
