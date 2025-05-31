import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePageController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('pantry');

  void listenToPantryData({
    required void Function({
      required double weight,
      required String productName,
      required String expiryDate,
      required String rfid,
    })
    onData,
  }) {
    _dbRef.orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;

      if (data != null && data.isNotEmpty) {
        final latestEntry = data.entries.first;
        final rfid = latestEntry.key;
        final itemData = latestEntry.value as Map;

        onData(
          weight: double.tryParse(itemData['known_weight'].toString()) ?? 0.0,
          productName: itemData['item'] ?? 'No item added',
          expiryDate: itemData['expiry'] ?? 'No item added',
          rfid: rfid,
        );
      } else {
        onData(
          weight: 0.0,
          productName: 'No item added',
          expiryDate: 'No item added',
          rfid: 'No tag scanned',
        );
      }
    });
  }

  void navigateToAddItem(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
