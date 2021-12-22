import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:provider/provider.dart';
class ProdutosTileAntesReposicao extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;

  ProdutosTileAntesReposicao(this.data, this.dataProdutos);

  @override
  _ProdutosTileAntesReposicaoState createState() =>
      _ProdutosTileAntesReposicaoState();
}

class _ProdutosTileAntesReposicaoState
    extends State<ProdutosTileAntesReposicao> {
  final _quantidadeProdutoController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); //create global key with FormState type

  final FocusNode myFocus = FocusNode();

  int qtdMinima, qtdAtual = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 60,
        child: ListTile(
          trailing: Container(
            width: 70,
            decoration: new BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: EdgeInsets.all(1),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("Empresas")
                      .document(widget.data.empresaResponsavel)
                      .collection("pesquisasCriadas")
                      .document(widget.data.id)
                      .collection("estoqueDeposito")
                      .document(widget.dataProdutos.nomeProduto)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    } else if (snapshot.data["antesReposicao"] != 9999) {
                      int valorAnterior = 0;
                      valorAnterior = snapshot.data["antesReposicao"];
                      _quantidadeProdutoController.text =
                          valorAnterior.toString();
                      return FocusScope(
                          onFocusChange: (value) {
                            if (!value) {
                              //here checkAndUpdate();
                              print(
                                  int.parse(_quantidadeProdutoController.text));
                              qtdAtual =
                                  int.parse(_quantidadeProdutoController.text);
                              qtdMinima = widget.dataProdutos.qtdMinAreaVenda;

                              DocumentReference documentReference = Firestore
                                  .instance
                                  .collection("Empresas")
                                  .document(widget.data.empresaResponsavel)
                                  .collection("pesquisasCriadas")
                                  .document(widget.data.id)
                                  .collection("estoqueDeposito")
                                  .document(widget.dataProdutos.nomeProduto);

                              print(qtdAtual);
                              bool rupturaConfirmadaDefinitivo =
                                  qtdAtual == 0 ? true : false;
                              documentReference.updateData(
                                {
                                  "nomeLinha": widget.dataProdutos.nomeLinha,
                                  "nomeProduto":
                                      widget.dataProdutos.nomeProduto,
                                  "antesReposicao": int.parse(
                                      _quantidadeProdutoController.text),
                                  "qtdMinAreaVenda": qtdMinima,
                                  "qtdAtual": qtdAtual,
                                  "rupturaConfirmada":
                                      rupturaConfirmadaDefinitivo
                                },
                              );

//                    FocusScope.of(context).unfocus();
                              // Flushbar(
                              //   title: "Informação respondida com sucesso.",
                              //   message:
                              //       "A quantidade anterior de ${_quantidadeProdutoController.text} "
                              //       "${widget.dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                              //   backgroundGradient: LinearGradient(
                              //       colors: [Colors.blue, Colors.teal]),
                              //   backgroundColor: Colors.red,
                              //   duration: Duration(seconds: 3),
                              //   boxShadows: [
                              //     BoxShadow(
                              //       color: Colors.blue[800],
                              //       offset: Offset(0.0, 2.0),
                              //       blurRadius: 5.0,
                              //     )
                              //   ],
                              // )..show(context);

                            }
                          },
                          child: TextField(
                            onEditingComplete: () async {
                              qtdAtual =
                                  int.parse(_quantidadeProdutoController.text);
                              qtdMinima = widget.dataProdutos.qtdMinAreaVenda;

                              DocumentReference documentReference = Firestore
                                  .instance
                                  .collection("Empresas")
                                  .document(widget.data.empresaResponsavel)
                                  .collection("pesquisasCriadas")
                                  .document(widget.data.id)
                                  .collection("estoqueDeposito")
                                  .document(widget.dataProdutos.nomeProduto);

                              print(qtdAtual == 0);
                              bool rupturaConfirmadaDefinitivo = qtdAtual == 0;

                              documentReference.updateData(
                                {
                                  "nomeLinha": widget.dataProdutos.nomeLinha,
                                  "nomeProduto":
                                      widget.dataProdutos.nomeProduto,
                                  "antesReposicao": int.parse(
                                      _quantidadeProdutoController.text),
                                  "qtdMinAreaVenda": qtdMinima,
                                  "qtdAtual": qtdAtual,
                                  "rupturaConfirmada":
                                      rupturaConfirmadaDefinitivo
                                },
                              );

//                    FocusScope.of(context).unfocus();
                              // Flushbar(
                              //   title: "Informação respondida com sucesso.",
                              //   message:
                              //       "A quantidade anterior de ${_quantidadeProdutoController.text} "
                              //       "${widget.dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                              //   backgroundGradient: LinearGradient(
                              //       colors: [Colors.blue, Colors.teal]),
                              //   backgroundColor: Colors.red,
                              //   duration: Duration(seconds: 3),
                              //   boxShadows: [
                              //     BoxShadow(
                              //       color: Colors.blue[800],
                              //       offset: Offset(0.0, 2.0),
                              //       blurRadius: 5.0,
                              //     )
                              //   ],
                              // )..show(context);
                              print("Aew");
                            },
                            onChanged: (String value) {},
                            controller: _quantidadeProdutoController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 12,
                                color: Colors.black),
                            focusNode: myFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ));
                    } else {
                      int valorAnterior = 0;
                      _quantidadeProdutoController.text = "";
                      return FocusScope(
                        onFocusChange: (value) {
                          if (!value) {
                            qtdAtual =
                                int.parse(_quantidadeProdutoController.text);
                            qtdMinima = widget.dataProdutos.qtdMinAreaVenda;

                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("Empresas")
                                .document(widget.data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(widget.data.id)
                                .collection("estoqueDeposito")
                                .document(widget.dataProdutos.nomeProduto);

                            documentReference.updateData({
                              "nomeLinha": widget.dataProdutos.nomeLinha,
                              "nomeProduto": widget.dataProdutos.nomeProduto,
                              "antesReposicao":
                                  int.parse(_quantidadeProdutoController.text),
                              "qtdMinAreaVenda": qtdMinima,
                              "qtdAtual": qtdAtual,
                              "rupturaConfirmada":
                                  _quantidadeProdutoController.text == "0" &&
                                          widget.dataProdutos.rupturaInicial ==
                                              true
                                      ? true
                                      : false
                            });
                          }
                        },
                        child: TextField(
                          onEditingComplete: () async {
                            qtdAtual =
                                int.parse(_quantidadeProdutoController.text);
                            qtdMinima = widget.dataProdutos.qtdMinAreaVenda;

                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("Empresas")
                                .document(widget.data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(widget.data.id)
                                .collection("estoqueDeposito")
                                .document(widget.dataProdutos.nomeProduto);

                            documentReference.updateData(
                              {
                                "nomeLinha": widget.dataProdutos.nomeLinha,
                                "nomeProduto": widget.dataProdutos.nomeProduto,
                                "antesReposicao": int.parse(
                                    _quantidadeProdutoController.text),
                                "qtdMinAreaVenda": qtdMinima,
                                "qtdAtual": qtdAtual,
                                "rupturaConfirmada":
                                    _quantidadeProdutoController.text == "0" &&
                                            widget.dataProdutos
                                                    .rupturaInicial ==
                                                true
                                        ? true
                                        : false
                              },
                            );

//                    FocusScope.of(context).unfocus();
                            // Flushbar(
                            //   title: "Informação respondida com sucesso.",
                            //   message:
                            //       "A quantidade anterior de ${_quantidadeProdutoController.text} "
                            //       "${widget.dataProdutos.nomeProduto} foi adicionada a Pesquisa.",
                            //   backgroundGradient: LinearGradient(
                            //       colors: [Colors.blue, Colors.teal]),
                            //   backgroundColor: Colors.red,
                            //   duration: Duration(seconds: 3),
                            //   boxShadows: [
                            //     BoxShadow(
                            //       color: Colors.blue[800],
                            //       offset: Offset(0.0, 2.0),
                            //       blurRadius: 5.0,
                            //     )
                            //   ],
                            // )..show(context);
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
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    }
                  },
                )),
          ),
          title: Container(
            width: 300,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "" + widget.dataProdutos.nomeProduto,
                softWrap: false,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "QuickSand",
                    fontSize: 12,
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
