import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  PageManager(this._pageController);
  final PageController _pageController;

  int page = 0;

  void nextPage() {
    

    _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInSine);
   
  }
  void previusPage() {
    

    _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInSine);
   
  }
}
