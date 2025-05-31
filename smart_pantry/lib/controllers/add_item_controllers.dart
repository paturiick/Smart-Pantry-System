import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:smart_pantry/constants/colors.dart';

class AddItemController {
  final formKey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final weightController = TextEditingController();
  DateTime? expiryDate;
  bool isScanning = false;

  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _scanSubscription;

  void dispose() {
    _scanSubscription?.cancel();
    itemController.dispose();
    weightController.dispose();
  }

  Future<void> startScanAndSave(
    BuildContext context,
    VoidCallback onSuccess,
  ) async {
    if (!formKey.currentState!.validate()) return;

    if (expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date!')),
      );
      return;
    }

    isScanning = true;

    final itemData = {
      'item': itemController.text.trim(),
      'known_weight': double.parse(weightController.text),
      'expiry': DateFormat('MMM dd, yyyy').format(expiryDate!),
    };

    await _db.child('temp_scan').set(itemData);
    await _db.child('scan_trigger').set(true);

    _listenForScan(context, itemData, onSuccess);
  }

  void _listenForScan(
    BuildContext context,
    Map<String, dynamic> itemData,
    VoidCallback onSuccess,
  ) {
    _scanSubscription?.cancel();
    _scanSubscription = _db.child('last_scanned_uid').onValue.listen((
      event,
    ) async {
      final uid = event.snapshot.value?.toString();
      if (uid != null && uid.isNotEmpty) {
        _scanSubscription?.cancel();
        await _db.child('last_scanned_uid').remove();

        if (uid == "ALREADY_USED") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ RFID already linked. Scan a different tag.'),
            ),
          );
          await _db.child('scan_trigger').set(true); // Re-trigger scanning
          _listenForScan(context, itemData, onSuccess);
          return;
        }

        isScanning = false;

        await _db.child('pantry/$uid').set(itemData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Item added to pantry!'),
            backgroundColor: AppColors.Teal,
          ),
        );

        await _db.child('temp_scan').remove(); // Clean up
        onSuccess();
      }
    });
  }

  Future<void> pickDate(
    BuildContext context,
    Function(DateTime) onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      expiryDate = picked;
      onPicked(picked);
    }
  }
}
