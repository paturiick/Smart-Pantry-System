import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:smart_pantry/constants/colors.dart';

class RfidAddItemHandler {
  final GlobalKey<FormState> formKey;
  final TextEditingController itemController;
  final TextEditingController weightController;
  final DateTime? expiryDate;
  final Function(bool) setLoading;
  final BuildContext context;

  StreamSubscription<DatabaseEvent>? _scanListener;
  final _db = FirebaseDatabase.instance.ref();

  RfidAddItemHandler({
    required this.formKey,
    required this.itemController,
    required this.weightController,
    required this.expiryDate,
    required this.setLoading,
    required this.context, required Null Function() onSavedCallback,
  });

  Future<void> startScanAndSave() async {
    if (!formKey.currentState!.validate() || expiryDate == null) return;

    setLoading(true);

    await _db.child('scan_trigger').set(true);

    _scanListener?.cancel();
    _scanListener = _db.child('last_scanned_uid').onValue.listen((event) async {
      final uid = event.snapshot.value?.toString();
      if (uid != null && uid.isNotEmpty) {
        final itemData = {
          'item': itemController.text.trim(),
          'known_weight': double.parse(weightController.text),
          'expiry': DateFormat('MMM dd, yyyy').format(expiryDate!),
        };
        await _db.child('pantry/$uid').update(itemData);

        final snapshot = await _db.child('pantry/$uid').get();
        final savedData = snapshot.value as Map?;

        await _db.child('last_scanned_uid').remove();
        await _scanListener?.cancel();
        setLoading(false);

        if (savedData != null && context.mounted) {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('✅ Item Saved'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📌 RFID: $uid"),
                  Text("🛒 Item: ${savedData['item'] ?? '-'}"),
                  Text("⚖️ Known Weight: ${savedData['known_weight'] ?? '-'} g"),
                  Text("⚖️ Measured: ${savedData['measured_weight'] ?? '-'} g"),
                  Text("📅 Expiry: ${savedData['expiry'] ?? '-'}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('OK', style: TextStyle(color: AppColors.Teal)),
                )
              ],
            ),
          );
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item saved under RFID: $uid'),
              backgroundColor: AppColors.Teal,
            ),
          );
        }
      }
    });
  }

  void dispose() {
    _scanListener?.cancel();
  }
}
