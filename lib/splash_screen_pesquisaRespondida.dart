import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:versaoPromotores/styles/style.dart';
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


  openStartPage() async {
    await Future.delayed(Duration(seconds: 3), () => _loadCurrentUser());
  }

  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                    ),
                    Text(
                      'Pesquisa Respondida',
                      textAlign: TextAlign.center,
                      style: kTitleStyle,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      child: Center(
                          child: FlareActor("assets/success_check.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "Untitled")),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<Null> _loadCurrentUser() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeMenu("Todas", "termosBuscaLoja")));
  }
}
