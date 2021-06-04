import 'dart:io';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/menu_principal/product_tile_ruptura_screen.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/menu_principal/product_tile_validade_screen.dart';
import 'package:versaoPromotores/menu_principal/responder_pesquisa/responder_presquisa_widget.dart';
import 'package:versaoPromotores/menu_principal/screens/base/base_screen_research.dart';
import 'package:versaoPromotores/menu_principal/screens/pesquisa_aposReposicao.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_one.dart';
import 'package:versaoPromotores/menu_principal/tiles/produtos_tile_antes_reposicao.dart';
import 'package:versaoPromotores/models/user_manager.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/styles/style.dart';
import 'package:versaoPromotores/styles/theme.dart' as Theme;
import 'package:versaoPromotores/widget/bottomSheetView.dart';

import '../datas/pesquisaData.dart';

class ResponderPesquisaData extends StatefulWidget {
  PesquisaData data;

  ResponderPesquisaData(this.data);

  @override
  _ResponderPesquisaDataState createState() =>
      _ResponderPesquisaDataState(this.data);
}

class _ResponderPesquisaDataState extends State<ResponderPesquisaData> {
  //Instanciar a classe modelo para recuperar as informações da pesquisa
  PesquisaData data;
  final _linhaProdutoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _instrucaoController = TextEditingController();
  final FocusNode myFocusPesquisa = FocusNode();
  final FocusNode myFocusData = FocusNode();
  final FocusNode myFocusNomeLoja = FocusNode();
  final FocusNode myFocusNomePromotor = FocusNode();
  final FocusNode myFocusLinhaProduto = FocusNode();
  final FocusNode myFocusObservacao = FocusNode();
  final FocusNode myFocusInstrucao = FocusNode();

  final int _numPages =
      3; //Numero total de telas para responder a pesquisa antes da reposição

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // List<Widget> _buildPageIndicator() {
  //   List<Widget> list = [];
  //   for (int i = 0; i < 5; i++) {
  //     list.add(i == _currentPage ? _indicator(true) : _indicator(false));
  //   }
  //   return list;
  // }
  //Pesquisa

  String dataInicioPesquisa, dataFinalPesquisa, nomeRede;

  List<String> avancarAntesReposicao;

  String title = "Área de Venda";
  String concluido = "não";

  _ResponderPesquisaDataState(this.data);
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

  mudarTitulo(String texto) async {
    title = texto;
  }

  @override
  Widget build(BuildContext context) {
    var lista = new List<int>(data.linhaProduto.length);

    bool pesquisaCompleta() {
      var resultFirstWhere = lista.every((el) => el == 0);

      return resultFirstWhere;
    }

//    userManager.user.id
    _observacaoController.text = data.observacao;
    _instrucaoController.text = "Instruções de reposição...";
    return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('pt'), const Locale('BR')],
        home: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return Scaffold(
                backgroundColor: Color(0xFFEBEDF5),
                appBar: AppBar(
                  title: Consumer<ResearchManager>(
                    
                    builder: (_, researchManager, __) {
                      return Text(researchManager.titleScreen,
                          style: TextStyle(fontFamily: "QuickSand"));
                    },
                  ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.75,
                                          child: BaseScreenResearch()),
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
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                onPressed: () async {
                                                  //Limpar Area de Venda

                                                  DocumentReference
                                                      documentReference1 =
                                                      await Firestore.instance
                                                          .collection(
                                                              "Empresas")
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
                                                  DocumentReference
                                                      documentReference3 =
                                                      await Firestore.instance
                                                          .collection(
                                                              "Empresas")
                                                          .document(data
                                                              .empresaResponsavel)
                                                          .collection(
                                                              "pesquisasCriadas")
                                                          .document(data.id);

                                                  await Firestore.instance
                                                    ..collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "antesReposicao")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference.delete();
                                                      }
                                                      ;
                                                    });

                                                  await Firestore.instance
                                                    ..collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "estoqueDeposito")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference.delete();
                                                      }
                                                      ;
                                                    });

                                                  await Firestore.instance
                                                    ..collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "pontoExtra")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
                                                          "existe": false,
                                                          "imagemAntes":
                                                              "nenhuma",
                                                          "imagemDepois":
                                                              "nenhuma"
                                                        });
                                                      }
                                                      ;
                                                    });

                                                  await Firestore.instance
                                                      .collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection(
                                                          "linhasProdutos")
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
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "linhasProdutosAntesReposicao")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
                                                          "concluida": false
                                                        });
                                                      }
                                                      ;
                                                    });

                                                  await Firestore.instance
                                                    ..collection("Empresas")
                                                        .document(data
                                                            .empresaResponsavel)
                                                        .collection(
                                                            "pesquisasCriadas")
                                                        .document(data.id)
                                                        .collection(
                                                            "linhasProdutosAposReposicao")
                                                        .getDocuments()
                                                        .then((snapshot) {
                                                      for (DocumentSnapshot ds
                                                          in snapshot
                                                              .documents) {
                                                        ds.reference
                                                            .updateData({
                                                          "concluida": false
                                                        });
                                                      }
                                                      ;
                                                    });

                                                  documentReference1.delete();

                                                  context.read<UserManager>();
                                                  Navigator
                                                      .pushReplacementNamed(
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
        ));
  }

  // Create week date picker with passed parameters
  Widget buildWeekDatePicker(DateTime selectedDate, DateTime firstAllowedDate,
      DateTime lastAllowedDate, ValueChanged<DatePeriod> onNewSelected) {
    // add some colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
      selectedPeriodStartDecoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration:
          BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );

    return WeekPicker(
        selectedDate: selectedDate,
        onChanged: onNewSelected,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate,
        datePickerStyles: styles);
  }
}
