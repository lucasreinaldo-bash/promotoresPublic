import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:intl/intl.dart';

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
  final _titleProdutoController = TextEditingController();

  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  String dataFormatadaField;
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
          trailing: GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2021, 5, 5).toLocal(),
                  maxTime: DateTime(2024, 6, 7), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                String dia = date.day.toString().length == 1
                    ? "0" + date.day.toString()
                    : date.day.toString();
                String mes = date.month.toString().length == 1
                    ? "0" + date.month.toString()
                    : date.month.toString();

                String dataFormatada = "$dia/$mes/" + date.year.toString();

                _validadeProdutoController.text = dataFormatada;
                DocumentReference documentReference = Firestore.instance
                    .collection("Empresas")
                    .document(data.empresaResponsavel)
                    .collection("pesquisasCriadas")
                    .document(data.id)
                    .collection("vencimentosProximos")
                    .document(dataProdutos.nomeLinha)
                    .collection("Produtos")
                    .document(dataProdutos.nomeProduto);

                documentReference.setData(
                  {
                    "linha": dataProdutos.nomeLinha,
                    "produto": dataProdutos.nomeProduto,
                    "validade": dataFormatada,
                  },
                );

                List list = new List<String>.from(data.tag);

                list.add("VENCIMENTOS PRÓXIMOS");

                DocumentReference documentReference2 = Firestore.instance
                    .collection("Empresas")
                    .document(data.empresaResponsavel)
                    .collection("pesquisasCriadas")
                    .document(data.id);

                documentReference2
                    .updateData({"tagVencimentoProximo": true, "tag": list});

                DocumentReference documentReferenceAntesReposicao = Firestore
                    .instance
                    .collection("Empresas")
                    .document(data.empresaResponsavel)
                    .collection("pesquisasCriadas")
                    .document(data.id)
                    .collection("linhasProdutosAntesReposicao")
                    .document(dataProdutos.nomeLinha);

                documentReferenceAntesReposicao.updateData(
                  {
                    "tags": FieldValue.arrayUnion(["Vencimento"])
                  },
                );
                FocusScope.of(context).unfocus();
                Flushbar(
                  title: "Informação respondida com sucesso.",
                  message:
                      "O produto ${dataProdutos.nomeProduto} vai vencer na data de ${dataFormatada}.",
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
                print('confirm $dataFormatada');
              }, currentTime: DateTime.now(), locale: LocaleType.pt);
            },
            child: Container(
              width: 110,
              decoration: new BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 70,
                        height: 30,
                        child: TextField(
                          inputFormatters: [dataFormatter],
                          enabled: false,
                          controller: _validadeProdutoController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 9,
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "20/12/1990",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 22,
                      width: 22,
                      child: Image.asset("assets/calendar_icon.png"),
                    )
                  ],
                ),
              ),
            ),
          ),
          title: Container(
            width: 200,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "" + dataProdutos.nomeProduto,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Helvetica",
                    fontSize: 16,
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
