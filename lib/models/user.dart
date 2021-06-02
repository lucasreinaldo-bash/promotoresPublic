import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart';

class User {
  String cep,
      cidade,
      email,
      senha,
      empresaVinculada,
      endereco,
      estado,
      imagem,
      nomePromotor,
      telefone,
      tipoContrato,
      id;

  User(
      {this.cep,
      this.cidade,
      this.email,
      this.senha,
      this.empresaVinculada,
      this.endereco,
      this.estado,
      this.imagem,
      this.nomePromotor,
      this.telefone,
      this.tipoContrato});

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    cep = document.data["cep"] as String;
    cidade = document.data["cidade"] as String;
    email = document.data["email"] as String;
    empresaVinculada = document.data["empresaVinculada"] as String;
    endereco = document.data["endereco"] as String;
    estado = document.data["estado"] as String;
    imagem = document.data["imagem"] as String;
    nomePromotor = document.data["nomePromotor"] as String;
    telefone = document.data["telefone"] as String;
    tipoContrato = document.data["tipoContrato"] as String;
  }

  DocumentReference get firestoreRef =>
      Firestore.instance.document("Promotores/$id");
  Future<void> savedData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "cep": cep,
      "cidade": cidade,
      "email": email,
      "empresaVinculada": empresaVinculada,
      "endereco": endereco,
      "estado": estado,
      "imagem": imagem,
      "nomePromotor": nomePromotor,
      "telefone": telefone,
      "tipoContrato": tipoContrato,
    };
  }
}
