import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_antes_reposicao.dart';

class ResearchScreenTwo extends StatefulWidget {
  bool previa = false;
  ResearchScreenTwo({this.previa});
  @override
  _ResearchScreenTwoState createState() => _ResearchScreenTwoState();
}

class _ResearchScreenTwoState extends State<ResearchScreenTwo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.previa == true) {
      Future.delayed(
          Duration(seconds: 2), () => context.read<PageManager>().nextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ResearchManager>().titleScreen = "Estoque Depósito";
    return Consumer<ResearchManager>(
      builder: (_, researchManager, __) {
        return Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 5, right: 5, bottom: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Informe as quantidades dos produtos que estão no depósito da loja antes da reposição. (em unid.)",
                          style: TextStyle(
                              fontFamily: "QuickSand",
                              color: Color(0xFF000000)),
                        ),
                        Container(
                          height: 4,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          color: Colors.black12,
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                        ),
                        FutureBuilder(
                          future: Firestore.instance
                              .collection("Empresas")
                              .document(researchManager.data.empresaResponsavel)
                              .collection("Lojas")
                              .document(researchManager.data.nomeLoja)
                              .collection("Produtos")
                              .getDocuments(),
                          builder: (context, snapshotProdutos) {
                            if (!snapshotProdutos.hasData) {
                              return LinearProgressIndicator();
                            } else {
                              return Container(
                                height: 300,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshotProdutos.data.documents.length,
                                    itemBuilder: (_, index) {
                                      ProductData dataProduto =
                                          ProductData.fromDocument(
                                              snapshotProdutos
                                                  .data.documents[index]);

                                      return ProdutosTileAntesReposicao(
                                          researchManager.data, dataProduto);
                                    }),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 15.0),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    context.read<PageManager>().previusPage();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Voltar',
                                        style: TextStyle(
                                          fontFamily: "Helvetica",
                                          color: Color(0xFF707070),
                                          fontSize: 22.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    context.read<PageManager>().nextPage();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Avançar',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: "Helvetica",
                                          color: Color(0xFF707070),
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
