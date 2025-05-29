import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/routes/routes.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double weight = 0.0;
  String productName = 'No item added';
  String expiryDate = 'No item added';

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('pantry');

  @override
  void initState() {
    super.initState();
    _listenToPantryData();
  }

  void _listenToPantryData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data.containsKey('item') && data['item'].toString().isNotEmpty) {
        setState(() {
          weight = double.tryParse(data['weight(g)'].toString()) ?? 0.0;
          productName = data['item'] ?? 'No item added';
          expiryDate = data['expiry'] ?? 'No item added';
        });
      } else {
        setState(() {
          weight = 0.0;
          productName = 'No item added';
          expiryDate = 'No item added';
        });
      }
    });
  }

  void _navigateToAddItem() {
    Navigator.pushNamed(context, AppRoutes.ADDITEM);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowWeight = weight < 200.0;

    return Scaffold(
      backgroundColor: AppColors.Aqua,
      appBar: AppBar(
        title: const Text(
          'Smart Pantry System',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.Teal,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        backgroundColor: AppColors.Teal,
        child: const Icon(Icons.add, color: Colors.white),
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
                        color: AppColors.Mint,
                      ),
                      child: Icon(
                        Icons.shopping_bag_rounded,
                        size: 60,
                        color: AppColors.Teal,
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
                                  color: Colors.redAccent.shade100,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                                GaugeRange(
                                  startValue: 200,
                                  endValue: 500,
                                  color: AppColors.YellowAccent,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                                GaugeRange(
                                  startValue: 500,
                                  endValue: 1000,
                                  color: AppColors.Mint,
                                  startWidth: 0.2,
                                  endWidth: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: animatedWeight,
                                  needleColor: AppColors.Teal,
                                  knobStyle: KnobStyle(color: AppColors.Teal),
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
                    if (isLowWeight)
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                            const SizedBox(width: 10),
                            Text(
                              'Weight is below 200g!',
                              style: TextStyle(
                                color: Colors.redAccent,
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
