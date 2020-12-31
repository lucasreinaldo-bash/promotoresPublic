import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:versaoPromotores/menu_principal/criar_pesquisa.dart';

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
                              height: 400,
                              width: 400,
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 200,
                              width: 400,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),

                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Card(
                                                  color: Color(0xFFFFFFFF),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection(
                                                                "Empresas")
                                                            .document(data
                                                                .empresaResponsavel)
                                                            .collection(
                                                                "pesquisasCriadas")
                                                            .document(data.id)
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
                                                            return Image
                                                                .network(
                                                              snapImg1.data[
                                                                  "imagem"],
                                                              fit: BoxFit.cover,
                                                            );
                                                          }
                                                        },
                                                      )),
                                                ),
                                              ),
                                              Text(
                                                "Foto da Aréa de venda\n(antes da reposição)",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "QuickSandRegular",
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
          );
  }
}
