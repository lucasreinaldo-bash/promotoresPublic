import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData_ruptura_validade.dart';
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

  int _validationEstoqueAfter;
  set validationEstoqueAfter(int n){
    _validationEstoqueAfter = _validationEstoqueAfter + n;
    notifyListeners();
  }

  int _validationEstoqueBefore;
  set validationEstoqueBefore(int n){
    _validationEstoqueBefore = _validationEstoqueBefore + n;
    notifyListeners();
  }

  List<ProductData> estoqueProdutos = [];
  List<ProductDataRupturaValidade> estoqueAfter = [];
  final Firestore firestore = Firestore.instance;


  Future<void> estoqueFilter({String linha, String idLinha}) async {

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

    print(estoqueProdutos.length);
    notifyListeners();

  
  }

  Future<bool> verifyEstoqueAfter() async{
    estoqueAfter.clear();

   final QuerySnapshot snapshotAntes = await firestore
        .collection("Empresas")
        .document(_idEmpresa)
        .collection("pesquisasCriadas")
        .document(data.id)
        .collection("estoqueDeposito")
        .getDocuments();

     estoqueAfter.addAll(snapshotAntes.documents
          .map((d) => ProductDataRupturaValidade.fromDocument(d)).where((element) => element.antesReposicao == 9999)
          .toList());
          
    notifyListeners();

    if(estoqueProdutos.length == estoqueAfter.length){
      print("igual");
    }
    else{
      print("Diferente");

      print(estoqueAfter.length);
    
     
  
    }

    



  }


}
