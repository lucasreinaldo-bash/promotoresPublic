import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import '../../models/user_manager.dart';

class ResearchScreenThree extends StatelessWidget {
  final _instrucaoController = TextEditingController();
  final FocusNode myFocusInstrucao = FocusNode();
  @override
  Widget build(BuildContext context) {
    context.read<ResearchManager>().titleScreen = ("Intruções de Reposição");

    return Consumer<UserManager>(builder: (_, userManager, __) {
      return StreamBuilder(
        stream: Firestore.instance
            .collection("Empresas")
            .document(userManager.user.empresaVinculada)
            .snapshots(),
        builder: (context, snapInstrucao) {
          if (!snapInstrucao.hasData) {
            return CircularProgressIndicator();
          } else {
            _instrucaoController.text = snapInstrucao.data["instrução"];
            return Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 15),
                    child: Container(
                      height: 600,
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
                                "Siga as instruções abaixo para realizar a reposição dos produtos",
                                style: TextStyle(
                                    fontFamily: "QuickSand",
                                    fontSize: 14,
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
                              SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextField(
                                      focusNode: myFocusInstrucao,
                                      enabled: false,
                                      maxLines: 10,
                                      controller: _instrucaoController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 13.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        hintStyle: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        onPressed: () {
                                          context
                                              .read<PageManager>()
                                              .previusPage();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          context
                                              .read<PageManager>()
                                              .nextPage();
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PesquisaAposReposicao(data)));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                )
              ],
            );
          }
        },
      );
    });
  }
}
