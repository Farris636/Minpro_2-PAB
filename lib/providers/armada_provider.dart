import 'package:flutter/material.dart';
import '../models/armada_model.dart';

class ArmadaProvider extends ChangeNotifier {
  final List<Armada> _armadaList = [
    Armada(name: "Mercedes OH 1626", plate: "B 1234 TGC", status: "Active"),
    Armada(name: "Scania K410IB", plate: "D 9982 CF", status: "Maintenance"),
    Armada(name: "Volvo B11R", plate: "L 4412 OP", status: "Active"),
  ];

  List<Armada> get armadaList => _armadaList;

  void addArmada(Armada armada) {
    _armadaList.add(armada);
    notifyListeners();
  }

  void updateArmada(int index, Armada armada) {
    _armadaList[index] = armada;
    notifyListeners();
  }

  void deleteArmada(int index) {
    _armadaList.removeAt(index);
    notifyListeners();
  }

  int get totalFleet => _armadaList.length;

  int get activeCount => _armadaList.where((e) => e.status == "Active").length;

  int get maintenanceCount =>
      _armadaList.where((e) => e.status == "Maintenance").length;

  int get inactiveCount =>
      _armadaList.where((e) => e.status == "Inactive").length;
}
