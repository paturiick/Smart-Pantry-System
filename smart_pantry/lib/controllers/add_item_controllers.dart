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

    // ✅ Clear previous UID and temp scan data
    await _db.child('last_scanned_uid').remove();
    await _db.child('temp_scan').set(itemData);
    await _db.child('scan_trigger').set(true);

    _listenForScan(context, itemData, onSuccess);
  }

  void _listenForScan(
    BuildContext context,
    Map<String, dynamic> itemData,
    VoidCallback onSuccess,
  ) {
    bool alreadyWarned = false;

    _scanSubscription?.cancel();
    _scanSubscription = _db.child('last_scanned_uid').onValue.listen((
      event,
    ) async {
      final uid = event.snapshot.value?.toString();

      if (uid != null && uid.isNotEmpty) {
        if (uid == "ALREADY_USED") {
          if (!alreadyWarned) {
            alreadyWarned = true;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚠️ RFID already linked. Scan a different tag.'),
              ),
            );
          }
          return;
        }

        // ✅ Valid UID scanned
        _scanSubscription?.cancel();
        isScanning = false;

        await _db.child('pantry/$uid').set(itemData);
        await _db.child('last_scanned_uid').set(uid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Item added to pantry!'),
            backgroundColor: AppColors.Teal,
          ),
        );

        await _db.child('temp_scan').remove();
        await Future.delayed(const Duration(milliseconds: 500));
        await _db.child('scan_trigger').set(false);

        onSuccess();
      }
    });
  }

  Future<void> cancelScan(BuildContext context) async {
    isScanning = false;
    _scanSubscription?.cancel();

    await _db.child('scan_trigger').set(false);
    await _db.child('last_scanned_uid').set("CANCELLED");
    await _db.child('temp_scan').remove();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Cancelled'),
        content: const Text('The RFID scan was cancelled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
