import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/menu_principal/datas/pontoExtraImagemData.dart';
import 'package:versaoPromotores/menu_principal/responder_pesquisa/responder_pesquisa.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData_ruptura_validade.dart';
import 'package:versaoPromotores/menu_principal/datas/estoqueDeposito_data.dart';
import 'package:versaoPromotores/menu_principal/screens/detalhamento_linha.dart';
import 'package:versaoPromotores/menu_principal/screens/exibirImagem.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/models/user.dart';
import 'package:versaoPromotores/models/user_manager.dart';
import 'package:versaoPromotores/widget/BottomNavigation.dart';
import 'package:versaoPromotores/widget/DialogMotivoReprovacao.dart';

import 'datas/ProdutoData.dart';
import 'datas/pesquisaData.dart';
import 'datas/tagsLinhaData.dart';

class DetalhamentoPesquisa extends StatefulWidget {
  @override
  _DetalhamentoPesquisaState createState() => _DetalhamentoPesquisaState();
}

class _DetalhamentoPesquisaState extends State<DetalhamentoPesquisa> {
  Color colorButtonVoltar = Color(0xFFF26868);
  Color colorButtonIniciarPesquisa = Color(0xFF4FCEB6);
  //Carregando Produtos
  List<ProductData> allProducts = [];
  User user;
  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _observacaoController = TextEditingController();

  _DetalhamentoPesquisaState();

// TODO: A FAZER
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allProducts(loja: context.read<ResearchManager>().data.nomeLoja);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResearchManager>(
      builder: (_, researchManager, __) {
        Future<QuerySnapshot> snapshotQuery = Firestore.instance
            .collection("Empresas")
            .document(researchManager.data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(researchManager.data.id)
            .collection("estoqueDeposito")
            .getDocuments();

        Future<QuerySnapshot> snapshotQuery2 = Firestore.instance
            .collection("Empresas")
            .document(researchManager.data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(researchManager.data.id)
            .collection("linhasProdutosAposReposicao")
            .getDocuments();

        Future<QuerySnapshot> snapshotQuery3 = Firestore.instance
            .collection("Empresas")
            .document(researchManager.data.empresaResponsavel)
            .collection("pesquisasCriadas")
            .document(researchManager.data.id)
            .collection("pontoExtra")
            .getDocuments();
        _observacaoController.text = researchManager.data.observacao;
        return Scaffold(
          bottomNavigationBar: BottomNavigationPesquisa(researchManager.data),
          appBar: AppBar(
              backgroundColor: Color(0xFF796DEA),
              bottomOpacity: 0.0,
              elevation: 0.0,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    "Pesquisa ${researchManager.data.status.toString()[0].toUpperCase() + researchManager.data.status.toString().substring(1).toLowerCase()}",
                    style: TextStyle(fontFamily: "QuickSandRegular"),
                  ),
                ],
              )),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(children: [
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Detalhes da Pesquisa",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "QuickSand",
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      researchManager.data.nomeLoja,
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rede: " + researchManager.data.nomeRede,
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black38),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Promotor: " +
                                          researchManager.data.nomePromotor,
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black38),
                                    ),
                                    Text(
                                      "Agendada: " +
                                          researchManager.data.dataInicial,
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black38),
                                    ),
                                    Text(
                                      researchManager.data.dataFinalizacao !=
                                              "pesquisa não respondida"
                                          ? "Finalizada: ${researchManager.data.dataFinalizacao}"
                                          : "Não finalizada",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black38),
                                    ),
                                    Text(
                                      "Observação:",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black38),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Colors.grey, // set border color
                                            width: 1.0), // set border width
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                14.0)), // set rounded corner radius
                                      ),
                                      height: 150,
                                      child: TextField(
                                        enabled: false,
                                        maxLines: 20,
                                        controller: _observacaoController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 13.0,
                                            color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Linha de Produtos Pesquisadas:",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          color: Colors.black54),
                                    ),
                                    Divider(),
                                    researchManager.data.status != "ABERTA"
                                        ? Text(
                                            "Clique no cartão para vizualizar",
                                            style: TextStyle(
                                                fontFamily: "Helvetica",
                                                fontSize: 12))
                                        : Container(),
                                    Container(
                                      height: 300,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: researchManager
                                            .data.linhaProduto.length,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap:
                                                  researchManager.data.status ==
                                                          "ABERTA"
                                                      ? null
                                                      : () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => DetalhamentoLinha(
                                                                  researchManager
                                                                          .data
                                                                          .linhaProduto[
                                                                      index],
                                                                  researchManager
                                                                      .data)));
                                                        },
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF796DEA),
                                                        Color(0xFFCC73FF)
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " " +
                                                            researchManager.data
                                                                    .linhaProduto[
                                                                index],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "QuickSand",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection(
                                                                "Empresas")
                                                            .document(researchManager
                                                                .data
                                                                .empresaResponsavel)
                                                            .collection(
                                                                "pesquisasCriadas")
                                                            .document(
                                                                researchManager
                                                                    .data.id)
                                                            .collection(
                                                                "linhasProdutosAntesReposicao")
                                                            .document(
                                                                researchManager
                                                                        .data
                                                                        .linhaProduto[
                                                                    index])
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapTags) {
                                                          if (!snapTags
                                                              .hasData) {
                                                            return LinearProgressIndicator();
                                                          } else {
                                                            TagsLinhaData
                                                                dataTags =
                                                                TagsLinhaData
                                                                    .fromDocument(
                                                                        snapTags
                                                                            .data);
                                                            return Container(
                                                              height: 30,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  8,
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    dataTags
                                                                        .tags
                                                                        .length,
                                                                itemBuilder:
                                                                    (_, index) {
                                                                  return Card(
                                                                    color: dataTags.tags[index] == "Vencimento" ||
                                                                            dataTags.tags[index] ==
                                                                                "Ruptura" ||
                                                                            dataTags.tags[index] ==
                                                                                "Novo Pedido" ||
                                                                            dataTags.tags[index] ==
                                                                                "Nova Pesquisa"
                                                                        ? Color(
                                                                            0xFF4FCEB6)
                                                                        : Colors
                                                                            .red,
                                                                    elevation:
                                                                        4,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        dataTags
                                                                            .tags[index],
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "QuickSand",
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _allProducts({FirebaseUser firebaseUser, String loja}) async {
    FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore
          .collection("Promotores")
          .document(currentUser.uid)
          .get();
      user = User.fromDocument(docUser);

      final QuerySnapshot snapshotProducts = await firestore
          .collection("Empresas")
          .document(user.empresaVinculada)
          .collection("Lojas")
          .document(loja)
          .collection("Produtos")
          .getDocuments();

      allProducts = snapshotProducts.documents
          .map((d) => ProductData.fromDocument(d))
          .toList();

      context.read<UserManager>().allProducts = allProducts;
    }
  }
}
