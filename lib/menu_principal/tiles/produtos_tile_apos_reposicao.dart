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
        height: 60,
        child: ListTile(
          trailing: Container(
            width: 60,
            decoration: new BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: EdgeInsets.all(2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    width: 70,
                    height: 30,
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
                        } else {
                          _quantidadeProdutoController.text =
                              snapshot.data["aposReposicao"].toString() ==
                                      "9999"
                                  ? "0"
                                  : snapshot.data["aposReposicao"].toString();

                          return TextField(
                            onEditingComplete: () async {
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
                                  "aposReposicao": int.tryParse(
                                          _quantidadeProdutoController.text) ??
                                      0,
                                  "qtdReposto": int.tryParse(
                                          _quantidadeProdutoController.text) ??
                                      0 - dataProdutos.antesReposicao,
                                },
                              );

                              // FocusScope.of(context).unfocus();
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
                    ),
                  ),
                )),
          ),
          title: Container(
            width: 300,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "" + dataProdutos.nomeProduto,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
