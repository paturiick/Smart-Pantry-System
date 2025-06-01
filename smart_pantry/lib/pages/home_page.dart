import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double weight = 0.0;
  String productName = 'Loading...';
  String expiryDate = 'Loading...';

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('pantry');

  @override
  void initState() {
    super.initState();
    _listenToPantryData();
  }

  void _listenToPantryData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          weight = double.tryParse(data['weight(g)'].toString()) ?? 0.0;
          productName = data['item'] ?? 'Unknown';
          expiryDate = data['expiry'] ?? 'Unknown';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowWeight = weight < 200.0;

    final Color primaryColor = const Color(0xFF00796B); // Teal
    final Color accentColor = const Color(0xFFB2DFDB); // Light mint
    final Color warningColor = const Color(0xFFE57373); // Light red
    final Color bgColor = const Color(0xFFF1F8F6); // Soft background

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Smart Pantry System',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                      ),
                      child: Icon(
                        Icons.shopping_bag_rounded,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      productName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          'Expiry: $expiryDate',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // START OF ANIMATED GAUGE
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: weight),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, animatedWeight, child) {
                        return SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 1000,
                              showTicks: false,
                              showLabels: false,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.2,
                                thicknessUnit: GaugeSizeUnit.factor,
                                cornerStyle: CornerStyle.bothCurve,
                              ),
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 200,
                                  color: warningColor,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                                GaugeRange(
                                  startValue: 200,
                                  endValue: 500,
                                  color: Colors.amberAccent.shade100,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                                GaugeRange(
                                  startValue: 500,
                                  endValue: 1000,
                                  color: Colors.greenAccent.shade100,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: animatedWeight,
                                  needleColor: primaryColor,
                                  knobStyle: KnobStyle(color: primaryColor),
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Column(
                                    children: [
                                      Text(
                                        '${animatedWeight.toStringAsFixed(1)} g',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('Current Weight'),
                                    ],
                                  ),
                                  angle: 90,
                                  positionFactor: 0.8,
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    // END OF ANIMATED GAUGE

                    if (isLowWeight)
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: warningColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: warningColor),
                            const SizedBox(width: 10),
                            Text(
                              'Weight is below 200g!',
                              style: TextStyle(
                                color: warningColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
