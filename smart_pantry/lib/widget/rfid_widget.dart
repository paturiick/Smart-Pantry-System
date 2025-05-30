import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RFIDWidget extends StatefulWidget {
  const RFIDWidget({Key? key}) : super(key: key);

  @override
  _RFIDWidgetState createState() => _RFIDWidgetState();
}

class _RFIDWidgetState extends State<RFIDWidget> {
  final dbRef = FirebaseDatabase.instance.ref();
  String? status = "";
  String? verificationResult = "";

  @override
  void initState() {
    super.initState();
    listenForStatus();
  }

  void listenForStatus() {
    dbRef.child("rfid/status").onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() => status = value.toString());
      }
    });

    dbRef.child("rfid/verify_result").onValue.listen((event) {
      final result = event.snapshot.value;
      if (result != null) {
        setState(() => verificationResult = result.toString());
      }
    });
  }

  Future<void> triggerScan() async {
    await dbRef.child("rfid/command").set("scan");
  }

  Future<void> triggerVerification() async {
    await dbRef.child("rfid/command").set("verify");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("RFID Operations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: triggerScan,
                    child: const Text("Scan New RFID"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: triggerVerification,
                    child: const Text("Verify RFID"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Scan Status: $status", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Verification Result: $verificationResult", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
