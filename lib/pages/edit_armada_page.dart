import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/armada_model.dart';
import '../providers/armada_provider.dart';

class EditArmadaPage extends StatefulWidget {
  final Armada armada;
  final int index;

  const EditArmadaPage({super.key, required this.armada, required this.index});

  @override
  State<EditArmadaPage> createState() => _EditArmadaPageState();
}

class _EditArmadaPageState extends State<EditArmadaPage> {
  late TextEditingController nameController;
  late TextEditingController plateController;
  String status = "Active";

  @override
  void initState() {
    nameController = TextEditingController(text: widget.armada.name);
    plateController = TextEditingController(text: widget.armada.plate);
    status = widget.armada.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArmadaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("Edit Armada")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(controller: nameController),
                    const SizedBox(height: 12),
                    TextField(controller: plateController),
                    const SizedBox(height: 20),

                    // STATUS SEGMENTED
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  provider.updateArmada(
                    widget.index,
                    Armada(
                      name: nameController.text,
                      plate: plateController.text,
                      status: status,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Update Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
