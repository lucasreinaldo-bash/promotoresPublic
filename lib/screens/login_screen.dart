import 'package:flutter/material.dart';
import 'package:versaoPromotores/models/user_manager.dart';
import "package:provider/provider.dart";

class LoginScreen extends StatelessWidget {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


@override
Widget build(BuildContext context) {
  double sizeScreenWidth = MediaQuery.of(context).size.width;
  double sizeScreenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
      key: scaffoldKey,
      body: Consumer<UserManager>(
        builder: (_, userManager, child) {
          return Stack(
            children: [
              Container(
                height: sizeScreenHeight * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.0),
                          child: new Padding(
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 30, bottom: 20),
                              child: Image.asset(
                                'assets/logo.png',
                                width: 150,
                                height: 150,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Form(
                              key: formKey,
                              child: ListView(
                                padding: EdgeInsets.all(10),
                                shrinkWrap: true,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    enabled: !userManager.loading,
                                    decoration: const InputDecoration(
                                      hintText: "E-mail",
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.mail,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),
                                    ),
                                    autocorrect: false,
                                    validator: (email) {
                                      if (!emailValid(email))
                                        return "E-mail inválido";
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    enabled: !userManager.loading,
                                    decoration: const InputDecoration(
                                      hintText: "Senha",
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.lock,
                                        size: 22.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    autocorrect: false,
                                    obscureText: true,
                                    validator: (pass) {
                                      if (pass.isEmpty || pass.length < 6)
                                        return "Senha Inválida";
                                      return null;
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("Esqueci minha senha",
                                        style: TextStyle(color: Colors.grey)),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          shrinkWrap: true,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(5),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color:
                                              Theme.Colors.loginGradientStart,
                                          offset: Offset(1.0, 6.0),
                                          blurRadius: 20.0,
                                        ),
                                        BoxShadow(
                                          color: Theme.Colors.loginGradientEnd,
                                          offset: Offset(1.0, 6.0),
                                          blurRadius: 20.0,
                                        ),
                                      ],
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.green.shade500,
                                            Colors.lightBlue
                                          ],
                                          begin:
                                              const FractionalOffset(0.2, 0.2),
                                          end: const FractionalOffset(1.0, 1.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: MaterialButton(
                                      minWidth: 100,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.white,
                                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      child: userManager.loading == true
                                          ? Container(
                                              height: 30,
                                              width: 20,
                                              child: FlareActor(
                                                "assets/fruit_loading.flr",
                                                alignment: Alignment.center,
                                                fit: BoxFit.contain,
                                                animation: "move",
                                              ),
                                            )
                                          : Text(
                                              "Entrar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontFamily: "WorkSansBold"),
                                            ),
                                      onPressed: () {
                                        if (formKey.currentState.validate()) {
                                          context.read<UserManager>().signIn(
                                              user: User(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              ),
                                              onFail: (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("Ops! $e"),
                                                  backgroundColor: Colors.red,
                                                ));
                                              },
                                              onSucess: () {
                                                Navigator.of(context).pop();
                                              });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Container(
                                height: 50,
                                width: 240,
                                child: FlatButton(
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    disabledColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: Colors.transparent,
                                    onPressed: () async {},
                                    child: Image.asset(
                                      'assets/gmail.png',
                                    ))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/signup");
                    },
                    child: RichText(
                      text: TextSpan(
                          text: "Não tem conta? ",
                          style: TextStyle(color: Colors.black54),
                          children: const <TextSpan>[
                            TextSpan(
                                text: "Cadastre-se",
                                style: TextStyle(color: Colors.blue))
                          ]),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ));
}
