import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/armada_model.dart';
import 'package:provider/provider.dart';
import '../providers/armada_provider.dart';

class EditArmadaPage extends StatefulWidget {
  final Armada armada;
  final int id;

  const EditArmadaPage({super.key, required this.armada, required this.id});

  @override
  State<EditArmadaPage> createState() => _EditArmadaPageState();
}

class _EditArmadaPageState extends State<EditArmadaPage> {
  final supabase = Supabase.instance.client;

  late TextEditingController nameController;
  late TextEditingController plateController;

  String status = "Active";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.armada.name);
    plateController = TextEditingController(text: widget.armada.plate);
    status = widget.armada.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Armada",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: plateController,
                      decoration: const InputDecoration(
                        labelText: "Nomor Plat",
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["Active", "Maintenance", "Inactive"]
                          .map(
                            (e) => Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = e;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),

                                  decoration: BoxDecoration(
                                    color: status == e
                                        ? Colors.blue
                                        : Colors.grey.shade200,

                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Center(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: status == e
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

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
                icon: const Icon(
                  Icons.save,
                  color: Colors.white, // PERUBAHAN
                ),
                label: const Text(
                  "Update Data",
                  style: TextStyle(color: Colors.white), // PERUBAHAN
                ),

                onPressed: () async {
                  final provider = context.read<ArmadaProvider>();
                  try {
                    await supabase
                        .from('armada')
                        .update({
                          'name': nameController.text,
                          'plate': plateController.text,
                          'status': status,
                        })
                        .eq('id', widget.id);

                    await provider.loadArmada();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data berhasil diupdate")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal update data: $e")),
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
}
