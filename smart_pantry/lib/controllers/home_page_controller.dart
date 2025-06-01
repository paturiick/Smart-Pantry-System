import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePageController {
  final db = FirebaseDatabase.instance.ref();

  void listenToPantryData({
    required Function({
      required double weight,
      required String productName,
      required String expiryDate,
      required String rfid,
    })
    onData,
  }) {
    // Listen to last scanned UID
    db.child('last_scanned_uid').onValue.listen((event) {
      final String? rfid = event.snapshot.value?.toString();

      if (rfid != null && rfid.isNotEmpty) {
        // Read item data from pantry path
        db.child('pantry/$rfid').onValue.listen((itemSnap) {
          final data = itemSnap.snapshot.value as Map?;

          if (data != null) {
            final double weight = double.tryParse(
                  data['current_weight']?.toString() ?? '0.0',
                ) ??
                0.0;
            final String item = data['item']?.toString() ?? 'No item added';
            final String expiry = data['expiry']?.toString() ?? 'No expiry';

            onData(
              weight: weight,
              productName: item,
              expiryDate: expiry,
              rfid: rfid,
            );
          }
        });
      }
    });
  }

  void navigateToAddItem(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
