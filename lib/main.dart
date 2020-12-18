import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:versaoPromotores/menu_principal/criar_pesquisa.dart';
import 'package:versaoPromotores/menu_principal/datas/pesquisaData.dart';
import 'package:versaoPromotores/menu_principal/detalhamentoPesquisa.dart';
import 'package:versaoPromotores/menu_principal/selecao_perfil.dart';
import 'package:versaoPromotores/models/user_model.dart';
import 'package:versaoPromotores/splash_screen.dart';

import 'Login.dart';
import 'menu_principal/home_menu.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
  return runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new Login(),
          '/splash': (BuildContext context) => new SplashScreen(),
          '/Home': (BuildContext context) => new HomeMenu(),
          '/selecaoPerfil': (BuildContext context) => new SelecaoPerfil(),
        },
        home: SplashScreen(),
        theme: ThemeData(
            primarySwatch: Colors.purple,
            primaryColor: Color.fromARGB(255, 20, 125, 141)),
      ),
    );
  }
}
