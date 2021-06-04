import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/widget/bottomSheetView.dart';
import '../../models/user_manager.dart';
import 'package:flare_flutter/flare_actor.dart';

class ResearchScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lista =
        new List<int>(context.read<ResearchManager>().data.linhaProduto.length);

    bool pesquisaCompleta() {
      var resultFirstWhere = lista.every((el) => el == 0);

      return resultFirstWhere;
    }

    return Consumer<UserManager>(
      builder: (_, userManager, __) {
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
                          "Faça a pesquisa para cada linha de produto abaixo antes de iniciar a reposição.",
                          style: TextStyle(
                              fontFamily: "QuickSand",
                              color: Color(0xFF000000)),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .read<ResearchManager>()
                                  .data
                                  .linhaProduto
                                  .length,
                              itemBuilder: (_, index) {
                                String nomeCategoria = context
                                    .read<ResearchManager>()
                                    .data
                                    .linhaProduto[index];
                                bool nomeCategoriaBool = false;

                                return InkWell(
                                  onTap: () {
                                    showBarModalBottomSheet(
                                        expand: false,
                                        isDismissible: false,
                                        context: context,
                                        builder: (context) => Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                8,
                                            child: BottomSheetView(
                                                nomeCategoria)));
                                  },
                                  child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: StreamBuilder(
                                        stream: Firestore.instance
                                            .collection("Empresas")
                                            .document(context
                                                .read<ResearchManager>()
                                                .data
                                                .empresaResponsavel)
                                            .collection("pesquisasCriadas")
                                            .document(context
                                                .read<ResearchManager>()
                                                .data
                                                .id)
                                            .collection(
                                                "linhasProdutosAntesReposicao")
                                            .document(nomeCategoria)
                                            .snapshots(),
                                        builder: (context, snapshotLinhas) {
                                          if (!snapshotLinhas.hasData) {
                                            return Container();
                                          } else {
                                            if (snapshotLinhas
                                                    .data["concluida"] ==
                                                false) {
                                              lista[index] = 1;
                                            } else {
                                              lista[index] = 0;
                                            }

                                            return snapshotLinhas
                                                        .data["concluida"] ==
                                                    true
                                                ? ListTile(
                                                    trailing: Card(
                                                      color: Color(0xFF4FCEB6),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          "Concluída",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "QuickSandRegular"),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      "" + nomeCategoria,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSand",
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    subtitle: Text(
                                                      "Toque para editar a pesquisa",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  )
                                                : ListTile(
                                                    trailing: Card(
                                                      color: Color(0xFFF26868),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          "A Iniciar",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "QuickSandRegular"),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      "" + nomeCategoria,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSand",
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    subtitle: Text(
                                                      "Toque para editar a pesquisa",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  );
                                          }
                                        },
                                      )),
                                );
                              }),
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
                                    // context
                                    //     .read<ResearchManager>()
                                    //     .titleScreen("Observações");
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
                                    ],
                                  ),
                                ),
                                FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          ' Avançar',
                                          style: TextStyle(
                                            fontFamily: "Helvetica",
                                            color: Color(0xFF707070),
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      bool resultado = await pesquisaCompleta();

                                      if (resultado == true) {
                                        print(true);

                                        context.read<PageManager>().nextPage();
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => FlareGiffyDialog(
                                                  flarePath:
                                                      'assets/seach_cloud.flr',
                                                  flareAnimation: 'products',
                                                  title: Text(
                                                    'Existe pesquisa não respondida!',
                                                    style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  description: Text(
                                                    'Você precisa responder todas as pesquisas antes de continuar.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(),
                                                  ),
                                                  onOkButtonPressed: () {
                                                    Navigator.pop(_);
                                                  },
                                                  onlyOkButton: true,
                                                  entryAnimation:
                                                      EntryAnimation.DEFAULT,
                                                ));
                                      }
                                    })
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
