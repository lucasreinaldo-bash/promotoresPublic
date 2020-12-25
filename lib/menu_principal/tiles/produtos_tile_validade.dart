import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class ProdutosTileValidade extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;

  ProdutosTileValidade(this.data, this.dataProdutos);
  @override
  _ProdutosTileValidadeState createState() =>
      _ProdutosTileValidadeState(this.data, this.dataProdutos);
}

class _ProdutosTileValidadeState extends State<ProdutosTileValidade> {
  ProductData dataProdutos;
  PesquisaData data;
  final _validadeProdutoController = TextEditingController();
  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  var dataFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  _ProdutosTileValidadeState(this.data, this.dataProdutos);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 50,
        width: 200,
        child: ListTile(
          trailing: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: 60,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  inputFormatters: [dataFormatter],
                  onEditingComplete: () {
                    DocumentReference documentReference = Firestore.instance
                        .collection("Empresas")
                        .document(data.empresaResponsavel)
                        .collection("pesquisasCriadas")
                        .document(data.id)
                        .collection("antesReposicao")
                        .document(dataProdutos.nomeProduto);

                    documentReference.updateData(
                      {
                        "linha": dataProdutos.nomeLinha,
                        "produto": dataProdutos.nomeProduto,
                        "validade": _validadeProdutoController.text,
                      },
                    );
                    FocusScope.of(context).unfocus();
                    Flushbar(
                      title: "Informação respondida com sucesso.",
                      message:
                          "O produto ${dataProdutos.nomeProduto} vai vencer na data de ${_validadeProdutoController.text}.",
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
                  controller: _validadeProdutoController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 6,
                      color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "20/12/1990",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: 200,
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
      ),
    );
  }
}
