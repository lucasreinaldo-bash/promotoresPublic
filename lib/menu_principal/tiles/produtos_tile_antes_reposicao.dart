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
  final FocusNode myFocus = FocusNode();

  int qtdMinima, qtdAtual = 0;
  _ProdutosTileAntesReposicaoState(this.data, this.dataProdutos);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 50,
        child: ListTile(
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              decoration: new BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      } else if (snapshot.data["antesReposicao"] != 9999) {
                        int valorAnterior = 0;
                        valorAnterior = snapshot.data["antesReposicao"];
                        _quantidadeProdutoController.text =
                            valorAnterior.toString();
                        return TextField(
                          onEditingComplete: () async {
                            qtdAtual =
                                int.parse(_quantidadeProdutoController.text);
                            qtdMinima = dataProdutos.qtdMinAreaVenda;

                            DocumentReference documentReference =
                                await Firestore.instance
                                    .collection("Empresas")
                                    .document(data.empresaResponsavel)
                                    .collection("pesquisasCriadas")
                                    .document(data.id)
                                    .collection("estoqueDeposito")
                                    .document(dataProdutos.nomeProduto);

                            documentReference.updateData(
                              {
                                "nomeLinha": dataProdutos.nomeLinha,
                                "nomeProduto": dataProdutos.nomeProduto,
                                "antesReposicao": int.parse(
                                    _quantidadeProdutoController.text),
                                "qtdMinAreaVenda": qtdMinima,
                                "qtdAtual": qtdAtual,
                                "rupturaConfirmada":
                                    qtdAtual < qtdMinima ? true : false
                              },
                            );

//                    FocusScope.of(context).unfocus();
                            Flushbar(
                              title: "Informação respondida com sucesso.",
                              message:
                                  "A quantidade anterior de ${_quantidadeProdutoController.text} "
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
                            print("Aew");
                          },
                          controller: _quantidadeProdutoController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 12,
                              color: Colors.black),
                          focusNode: myFocus,
                          decoration: InputDecoration(
                            hintText: "0",
                            border: InputBorder.none,
                          ),
                        );
                      } else {
                        int valorAnterior = 0;
                        _quantidadeProdutoController.text = "0";
                        return TextField(
                          onEditingComplete: () async {
                            qtdAtual =
                                int.parse(_quantidadeProdutoController.text);
                            qtdMinima = dataProdutos.qtdMinAreaVenda;

                            DocumentReference documentReference =
                                await Firestore.instance
                                    .collection("Empresas")
                                    .document(data.empresaResponsavel)
                                    .collection("pesquisasCriadas")
                                    .document(data.id)
                                    .collection("estoqueDeposito")
                                    .document(dataProdutos.nomeProduto);

                            documentReference.updateData(
                              {
                                "nomeLinha": dataProdutos.nomeLinha,
                                "nomeProduto": dataProdutos.nomeProduto,
                                "antesReposicao": int.parse(
                                    _quantidadeProdutoController.text),
                                "qtdMinAreaVenda": qtdMinima,
                                "qtdAtual": qtdAtual,
                                "rupturaConfirmada":
                                    qtdAtual < qtdMinima ? true : false
                              },
                            );

//                    FocusScope.of(context).unfocus();
                            Flushbar(
                              title: "Informação respondida com sucesso.",
                              message:
                                  "A quantidade anterior de ${_quantidadeProdutoController.text} "
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
                            print("Aew");
                          },
                          controller: _quantidadeProdutoController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 12,
                              color: Colors.black),
                          focusNode: myFocus,
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
          title: Container(
            width: 300,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "" + dataProdutos.nomeProduto,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "QuickSand",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
