// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_pantry/routes/routes.dart';

class HomeController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('pantry');

  void listenToPantryData({
    required Function(double weight, String productName, String expiryDate) onDataChange,
  }) {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final firstEntry = data.entries.first.value as Map?;
        if (firstEntry != null &&
            firstEntry.containsKey('item') &&
            firstEntry['item'].toString().isNotEmpty) {
          onDataChange(
            double.tryParse(firstEntry['measured_weight'].toString()) ?? 0.0,
            firstEntry['item'] ?? 'No item added',
            firstEntry['expiry'] ?? 'No item added',
          );
        } else {
          onDataChange(0.0, 'No item added', 'No item added');
        }
      } else {
        onDataChange(0.0, 'No item added', 'No item added');
      }
    });
  }

  void listenToScanStatus({
    required Function(bool showRFIDWidget) onScanComplete,
  }) {
    _dbRef.child('scan_status').onValue.listen((DatabaseEvent event) {
      final status = event.snapshot.value;
      if (status == 'done' || status == false) {
        onScanComplete(true);
      }
    });
  }

  void navigateToAddItem(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.ADDITEM);
  }

  Future<void> triggerRFIDVerification({
    required Function(bool isVerifying) onVerificationStart,
    required Function(bool isVerifying) onVerificationFail,
  }) async {
    onVerificationStart(true);
    try {
      await _dbRef.child('verify_scan').set(true);
      await _dbRef.child('scan_status').set('waiting');
      Fluttertoast.showToast(
        msg: 'Verification request sent to device',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      onVerificationFail(false);
      Fluttertoast.showToast(
        msg: 'Failed to trigger scan',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
