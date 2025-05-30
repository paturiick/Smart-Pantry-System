import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/routes/routes.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _expiryDate;

  bool _isScanning = false;
  final _db = FirebaseDatabase.instance.ref();

  Future<void> _startScanAndSave() async {
    if (!_formKey.currentState!.validate() || _expiryDate == null) return;

    setState(() => _isScanning = true);

    final itemData = {
      'item': _itemController.text.trim(),
      'known_weight': double.parse(_weightController.text),
      'expiry': DateFormat('MMM dd, yyyy').format(_expiryDate!),
    };

    await _db.child('pantry').update(itemData);
    await _db.child('scan_trigger').set(true);

    _db.child('last_scanned_uid').onValue.listen((event) async {
      final uid = event.snapshot.value?.toString();
      if (uid != null && uid.isNotEmpty) {
        final snapshot = await _db.child('pantry/$uid').get();
        final savedData = snapshot.value as Map?;

        await _db.child('last_scanned_uid').remove();
        setState(() => _isScanning = false);

        if (savedData != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('✅ Item Saved'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📌 RFID: $uid"),
                  Text("🛒 Item: ${savedData['item']}"),
                  Text("⚖️ Weight: ${savedData['known_weight']} g"),
                  Text("📅 Expiry: ${savedData['expiry']}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.HOMEPAGE),
                  child: Text('OK', style: TextStyle(color: AppColors.Teal)),
                )
              ],
            ),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item saved and loaded from RFID: $uid'),
            backgroundColor: AppColors.Teal,
          ),
        );
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _expiryDate = picked);
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
          'Add Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.Teal,
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _itemController,
                      decoration: _inputDecoration('Item Name'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter item name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
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
                            _expiryDate == null
                                ? 'No expiry date selected'
                                : 'Expiry: ${DateFormat('MMM dd, yyyy').format(_expiryDate!)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickDate,
                          child: const Text('Pick Date'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.Teal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _isScanning
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.rss_feed),
                        label: const Text('Scan RFID & Save'),
                        onPressed: _startScanAndSave,
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