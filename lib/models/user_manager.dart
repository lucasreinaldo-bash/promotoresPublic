import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:versaoPromotores/helpers/firebase_errors.dart';
import 'package:versaoPromotores/menu_principal/datas/ProdutoData.dart';
import 'package:versaoPromotores/menu_principal/datas/instrucaoData.dart';
import 'package:versaoPromotores/models/user.dart';

import '../menu_principal/datas/pesquisaData.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadingCurrentUser();
  }
//Carregando Pesquisas
  List<PesquisaData> allResearchs = [];

  //Carregando Instrucoes
  List<InstrucaoData> _allInstructions = [];
  List<InstrucaoData> get allInstructions => _allInstructions;
  //Carregando Produtos
  List<ProductData> _allProducts = [];
  List<ProductData> get allProducts => _allProducts;

  set allProducts(List<ProductData> data) {
    _allProducts = data;
    print(_allProducts[2].nomeProduto + "Deus no comando , hoje e sempre!");
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  //Tela de Cadastro
  bool _obscureTextSignup = true;
  bool get obscureTextSignup => _obscureTextSignup;

  Future<void> signIn({User user, Function onFail, onSucess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.senha);

      await _loadingCurrentUser(firebaseUser: result.user);
      onSucess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  obscureTextSignupChange(bool value) {
    _obscureTextSignup = value;
    notifyListeners();
  }

  Future<void> _loadingCurrentUser({FirebaseUser firebaseUser}) async {
    FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore
          .collection("Promotores")
          .document(currentUser.uid)
          .get();
      user = User.fromDocument(docUser);

      final QuerySnapshot snapshotProducts = await firestore
          .collection("Empresas")
          .document(user.empresaVinculada)
          .collection("pesquisasCriadas")
          .where("idPromotor", isEqualTo: currentUser.uid)
          .getDocuments();

      allResearchs = snapshotProducts.documents
          .map((d) => PesquisaData.fromDocument(d))
          .toList();

      final QuerySnapshot instrucaoReposicao = await firestore
          .collection("Empresas")
          .document(user.empresaVinculada)
          .collection("instrucoes")
          .getDocuments();

      _allInstructions = instrucaoReposicao.documents
          .map((d) => InstrucaoData.fromDocument(d))
          .toList();
      notifyListeners();
    }
  }

  Future<void> signUp({User user, Function onFail, Function onSucess}) async {
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.senha);

      user.id = result.user.uid;
      this.user = user;
      await user.savedData();

      onSucess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }
}
