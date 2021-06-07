import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_five.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_four.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_one.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_three.dart';
import 'package:versaoPromotores/menu_principal/screens/research_screen_two.dart';
import 'package:versaoPromotores/models/page_manager.dart';
import 'package:versaoPromotores/models/research_manager.dart';
import 'package:versaoPromotores/splash_screen_pesquisaRespondida.dart';

class BaseScreenResearch extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageManager(pageController),
      child: PageView(
        allowImplicitScrolling: false,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          ResearchScreenOne(),
          ResearchScreenTwo(),
          ResearchScreenThree(),
          ResearchScreenFour(),
          ResearchScreenFive(),
          SplashScreenPesquisaRespondida()
        ],
      ),
    );
  }
}
