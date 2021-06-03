//import 'dart:io';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
////import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:scoped_model/scoped_model.dart';
//
//class UserModel extends Model {
//  FirebaseAuth _auth = FirebaseAuth.instance;
//  FirebaseUser firebaseUser;
//
//  Map<String, dynamic> userData = Map();
//
//  bool isLoading = false;
//
//  String perfilUsuario, idPromotor;
//
//  String result = "não";
//
//  void setResult(String texto) {
//    this.result = texto;
//  }
//
//  String getResult() {
//    return result;
//  }
//
//  static UserModel of(BuildContext context) =>
//      ScopedModel.of<UserModel>(context);
//
//  @override
//  void addListener(listener) {
//    // ignore: todo
//    // TODO: implement addListener
//    super.addListener(listener);
//    _loadCurrentUser();
//  }
//
//  DocumentReference get firestoreRef =>
//      Firestore.instance.document('Promotores/');
//
//  CollectionReference get cartReference => firestoreRef.collection('cart');
//
//  CollectionReference get tokensReference => firestoreRef.collection('tokens');
//
//  void signOut() async {
//    await _auth.signOut();
//
//    userData = Map();
//    firebaseUser = null;
//
//    notifyListeners();
//  }
//
//  //Informar se o perfil que o usuario esta utilizando é de Promotor ou Empresa
//
//  String getUid() {
//    return idPromotor;
//  }
//
//  void setTipoPerfil(String perfil) {
//    this.perfilUsuario = perfil;
//  }
//
//  void setUid(String id) {
//    this.idPromotor = id;
//  }
//
//  void signIn(
//      {@required String email,
//      @required String pass,
//      @required VoidCallback onSucess,
//      @required VoidCallback onFail}) async {
//    isLoading = true;
//    notifyListeners();
//
//    _auth
//        .signInWithEmailAndPassword(email: email, password: pass)
//        .then((user) async {
//      await _loadCurrentUser();
//
//      onSucess();
//      isLoading = false;
//      notifyListeners();
//    }).catchError((e) {
//      onFail();
//      isLoading = false;
//      notifyListeners();
//    });
//  }
//
//  void refresh({@required VoidCallback onSucess}) async {
//    isLoading = true;
//    notifyListeners();
//    await _loadCurrentUser();
//    onSucess();
//    isLoading = false;
//    notifyListeners();
//  }
//
//  bool isLoggedIn() {
//    return firebaseUser != null;
//  }
//
//  Future<Null> _loadCurrentUser() async {
//    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
//    if (firebaseUser != null) if (userData["nome"] == null) {
//      DocumentSnapshot docUser = await Firestore.instance
//          .collection("Promotores")
//          .document(firebaseUser.uid)
//          .get();
//      userData = docUser.data;
//    }
//    notifyListeners();
//  }
//}
