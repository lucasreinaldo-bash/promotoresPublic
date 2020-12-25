import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class ProdutosTileAntesReposicao extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;

  ProdutosTileAntesReposicao(this.data, this.dataProdutos);
  @override
  _ProdutosTileAntesReposicaoState createState() =>
      _ProdutosTileAntesReposicaoState(this.data, this.dataProdutos);
}

class _ProdutosTileAntesReposicaoState
    extends State<ProdutosTileAntesReposicao> {
  ProductData dataProdutos;
  PesquisaData data;
  final _quantidadeProdutoController = TextEditingController();

  _ProdutosTileAntesReposicaoState(this.data, this.dataProdutos);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 50,
        child: ListTile(
          trailing: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: 60,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onEditingComplete: () {
                    DocumentReference documentReference = Firestore.instance
                        .collection("Empresas")
                        .document(data.empresaResponsavel)
                        .collection("pesquisasCriadas")
                        .document(data.id)
                        .collection("estoqueDeposito")
                        .document(dataProdutos.nomeProduto);

                    documentReference.setData(
                      {
                        "linha": dataProdutos.nomeLinha,
                        "produto": dataProdutos.nomeProduto,
                        "antesReposicao":
                            int.parse(_quantidadeProdutoController.text),
                      },
                    );
                    FocusScope.of(context).unfocus();
                    Flushbar(
                      title: "Informação respondida com sucesso.",
                      message:
                          "A quantidade anterior de ${_quantidadeProdutoController.text} ${dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                      backgroundGradient:
                          LinearGradient(colors: [Colors.blue, Colors.teal]),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      boxShadows: [
                        BoxShadow(
                          color: Colors.blue[800],
                          offset: Offset(0.0, 2.0),
                          blurRadius: 5.0,
                        )
                      ],
                    )..show(context);
                  },
                  controller: _quantidadeProdutoController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 12,
                      color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          title: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: 300,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "" + dataProdutos.nomeProduto,
                  style: TextStyle(
                      fontFamily: "QuickSand",
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
