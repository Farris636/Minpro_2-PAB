import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/armada_provider.dart';
import '../models/armada_model.dart';

class AddArmadaPage extends StatefulWidget {
  const AddArmadaPage({super.key});

  @override
  State<AddArmadaPage> createState() => _AddArmadaPageState();
}

class _AddArmadaPageState extends State<AddArmadaPage> {
  final nameController = TextEditingController();
  final plateController = TextEditingController();
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final notesController = TextEditingController();

  final supabase = Supabase.instance.client;

  String status = "Active";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArmadaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField("Nama Bus", "Contoh: Bus 01", nameController),

            buildTextField("Nomor Plat", "Contoh: B 1234 XYZ", plateController),

            buildTextField(
              "Model / Tipe",
              "Contoh: Mercedes OH 1626",
              modelController,
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: TextField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration("Kapasitas", "0"),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: DropdownButtonFormField<String>(
                      value: status,
                      decoration: inputDecoration("Status"),
                      items: ["Active", "Maintenance", "Inactive"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            buildTextField(
              "Catatan Tambahan (Opsional)",
              "Informasi tambahan mengenai armada...",
              notesController,
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6CDF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Simpan Armada",
                  style: TextStyle(color: Colors.white),
                ),

                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      plateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Nama bus dan nomor plat wajib diisi"),
                      ),
                    );
                    return;
                  }

                  try {
                    await supabase.from('armada').insert({
                      'name': nameController.text,
                      'plate': plateController.text,
                      'status': status,
                    });

                    provider.addArmada(
                      Armada(
                        name: nameController.text,
                        plate: plateController.text,
                        status: status,
                      ),
                    );

                    await provider.loadArmada();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Armada berhasil ditambahkan"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menambahkan armada: $e")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: inputDecoration(label, hint),
      ),
    );
  }

  InputDecoration inputDecoration(String label, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
