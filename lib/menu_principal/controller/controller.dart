import 'package:mobx/mobx.dart';
part 'controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  @observable
  int counter = 0;

  @observable
  String nomeLoja = "";

  @action
  NomeLoja(String nome) {
    nomeLoja = nome;
  }

  @computed
  String get NomeCompleto => nomeLoja;
  @action
  increment() {
    counter++;
  }
}
