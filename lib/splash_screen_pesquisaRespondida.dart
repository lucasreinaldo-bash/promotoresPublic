import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:versaoPromotores/style/style.dart';

import 'menu_principal/home_menu.dart';

class SplashScreenPesquisaRespondida extends StatefulWidget {
  @override
  _SplashScreenPesquisaRespondidaState createState() =>
      _SplashScreenPesquisaRespondidaState();
}

class _SplashScreenPesquisaRespondidaState
    extends State<SplashScreenPesquisaRespondida> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//    configFCM();
    openStartPage();
  }

//  void configFCM() {
//    final fcm = FirebaseMessaging();
//
//    if (Platform.isIOS) {
//      fcm.requestNotificationPermissions(
//          const IosNotificationSettings(provisional: true));
//    }
//
//    fcm.configure(
//      onLaunch: (Map<String, dynamic> message) async {
//        print('onLaunch $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('onResume $message');
//      },
//      onMessage: (Map<String, dynamic> message) async {
//        showNotification(
//          message['notification']['title'] as String,
//          message['notification']['body'] as String,
//        );
//      },
//    );
//  }

  void showNotification(String title, String message) {
    Flushbar(
            title: title,
            message: message,
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            isDismissible: true,
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 3),
            icon: Image.asset("assets/ic_launcher.png"))
        .show(context);
  }

  openStartPage() async {
    await Future.delayed(Duration(seconds: 3), () => _loadCurrentUser());
  }

  String id;

  DocumentReference get firestoreRef =>
      Firestore.instance.document('ConsumidorFinal/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Container(
//            decoration: new BoxDecoration(
//              image: new DecorationImage(
//                image: new AssetImage("assets/fundocatalao.png"),
//                fit: BoxFit.cover,
//              ),
//            ),
//            child: null /* add child content content here */,
//          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 100),
              child: Card(
                elevation: 15,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//
                      SizedBox(height: 60.0),
                      Text(
                        'Pesquisa Respondida',
                        textAlign: TextAlign.center,
                        style: kTitleStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                              child: FlareActor("assets/success_check.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "Untitled")),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _loadCurrentUser() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeMenu("Todas", "termosBuscaLoja")));
  }
}
