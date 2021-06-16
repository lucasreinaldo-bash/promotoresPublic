import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/screens/login_screen.dart';
import 'package:versaoPromotores/splash_screen.dart';
import 'fcm/config_fcm.dart';
import 'menu_principal/detalhamentoPesquisa.dart';
import 'menu_principal/home_menu.dart';
import 'models/page_manager.dart';
import 'models/user_manager.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
  return runApp(Home());
}

class Home extends StatelessWidget {
  PageController pageController;
  @override
  Widget build(BuildContext context) {
    configFCM(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ResearchManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => PageManager(pageController),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
   
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/login":
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case "/splash":
              return MaterialPageRoute(builder: (_) => SplashScreen());
            case "/detalhamentoPesquisa":
              return MaterialPageRoute(builder: (_) => DetalhamentoPesquisa());
            case "/home":
              return MaterialPageRoute(
                  builder: (_) => HomeMenu("Todas", "termosBuscaLoja"));
          }
        },
//      routes: <String, WidgetBuilder>{
//        '/login': (BuildContext context) => new Login(),
//        '/splash': (BuildContext context) => new SplashScreen(),
//        '/Home': (BuildContext conteqxt) =>
//        new HomeMenu("Todas", "termosBuscaLoja"),
//        '/selecaoPerfil': (BuildContext context) => new SelecaoPerfil(),
//      },
        initialRoute: "/splash",
        theme: ThemeData(
            primarySwatch: Colors.purple,
            primaryColor: Color.fromARGB(255, 20, 125, 141)),
      ),
    );
  }
}
