# Restaurant Pantry System  
### IoT-Based Inventory Tracking and Automation

The **Restaurant Pantry System** is an IoT-powered inventory management solution designed to automate stock monitoring, track item usage in real time, and notify kitchen staff when supplies reach critical levels. This system integrates hardware sensors, RFID technology, weight monitoring, and a mobile application to deliver a smarter and more efficient kitchen workflow.

---

## Features

### 🔹 Real-Time Inventory Tracking
* RFID tags identify each pantry item uniquely.  
* Weight sensors continuously monitor remaining stock.  
* Automatic updates sent directly to the mobile app.

### 🔹 Smart Alerts & Notifications
* Alerts are triggered when item weight drops below a threshold (e.g., 200g).  
* Detects abnormal weight drops and warns staff immediately.  
* Notifies the staff when an item is removed and requires RFID verification.

### 🔹 Mobile App Integration
* Built with Flutter and connected to Firebase.  
* Displays item information: name, weight graph, expiry date, and daily usage.  
* Allows kitchen staff to verify RFID tags and update pantry entries.

### 🔹 Hardware Automation
* Arduino-based system with:
  - Load cell for weight detection  
  - RFID module for tag scanning  
  - Buzzer for controlled alerts  
  - Wi-Fi module for cloud syncing  
* Smart logic avoids false alarms during sudden item removal.

---

## How It Works

1. **User scans the RFID tag** for an item during setup.  
2. **Item data is stored in Firebase**, including name, expiry, and initial weight.  
3. **Load cells track weight changes** as the item is used.  
4. **System sends alerts** if weight becomes too low or decreases abnormally.  
5. When the item is taken out:
   - Arduino prompts the user for **RFID re-scan**  
   - UID is **verified with Firebase**  
   - Result is sent back to the app

---

## Technologies Used

### **Hardware**
* Arduino + Load Cells  
* RFID-RC522 Module  
* HX711 Amplifier  
* Buzzer + LEDs  
* Wi-Fi Module (ESP8266/ESP32)

### **Software**
* Flutter (mobile application)  
* Firebase Firestore  
* Firebase Authentication  
* Firebase Realtime Communication  
* Arduino C++ Firmware  

---

## Future Enhancements
* Predictive restocking using AI-based usage forecasting  
* Multi-shelf tracking and grouping  
* Supplier integration for auto-ordering  
* Advanced analytics dashboard for restaurants
