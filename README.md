Restaurant Pantry System

An IoT-based inventory tracking system for restaurants that uses RFID tags, weight sensors, Arduino microcontrollers, Firebase, and a Flutter mobile app. The system monitors pantry items in real time, detects usage through weight changes, verifies removed items, and updates inventory automatically to reduce waste and prevent stockouts.

Features

RFID-based item identification

Real-time weight monitoring using load cells (HX711)

Detection of slow consumption vs. sudden item removal

Low-stock alerts (example threshold: 200 g)

Automated verification on removal via RFID scan

Flutter mobile app for viewing items, weight graphs, images, and alerts

Firebase Firestore for cloud storage and real-time synchronization

Overview

Each pantry item is tagged with an RFID sticker and placed on a load cell. An Arduino (ESP32/ESP8266 recommended) reads the RFID UID and measures weight through the HX711 amplifier. Weight and tag data are sent to Firebase, where the Flutter app retrieves and displays current item status, weight history, and notifications. Sudden large weight drops trigger a verification request; the Arduino scans the RFID tag and confirms the removal before the database is updated.

How it works

Register an item by scanning its RFID tag and entering details in the Flutter app. Data is saved to Firebase.

Arduino continuously measures weight and reports updates to Firebase.

Normal usage appears as a gradual weight decrease; sudden drops trigger verification.

On verification, Arduino confirms the RFID UID with Firebase before marking the item removed.

When weight falls below a preset threshold, the system sends a low-stock alert to the app.

Components & Technologies

Arduino (ESP32 or ESP8266) — microcontroller with WiFi

RC522 RFID reader — reads RFID tag UIDs

Load cell + HX711 amplifier — measures weight

Flutter — mobile application for UI and controls

Firebase Firestore — cloud database for storage and real-time sync
