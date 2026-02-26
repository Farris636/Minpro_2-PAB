import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/armada_provider.dart';
import '../widgets/armada_card.dart';
import 'add_armada_page.dart';
import 'edit_armada_page.dart';

class ArmadaPage extends StatelessWidget {
  const ArmadaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArmadaProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Daftar Armada",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6CDF),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddArmadaPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: provider.armadaList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada armada",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: provider.armadaList.length,
              itemBuilder: (context, index) {
                final armada = provider.armadaList[index];

                return ArmadaCard(
                  armada: armada,
                  onDelete: () {
                    provider.deleteArmada(index);
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditArmadaPage(armada: armada, index: index),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
