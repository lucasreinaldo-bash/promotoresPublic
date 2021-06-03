import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/common/components/background_app.dart';
import 'package:versaoPromotores/models/user_manager.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/telas_drawer/perfil_empresa/PerfilPromotor.dart';

import 'package:url_launcher/url_launcher.dart';

import '../Login.dart';
import 'custom_drawer_header.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String uid;
  String photo;
  _CustomDrawerState();

  final GlobalKey drawer = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(uid);
    return Drawer(
        key: drawer,
        child: Stack(
          children: <Widget>[
            BackgroundApp(),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                CustomDrawerHeader(),
                Divider(),
                _createDrawerItem(
                    icon: Icons.business,
                    text: 'Perfil do Promotor',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PerfilPromotor()));
                    }),
                _createDrawerItem(
                  icon: Icons.library_books,
                  text: 'Instruções de Reposição',
                ),
//                    _createDrawerItem(
//                      icon: Icons.picture_as_pdf,
//                      text: 'Pesquisas',
//                    ),
//                    _createDrawerItem(
//                      icon: Icons.pie_chart,
//                      text: 'Relatórios',
//                    ),
                _createDrawerItem(
                    onTap: () {
                      _desconectar(context);
                    },
                    icon: Icons.exit_to_app,
                    text: 'Desconectar'),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      width: 10,
                    ),
                    Container(
                      color: Colors.black38,
                      width: 10,
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }

  Widget _createHeader() {
    Consumer<UserManager>(
      builder: (_, userManager, __) {
        return Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              Center(
                  child: Card(
                elevation: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.white30)),
                child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                              userManager.user.imagem != null
                                  ? userManager.user.imagem
                                  : ""),
                        ))),
              )),
              Text(
               userManager.user.nomePromotor,
                style: TextStyle(fontFamily: "QuickSand"),
              ),
              Text(
                userManager.user.email,
                style:
                    TextStyle(color: Colors.black54, fontFamily: "QuickSand"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Empresa vinculada: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "QuickSand",
                        fontSize: 10),
                  ),
                 
                ],
              )
            ],
          ),
        );
        
      },
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white,),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text, style: TextStyle(color: Colors.white))
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

void desconectar() {
  FirebaseAuth auth;
  auth.signOut();
}

Future<Login> _desconectar(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.pop(context);
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  return Login();
}

drawerComImagem() async {}

void signOut() {}
