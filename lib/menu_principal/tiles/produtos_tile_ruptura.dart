import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';

class ProdutosTileRuptura extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;

  ProdutosTileRuptura(this.data, this.dataProdutos);
  @override
  _ProdutosTileRupturaState createState() =>
      _ProdutosTileRupturaState(this.data, this.dataProdutos);
}

class _ProdutosTileRupturaState extends State<ProdutosTileRuptura> {
  ProductData dataProdutos;
  PesquisaData data;
  final _rupturaController = TextEditingController();
  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  var dataFormatter =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  _ProdutosTileRupturaState(this.data, this.dataProdutos);
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
                        "ruptura": int.parse(_rupturaController.text),
                      },
                    );
                    FocusScope.of(context).unfocus();
                    Flushbar(
                      title: "Informação respondida com sucesso.",
                      message:
                          "O produto ${dataProdutos.nomeProduto} está com ruptura. Apenas ${_rupturaController.text} unidades em estoque.",
                      backgroundGradient:
                          LinearGradient(colors: [Colors.blue, Colors.teal]),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 4),
                      boxShadows: [
                        BoxShadow(
                          color: Colors.blue[800],
                          offset: Offset(0.0, 2.0),
                          blurRadius: 5.0,
                        )
                      ],
                    )..show(context);
                  },
                  controller: _rupturaController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 10,
                      color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "0",
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
