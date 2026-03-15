import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/armada_model.dart';
import '../widgets/armada_card.dart';
import 'add_armada_page.dart';
import 'edit_armada_page.dart';
import 'package:provider/provider.dart';
import '../providers/armada_provider.dart';

class ArmadaPage extends StatefulWidget {
  const ArmadaPage({super.key});

  @override
  State<ArmadaPage> createState() => _ArmadaPageState();
}

class _ArmadaPageState extends State<ArmadaPage> {
  final supabase = Supabase.instance.client;

  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    dataFuture = supabase.from('armada').select();
  }

  void confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Armada"),
          content: const Text("Apakah yakin ingin menghapus armada ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus"),
              onPressed: () async {
                await supabase.from('armada').delete().eq('id', id);

                context.read<ArmadaProvider>().loadArmada();

                Navigator.pop(context);

                setState(() {
                  loadData();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Armada berhasil dihapus")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Daftar Armada",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6CDF),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddArmadaPage()),
          );

          setState(() {
            loadData();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada armada",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              final armada = Armada(
                name: item['name'],
                plate: item['plate'],
                status: item['status'],
              );

              return ArmadaCard(
                armada: armada,

                onDelete: () {
                  confirmDelete(context, item['id']);
                },

                onEdit: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditArmadaPage(armada: armada, id: item['id']),
                    ),
                  );

                  setState(() {
                    loadData();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
