import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_apos_reposicao.dart';
import 'dart:ui';
import 'package:versaoPromotores/models/page_manager.dart';
import 'package:date_format/date_format.dart' as da;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/splash_screen_pesquisaRespondida.dart';

class ResearchScreenFive extends StatefulWidget {
  bool previa = false;
  ResearchScreenFive({this.previa});

  @override
  _ResearchScreenFiveState createState() => _ResearchScreenFiveState();
}

class _ResearchScreenFiveState extends State<ResearchScreenFive> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.previa == true) {
      Future.delayed(
          Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetalhamentoPesquisa())));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          "Informe a quantidade dos produtos que ficaram no depósito da loja após a reposição. (em unid.)",
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
                                      bool nomeCategoriaBool = false;

                                      return ProdutosTileAposReposicao(
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
                                    DocumentReference documentReference3 =
                                        await Firestore.instance
                                            .collection("Empresas")
                                            .document(researchManager
                                                .data.empresaResponsavel)
                                            .collection("pesquisasCriadas")
                                            .document(researchManager.data.id);

                                    documentReference3.updateData({
                                      "status": "A APROVAR",
                                      "tag": FieldValue.arrayRemove(
                                          ["NOVA PESQUISA"]),
                                      "imagemUpload": false,
                                      "dataFinalizacao": da.formatDate(
                                              DateTime.now(), [
                                            da.dd,
                                            '/',
                                            da.mm,
                                            '/',
                                            da.yyyy
                                          ]) +
                                          " às ${da.formatDate(DateTime.now(), [
                                            da.HH,
                                            ':',
                                            da.nn,
                                            ':',
                                            da.ss
                                          ])}",
                                      "data_query_finalizada":
                                          DateTime.now().microsecondsSinceEpoch,
                                    });
                                    context.read<PageManager>().nextPage();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            SplashScreenPesquisaRespondida()));
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
