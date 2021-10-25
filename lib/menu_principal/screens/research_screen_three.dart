import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import '../../models/user_manager.dart';

class ResearchScreenThree extends StatefulWidget {
  bool previa = false;
  ResearchScreenThree({this.previa});

  @override
  _ResearchScreenThreeState createState() => _ResearchScreenThreeState();
}

class _ResearchScreenThreeState extends State<ResearchScreenThree> {
  final _instrucaoController = TextEditingController();

  final FocusNode myFocusInstrucao = FocusNode();

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
    context.read<ResearchManager>().titleScreen = ("Intruções de Reposição");

    Widget html = Html(
      data: """<div>
        <h1>Demo Page</h1>
        <p>This is a fantastic product that you should buy!</p>
        <h3>Features</h3>
        <ul>
          <li>It actually works</li>
          <li>It exists</li>
          <li>It doesn't cost much!</li>
        </ul>
        <!--You can pretty much put any html in here!-->
      </div>""",
    );
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return StreamBuilder(
        stream: Firestore.instance
            .collection("Empresas")
            .document(userManager.user.empresaVinculada)
            .snapshots(),
        builder: (context, snapInstrucao) {
          Widget html = Html(
            data: """<div>
              ${snapInstrucao.data["instrucao"]}
        <!--You can pretty much put any html in here!-->
      </div>""",
          );
          if (!snapInstrucao.hasData) {
            return CircularProgressIndicator();
          } else {
            _instrucaoController.text = snapInstrucao.data["instrucao"];
            return Padding(
              padding:
                  const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 15),
              child: Container(
                height: 600,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                "Siga as instruções abaixo para realizar a reposição dos produtos",
                                style: TextStyle(
                                    fontFamily: "QuickSand",
                                    fontSize: 14,
                                    color: Color(0xFF000000)),
                              ),
                              Container(
                                color: Colors.black12,
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Colors.black12),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SingleChildScrollView(child: html),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
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
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PesquisaAposReposicao(data)));
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
            );
          }
        },
      );
    });
  }
}
