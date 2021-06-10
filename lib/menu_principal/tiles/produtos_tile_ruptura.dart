import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/widget/checkbox_model.dart';
import 'package:versaoPromotores/widget/checkbox_widget.dart';

class ProdutosTileRuptura extends StatefulWidget {
  ProductData dataProdutos;
  PesquisaData data;
  String nomeCategoria;

  ProdutosTileRuptura(this.data, this.dataProdutos, this.nomeCategoria);
  @override
  _ProdutosTileRupturaState createState() => _ProdutosTileRupturaState(
      this.data, this.dataProdutos, this.nomeCategoria);
}

class _ProdutosTileRupturaState extends State<ProdutosTileRuptura> {
  ProductData dataProdutos;
  PesquisaData data;
  final _rupturaController = TextEditingController();
  String dataInicioPesquisa, dataFinalPesquisa, nomeRede, nomeCategoria;

  var dataFormatter =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

// ...

  _ProdutosTileRupturaState(this.data, this.dataProdutos, this.nomeCategoria);

  bool valueRadio = false;

  @override
  Widget build(BuildContext context) {
    SingingCharacter _character = SingingCharacter.lafayette;

    return GestureDetector(
    
      child: ListTile(
        title: InkWell(
          child: Container(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "" + dataProdutos.nomeProduto,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      StreamBuilder(
                        stream: Firestore.instance
                            .collection("Empresas")
                            .document(data.empresaResponsavel)
                            .collection("Lojas")
                            .document(data.nomeLoja)
                            .collection("Produtos")
                            .document(dataProdutos.nomeProduto)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LinearProgressIndicator();
                          } else {
                            int qtdMinima = snapshot.data["qtdMinAreaVenda"];
                            return Text("< $qtdMinima   ");
                          }
                        },
                      ),
                      
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              valueRadio = !valueRadio;
                            });
                            await Firestore.instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(data.id)
                                .collection("estoqueDeposito")
                                .document(dataProdutos.nomeProduto)
                                .updateData({"rupturaInicial": valueRadio});

                            await Firestore.instance
                                .collection("Empresas")
                                .document(data.empresaResponsavel)
                                .collection("pesquisasCriadas")
                                .document(data.id)
                                .updateData({
                              "tags": FieldValue.arrayUnion(["Ruptura"])
                            });
                          },
                          child: valueRadio == false
                              ? Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: new BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: new BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black45),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: new BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.orange,
                                        border:
                                            Border.all(color: Colors.black45),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter { lafayette, jefferson }
