import 'package:flutter/material.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/controllers/home_page_controller.dart';

class ScanningRFIDDialog extends StatelessWidget {
  final HomePageController controller;

  const ScanningRFIDDialog({super.key, required this.controller});
  static Future<void> show(
    BuildContext context,
    HomePageController controller,
  ) {
    controller.triggerRFIDScan();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ScanningRFIDDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.rss_feed, color: AppColors.Teal),
          SizedBox(width: 8),
          Text('Scanning RFID'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(color: AppColors.Teal),
          SizedBox(height: 16),
          Text(
            'Waiting for RFID tag to be scanned...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.triggerRFIDScanCancel();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
