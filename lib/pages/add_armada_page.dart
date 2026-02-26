import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String status = "Active";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArmadaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("Tambah Armada")),
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
                  child: buildTextField(
                    "Kapasitas",
                    "0",
                    capacityController,
                    keyboard: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    value: status,
                    decoration: inputDecoration("Status"),
                    items: ["Active", "Maintenance", "Inactive"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  provider.addArmada(
                    Armada(
                      name: nameController.text,
                      plate: plateController.text,
                      status: status,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Simpan Armada"),
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
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
