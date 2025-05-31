import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/controllers/add_item_controllers.dart';
import 'package:smart_pantry/routes/routes.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final AddItemController _controller = AddItemController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: AppColors.Teal, fontWeight: FontWeight.bold),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.Teal, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Aqua,
      appBar: AppBar(
        title: const Text(
          'Add Pantry Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.Teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _controller.itemController,
                      decoration: _inputDecoration('Item Name'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter item name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _controller.weightController,
                      decoration: _inputDecoration('Weight (g)'),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter weight';
                        final value = double.tryParse(val);
                        return (value == null || value <= 0)
                            ? 'Enter valid weight'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _controller.expiryDate == null
                                ? 'No expiry date selected'
                                : 'Expiry: ${DateFormat('MMM dd, yyyy').format(_controller.expiryDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.pickDate(context, (picked) {
                              setState(() {}); // update display
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.Teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _controller.isScanning
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.rss_feed),
                        label: const Text('Scan RFID & Save'),
                        onPressed: () async {
                          await _controller.startScanAndSave(context, () {
                            if (context.mounted) {
                              Navigator.pushNamed(context, AppRoutes.HOMEPAGE);
                            }
                          });
                          setState(() {}); // update isScanning
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.Teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
