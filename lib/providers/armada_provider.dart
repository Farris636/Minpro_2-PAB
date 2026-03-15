import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/armada_model.dart';

class ArmadaProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List armadaList = [];

  ArmadaProvider() {
    loadArmada();
    listenRealtime();
  }

  Future loadArmada() async {
    final data = await supabase.from('armada').select();

    armadaList = data;

    notifyListeners();
  }

  void addArmada(Armada armada) {
    armadaList.add({
      "name": armada.name,
      "plate": armada.plate,
      "status": armada.status,
    });

    notifyListeners();
  }

  void listenRealtime() {
    supabase
        .channel('armada_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'armada',
          callback: (payload) {
            loadArmada();
          },
        )
        .subscribe();
  }

  int get totalFleet => armadaList.length;

  int get activeCount =>
      armadaList.where((e) => e['status'] == "Active").length;

  int get maintenanceCount =>
      armadaList.where((e) => e['status'] == "Maintenance").length;

  int get inactiveCount =>
      armadaList.where((e) => e['status'] == "Inactive").length;
}
