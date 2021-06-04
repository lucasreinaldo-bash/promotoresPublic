import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../menu_principal/datas/pesquisaData.dart';
import '../menu_principal/datas/pesquisaData.dart';
import '../menu_principal/datas/pesquisaData.dart';

class ResearchManager extends ChangeNotifier {
  PesquisaData data;
  ResearchManager({this.data});

  
  String _titleScreen = "";
  set titleScreen(String title) {
    titleScreen = title;
    notifyListeners();
  }

  get titleScreen => _titleScreen;

  void setResearch(PesquisaData data) {
    this.data = data;
    notifyListeners();
  }
}
