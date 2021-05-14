import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class ProdutosTileAposReposicao extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;

  ProdutosTileAposReposicao(this.data, this.dataProdutos);
  @override
  _ProdutosTileAposReposicaoState createState() =>
      _ProdutosTileAposReposicaoState(this.data, this.dataProdutos);
}

class _ProdutosTileAposReposicaoState extends State<ProdutosTileAposReposicao> {
  ProductData dataProdutos;
  PesquisaData data;
  final _quantidadeProdutoController = TextEditingController();
  final FocusNode myFocus = FocusNode();

  _ProdutosTileAposReposicaoState(this.data, this.dataProdutos);
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
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("Empresas")
                        .document(data.empresaResponsavel)
                        .collection("pesquisasCriadas")
                        .document(data.id)
                        .collection("estoqueDeposito")
                        .document(dataProdutos.nomeProduto)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LinearProgressIndicator();
                      } else if (snapshot.data["aposReposicao"] == 9999) {
                        _quantidadeProdutoController.text = "0";
                        return TextField(
                          onEditingComplete: () {
                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(data.id)
                                .collection("estoqueDeposito")
                                .document(dataProdutos.nomeProduto);

                            documentReference.updateData(
                              {
                                "linha": dataProdutos.nomeLinha,
                                "produto": dataProdutos.nomeProduto,
                                "aposReposicao": int.parse(
                                    _quantidadeProdutoController.text),
                              },
                            );
                            FocusScope.of(context).unfocus();
                            Flushbar(
                              title: "Informação respondida com sucesso.",
                              message:
                                  "A quantidade atual de ${_quantidadeProdutoController.text} "
                                  "${dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                              backgroundGradient: LinearGradient(
                                  colors: [Colors.blue, Colors.teal]),
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
                          focusNode: myFocus,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 12,
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "0",
                            border: InputBorder.none,
                          ),
                        );
                      } else {
                        int valorAnterior = 0;
                        _quantidadeProdutoController.text = "0";

                        valorAnterior = snapshot.data["aposReposicao"];
                        _quantidadeProdutoController.text =
                            valorAnterior.toString();
                        return TextField(
                          onEditingComplete: () {
                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(data.id)
                                .collection("estoqueDeposito")
                                .document(dataProdutos.nomeProduto);

                            documentReference.updateData(
                              {
                                "linha": dataProdutos.nomeLinha,
                                "produto": dataProdutos.nomeProduto,
                                "aposReposicao": int.parse(
                                    _quantidadeProdutoController.text),
                              },
                            );
                            FocusScope.of(context).unfocus();
                            Flushbar(
                              title: "Informação respondida com sucesso.",
                              message:
                                  "A quantidade atual de ${_quantidadeProdutoController.text} "
                                  "${dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                              backgroundGradient: LinearGradient(
                                  colors: [Colors.blue, Colors.teal]),
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
                          focusNode: myFocus,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 12,
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "0",
                            border: InputBorder.none,
                          ),
                        );
                      }
                    },
                  )),
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
