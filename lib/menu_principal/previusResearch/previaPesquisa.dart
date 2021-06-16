import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/menu_principal/screens/base/base_screen_research.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_five.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_four.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_one.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_three.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_two.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import 'package:versaoPromotores/models/user_manager.dart';
import '../../splash_screen_pesquisaRespondida.dart';
import '../datas/pesquisaData.dart';

class PreviaPesquisa extends StatelessWidget {
  //Instanciar a classe modelo para recuperar as informações da pesquisa
  PesquisaData data;

  String title = "Área de Venda";
  String concluido = "não";
  final PageController pageController = PageController();
  PreviaPesquisa(this.data);
  //Metodo para setar os buttons
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width: isActive ? 44.0 : 32.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white70 : Color(0xFF7C6DEA),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lista = new List<int>(data.linhaProduto.length);

    bool pesquisaCompleta() {
      var resultFirstWhere = lista.every((el) => el == 0);

      return resultFirstWhere;
    }

    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return Scaffold(
            backgroundColor: Color(0xFFEBEDF5),
            appBar: AppBar(
              title: Text("Recaptulando Pesquisa..."),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("Empresas")
                          .document(userManager.user.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      child: ChangeNotifierProvider(
                                        create: (_) =>
                                            PageManager(pageController),
                                        child: PageView(
                                          allowImplicitScrolling: false,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          controller: pageController,
                                          children: [
                                            ResearchScreenOne(
                                              previa: true,
                                            ),
                                            ResearchScreenTwo(previa: true,),
                                            ResearchScreenThree(previa: true,),
                                            ResearchScreenFour(previa: true,),
                                            ResearchScreenFive(previa: true,),
                                            SplashScreenPesquisaRespondida()
                                          ],
                                        ),
                                      )),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 200,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () async {
                                              //Limpar Area de Venda

                                              DocumentReference
                                                  documentReference1 =
                                                  await Firestore.instance
                                                      .collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection(
                                                          "imagensLinhas")
                                                      .getDocuments()
                                                      .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                    in snapshot.documents) {
                                                  ds.reference.delete();
                                                }
                                              });

                                              await Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id)
                                                  .collection("antesReposicao")
                                                  .getDocuments()
                                                  .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                    in snapshot.documents) {
                                                  ds.reference.delete();
                                                }
                                                ;
                                              });

                                              await Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id)
                                                  .collection("estoqueDeposito")
                                                  .getDocuments()
                                                  .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                    in snapshot.documents) {
                                                  ds.reference.delete();
                                                }
                                                ;
                                              });

                                              await Firestore.instance
                                                ..collection("Empresas")
                                                    .document(
                                                        data.empresaResponsavel)
                                                    .collection(
                                                        "pesquisasCriadas")
                                                    .document(data.id)
                                                    .collection("pontoExtra")
                                                    .getDocuments()
                                                    .then((snapshot) {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.documents) {
                                                    ds.reference.updateData({
                                                      "existe": false,
                                                      "imagemAntes": "nenhuma",
                                                      "imagemDepois": "nenhuma"
                                                    });
                                                  }
                                                  ;
                                                });

                                              await Firestore.instance
                                                  .collection("Empresas")
                                                  .document(
                                                      data.empresaResponsavel)
                                                  .collection(
                                                      "pesquisasCriadas")
                                                  .document(data.id)
                                                  .collection("linhasProdutos")
                                                  .getDocuments()
                                                  .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                    in snapshot.documents) {
                                                  ds.reference.updateData(
                                                      {"concluida": false});
                                                }
                                                ;
                                              });

                                              await Firestore.instance
                                                ..collection("Empresas")
                                                    .document(
                                                        data.empresaResponsavel)
                                                    .collection(
                                                        "pesquisasCriadas")
                                                    .document(data.id)
                                                    .collection(
                                                        "linhasProdutosAntesReposicao")
                                                    .getDocuments()
                                                    .then((snapshot) {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.documents) {
                                                    ds.reference.updateData(
                                                        {"concluida": false});
                                                  }
                                                  ;
                                                });

                                              await Firestore.instance
                                                ..collection("Empresas")
                                                    .document(
                                                        data.empresaResponsavel)
                                                    .collection(
                                                        "pesquisasCriadas")
                                                    .document(data.id)
                                                    .collection(
                                                        "linhasProdutosAposReposicao")
                                                    .getDocuments()
                                                    .then((snapshot) {
                                                  for (DocumentSnapshot ds
                                                      in snapshot.documents) {
                                                    ds.reference.updateData(
                                                        {"concluida": false});
                                                  }
                                                  ;
                                                });

                                              documentReference1.delete();

                                              context.read<UserManager>();
                                              Navigator.pushReplacementNamed(
                                                  context, "/homeMenu");
                                            },
                                            color: Color(0xFFF26868),
                                            textColor: Colors.white,
                                            child: Text("Cancelar Pesquisa",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        "QuickSandRegular")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
