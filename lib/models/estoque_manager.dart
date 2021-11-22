import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class EstoqueManager extends ChangeNotifier {
  String _idEmpresa;

  set idEmpresa(String id){
      _idEmpresa = id;
      notifyListeners();
  }

  PesquisaData data;
  set pesquisaData(PesquisaData d){
    data = d;
    notifyListeners();
  }


  List<ProductData> estoqueProdutos = [];
  final Firestore firestore = Firestore.instance;


  Future<void> estoqueAntes({String linha, String idLinha}) async {

    estoqueProdutos.clear();

   final QuerySnapshot snapshotAntes = await firestore
        .collection("Empresas")
        .document(_idEmpresa)
        .collection("Lojas")
        .document(data.nomeLoja)
        .collection("Produtos")
        .getDocuments();

    for (var line in data.linhaProduto){
      estoqueProdutos.addAll(snapshotAntes.documents
          .map((d) => ProductData.fromDocument(d)).where((element) => element.nomeLinha == line)
          .toList());
    }
  }


  Future<void> removerLinha(String idLinha) async {
    await firestore
        .collection("Empresas")
        .document(id)
        .collection("linhasProdutos")
        .document(idLinha)
        .delete();

    allLinhas();
  }
}
