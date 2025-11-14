Restaurant Pantry System

The Restaurant Pantry System is an IoT-based smart inventory solution designed to help restaurants track pantry items accurately and efficiently. Using RFID technology, weight sensors, Arduino, Firebase, and a Flutter mobile app, the system provides real-time monitoring of item weight, stock levels, and usage patterns to prevent shortages and reduce waste in the kitchen.

Overview

This system replaces manual pantry checking with automated tracking. Each pantry item is tagged with an RFID sticker, while a load cell measures its current weight. The Arduino processes these readings and updates the data in Firebase, where the Flutter app retrieves and displays the information.
The system also detects sudden weight drops, slow consumption, and near-empty items, sending alerts when necessary.

Features
RFID-Based Item Identification

Every item is assigned a unique RFID tag.

The Arduino reads the tag to identify which item is being scanned.

Prevents incorrect item removal by verifying the scanned tag with Firebase.

Real-Time Weight Monitoring

Load cell with HX711 amplifier continuously measures item weight.

Detects:

Gradual reduction (normal consumption)

Sudden drop (item removal)

Low-stock condition (below threshold like 200g)

Automated Alerts

Sends notifications when an item is nearly empty.

Warns when sudden or unexpected weight changes occur.

Helps staff restock items before they run out.

Flutter Mobile Application

Displays live pantry data such as:

Item name

Current weight

Weight history graph

Expiry date

RFID UID

Product image

Allows users to update item information.

Arduino–Flutter and Firebase Communication

The app sends scan or verify commands to the Arduino.

The Arduino reads the RFID tag and sends results back.

Firebase keeps all data synchronized between devices and microcontrollers.

How It Works

Item Registration
The user registers a pantry item by scanning its RFID tag and entering its details in the mobile app. The information is saved in Firebase.

Monitoring Stage
The load cell continuously tracks the item weight. Updates are sent to Firebase and shown in the app.

Usage Detection

Slow weight decrease → considered normal usage

Rapid or large drop → triggers a verification request

Arduino scans RFID to confirm correct item removal

Low Stock Alert
When the item weight falls below a preset threshold, the system notifies the user to restock.

Database Synchronization
Firebase stores all item details, allowing seamless access from any connected device.

Technologies Used

Arduino (ESP32/ESP8266) – Reads RFID tags, measures weight, communicates with Firebase

RC522 RFID Reader – Scans unique item tags

Load Cell + HX711 Amplifier – Detects and measures item weight

Flutter – Mobile application for visualization and configuration

Firebase Firestore – Cloud database for storing and syncing item data
