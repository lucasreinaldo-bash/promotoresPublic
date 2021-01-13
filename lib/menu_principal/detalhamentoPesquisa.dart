import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:versaoPromotores/menu_principal/datas/pontoExtraImagemData.dart';
import 'package:versaoPromotores/menu_principal/responder_pesquisa.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData_ruptura_validade.dart';
import 'package:versaoPromotores/menu_principal/datas/estoqueDeposito_data.dart';
import 'package:versaoPromotores/menu_principal/screens/exibirImagem.dart';

import 'datas/pesquisaData.dart';

class DetalhamentoPesquisa extends StatefulWidget {
  PesquisaData data;

  DetalhamentoPesquisa(this.data);
  @override
  _DetalhamentoPesquisaState createState() =>
      _DetalhamentoPesquisaState(this.data);
}

class _DetalhamentoPesquisaState extends State<DetalhamentoPesquisa> {
  PesquisaData data;

  Color colorButtonVoltar = Color(0xFFF26868);
  Color colorButtonIniciarPesquisa = Color(0xFF4FCEB6);

  _DetalhamentoPesquisaState(this.data);

  @override
  Widget build(BuildContext context) {
    return data.status == "ABERTA"
        ? Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image:
                          new AssetImage("assets/background_detalhamento.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content content here */,
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Text(
                        "Detalhes",
                        style: TextStyle(
                            fontFamily: "QuickSandRegular",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nome da Loja:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.nomeLoja,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nome da Rede: ",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.nomeRede,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text(
//                                    "Endereco:",
//                                    style: TextStyle(
//                                        fontFamily: "QuickSand",
//                                        color: Colors.black87),
//                                  ),
//                                  Text(
//                                    data.enderecoLoja,
//                                    style: TextStyle(
//                                        fontFamily: "QuickSand",
//                                        color: Colors.black38),
//                                  ),
//                                ],
//                              ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.status,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Linha de Produtos:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.linhaProduto
                                              .toString()
                                              .replaceAll("[", "")
                                              .replaceAll("]", ""),
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data Agendada:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.dataInicial,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),

                                    //Falta modificar a data de conclusão
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: data.status == "ABERTA"
                              ? () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ResponderPesquisaData(data)));
                                }
                              : null,
                          color: Color(0xFF4FCEB6),
                          textColor: Colors.white,
                          child: Text("Iniciar Pesquisa",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "QuickSandRegular")),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xFFF26868),
                          textColor: Colors.white,
                          child: Text("Voltar",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "QuickSandRegular")),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      "Pesquisa ${data.status.toString()[0].toUpperCase() + data.status.toString().substring(1).toLowerCase()}",
                      style: TextStyle(fontFamily: "QuickSandRegular"),
                    ),
                    Text(
                      "(detalhamento)",
                      style: TextStyle(
                          fontFamily: "QuickSandRegular", fontSize: 12),
                    ),
                  ],
                )),
            body: Stack(
              children: [
                Container(
                  color: Color(0xFFEAECF5),
                  child: null /* add child content content here */,
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 200,
                              width: 400,
                              child: Padding(
                                padding: EdgeInsets.all(1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Fotos Capturadas",
                                      style: TextStyle(
                                          fontFamily: "QuickSand",
                                          fontSize: 15),
                                    ),
                                    Divider(),

                                    SingleChildScrollView(
                                      child: Column(children: <Widget>[
                                        SizedBox(
                                            height: 150.0,
                                            width: 350.0,
                                            child: Carousel(
                                              images: [
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Card(
                                                        elevation: 10,
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              child:
                                                                  StreamBuilder(
                                                                stream: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "Empresas")
                                                                    .document(data
                                                                        .empresaResponsavel)
                                                                    .collection(
                                                                        "pesquisasCriadas")
                                                                    .document(
                                                                        data.id)
                                                                    .collection(
                                                                        "BeforeAreaDeVenda")
                                                                    .document(
                                                                        "fotoAntesReposicao")
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapImg1) {
                                                                  if (!snapImg1
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  } else {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) => ExibirImagem(
                                                                                snapImg1.data["imagem"],
                                                                                "1",
                                                                                "1")));
                                                                      },
                                                                      child: Image
                                                                          .network(
                                                                        snapImg1
                                                                            .data["imagem"],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Aréa de Venda\n(antes da reposição)",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular",
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Card(
                                                        elevation: 10,
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Container(
                                                              height: 100,
                                                              width: 100,
                                                              child:
                                                                  StreamBuilder(
                                                                stream: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "Empresas")
                                                                    .document(data
                                                                        .empresaResponsavel)
                                                                    .collection(
                                                                        "pesquisasCriadas")
                                                                    .document(
                                                                        data.id)
                                                                    .collection(
                                                                        "AfterAreaDeVenda")
                                                                    .document(
                                                                        "fotoDepoisReposicao")
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapImg1) {
                                                                  if (!snapImg1
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  } else {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (context) => ExibirImagem(
                                                                                snapImg1.data["imagem"],
                                                                                "1",
                                                                                "1")));
                                                                      },
                                                                      child: Image
                                                                          .network(
                                                                        snapImg1
                                                                            .data["imagem"],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Aréa de Venda\n(após a reposição)",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "QuickSandRegular",
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                FutureBuilder(
                                                  future: Firestore.instance
                                                      .collection("Empresas")
                                                      .document(data
                                                          .empresaResponsavel)
                                                      .collection(
                                                          "pesquisasCriadas")
                                                      .document(data.id)
                                                      .collection("pontoExtra")
                                                      .getDocuments(),
                                                  builder: (context,
                                                      snapPontoExtra) {
                                                    if (!snapPontoExtra
                                                        .hasData) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              snapPontoExtra
                                                                  .data
                                                                  .documents
                                                                  .length,
                                                          itemBuilder: (_,
                                                              indexProduto) {
                                                            PontoExtraData
                                                                pontoExtraData =
                                                                PontoExtraData.fromDocument(
                                                                    snapPontoExtra
                                                                            .data
                                                                            .documents[
                                                                        indexProduto]);

                                                            return pontoExtraData
                                                                        .existe ==
                                                                    false
                                                                ? Container()
                                                                : Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExibirImagem(pontoExtraData.imagemAntes, "2", "${pontoExtraData.id} " + "\n(antes da reposição)")));
                                                                            },
                                                                            child:
                                                                                Card(
                                                                              elevation: 10,
                                                                              color: Color(0xFFFFFFFF),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Container(
                                                                                  height: 100,
                                                                                  width: 100,
                                                                                  child: Image.network(
                                                                                    pontoExtraData.imagemAntes,
                                                                                    fit: BoxFit.fill,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExibirImagem(pontoExtraData.imagemAntes, "2", "${pontoExtraData.id} " + "\n(depois da reposição)")));
                                                                            },
                                                                            child:
                                                                                Card(
                                                                              elevation: 10,
                                                                              color: Color(0xFFFFFFFF),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Container(
                                                                                  height: 100,
                                                                                  width: 100,
                                                                                  child: Image.network(
                                                                                    pontoExtraData.imagemDepois,
                                                                                    fit: BoxFit.fill,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                30,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        "Ponto Extra ${pontoExtraData.id}\n " +
                                                                            "(imagem antes e depois)",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "QuickSandRegular",
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ],
                                                                  );
                                                          });
                                                      ;
                                                    }
                                                  },
                                                ),
                                              ],
                                              dotSize: 4.0,
                                              dotSpacing: 15.0,
                                              animationDuration:
                                                  Duration(seconds: 2),
                                              showIndicator: false,
                                              dotColor: Colors.white,
                                              indicatorBgPadding: 5.0,
                                              dotBgColor: Colors.deepPurple
                                                  .withOpacity(0.5),
                                              borderRadius: true,

//                                              moveIndicatorFromBottom: 180.0,
//                                              noRadiusForIndicator: true,
                                            ))
                                      ]),
                                    ),

                                    //Falta modificar a data de conclusão
                                  ],
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 400,
                              width: 400,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Detalhes",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "QuickSand",
                                          color: Colors.black87),
                                    ),
                                    Divider(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nome da Loja:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.nomeLoja,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nome da Rede: ",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.nomeRede,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text(
//                                    "Endereco:",
//                                    style: TextStyle(
//                                        fontFamily: "QuickSand",
//                                        color: Colors.black87),
//                                  ),
//                                  Text(
//                                    data.enderecoLoja,
//                                    style: TextStyle(
//                                        fontFamily: "QuickSand",
//                                        color: Colors.black38),
//                                  ),
//                                ],
//                              ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.status,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Linha de Produtos Pesquisadas:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.linhaProduto
                                              .toString()
                                              .replaceAll("[", "")
                                              .replaceAll("]", ""),
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data Agendada:",
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          data.dataInicial,
                                          style: TextStyle(
                                              fontFamily: "QuickSand",
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),

                                    //Falta modificar a data de conclusão
                                  ],
                                ),
                              ),
                            )),
                      ),
                      FutureBuilder(
                        future: Firestore.instance
                            .collection("Empresas")
                            .document(data.empresaResponsavel)
                            .collection("pesquisasCriadas")
                            .document(data.id)
                            .collection("antesReposicao")
                            .getDocuments(),
                        builder: (context, snapDetalhes) {
                          if (!snapDetalhes.hasData) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Vencimentos Próximos",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "QuickSand",
                                                    color: Colors.black87),
                                              ),
                                              Divider(),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapDetalhes
                                                      .data.documents.length,
                                                  itemBuilder: (_, index) {
                                                    ProductDataRupturaValidade
                                                        data =
                                                        ProductDataRupturaValidade
                                                            .fromDocument(
                                                                snapDetalhes
                                                                        .data
                                                                        .documents[
                                                                    index]);

                                                    if (data.validade !=
                                                        "00/00/0000") {
                                                      return ListTile(
                                                        title: Text(
                                                          data.produto,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "QuickSandRegular"),
                                                        ),
                                                        trailing: Text(
                                                            data.validade,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSandRegular")),
                                                      );
                                                    }
                                                  })

                                              //Falta modificar a data de conclusão
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Em Ruptura",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "QuickSand",
                                                    color: Colors.black87),
                                              ),
                                              Divider(),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapDetalhes
                                                      .data.documents.length,
                                                  itemBuilder: (_, index) {
                                                    ProductDataRupturaValidade
                                                        data =
                                                        ProductDataRupturaValidade
                                                            .fromDocument(
                                                                snapDetalhes
                                                                        .data
                                                                        .documents[
                                                                    index]);

                                                    if (data.ruptura != 0) {
                                                      return ListTile(
                                                        title: Text(
                                                          data.produto,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "QuickSandRegular"),
                                                        ),
                                                        trailing: Text(
                                                            data.ruptura
                                                                    .toString() +
                                                                " UN",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "QuickSandRegular")),
                                                      );
                                                    }
                                                  })

                                              //Falta modificar a data de conclusão
                                            ],
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: Firestore.instance
                            .collection("Empresas")
                            .document(data.empresaResponsavel)
                            .collection("pesquisasCriadas")
                            .document(data.id)
                            .collection("estoqueDeposito")
                            .getDocuments(),
                        builder: (context, snapDetalhes) {
                          if (!snapDetalhes.hasData) {
                            return Container();
                          } else {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Estoques antes da reposição",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "QuickSand",
                                                    color: Colors.black87),
                                              ),
                                              Divider(),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapDetalhes
                                                      .data.documents.length,
                                                  itemBuilder: (_, index) {
                                                    estoqueDepositoData data =
                                                        estoqueDepositoData
                                                            .fromDocument(
                                                                snapDetalhes
                                                                        .data
                                                                        .documents[
                                                                    index]);

                                                    return ListTile(
                                                      title: Text(
                                                        data.produto,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "QuickSandRegular"),
                                                      ),
                                                      trailing: Text(
                                                          data.antesReposicao
                                                                  .toString() +
                                                              " UN",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "QuickSandRegular")),
                                                    );
                                                  })

                                              //Falta modificar a data de conclusão
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Estoques após reposição",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "QuickSand",
                                                    color: Colors.black87),
                                              ),
                                              Divider(),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapDetalhes
                                                      .data.documents.length,
                                                  itemBuilder: (_, index) {
                                                    estoqueDepositoData data =
                                                        estoqueDepositoData
                                                            .fromDocument(
                                                                snapDetalhes
                                                                        .data
                                                                        .documents[
                                                                    index]);

                                                    return ListTile(
                                                      title: Text(
                                                        data.produto,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "QuickSandRegular"),
                                                      ),
                                                      trailing: Text(
                                                          data.aposReposicao
                                                                  .toString() +
                                                              " UN",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "QuickSandRegular")),
                                                    );
                                                  })

                                              //Falta modificar a data de conclusão
                                            ],
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            );
                          }
                        },
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: data.status == "ABERTA"
                              ? () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ResponderPesquisaData(data)));
                                }
                              : null,
                          color: Color(0xFF4FCEB6),
                          textColor: Colors.white,
                          child: Text("Iniciar Pesquisa",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "QuickSandRegular")),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xFFF26868),
                          textColor: Colors.white,
                          child: Text("Voltar",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "QuickSandRegular")),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
  }
}
