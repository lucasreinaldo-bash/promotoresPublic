import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versaoPromotores/models/build_indicator_before.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuildIndicatorBefore(pageController),
      child: PageView(
        controller: pageController,
        children: [
          

          
          ],
      ),
    );
  }
}