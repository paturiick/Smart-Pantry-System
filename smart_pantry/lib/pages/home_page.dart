import 'package:flutter/material.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/controllers/home_page_controller.dart';
import 'package:smart_pantry/routes/routes.dart';
import 'package:smart_pantry/widget/scanning_rfid_dialog.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double weight = 0.0;
  String productName = 'No item added';
  String expiryDate = 'No item added';
  String rfid = 'No tag scanned';

  final HomePageController _controller = HomePageController();

  @override
  void initState() {
    super.initState();
    _controller.listenToPantryData(
      onData:
          ({
            required double weight,
            required String productName,
            required String expiryDate,
            required String rfid,
          }) {
            setState(() {
              this.weight = weight;
              this.productName = productName;
              this.expiryDate = expiryDate;
              this.rfid = rfid;
            });
          },
    );
  }

  void _navigateToAddItem() {
    _controller.navigateToAddItem(context, AppRoutes.ADDITEM);
  }

  void _triggerScan() {
    _controller.triggerRFIDScan();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final isSmallScreen = media.height < 700;

    String weightLevel = 'Normal';
    if (weight < 100) {
      weightLevel = 'Critical';
    } else if (weight < 200) {
      weightLevel = 'Moderate';
    }

    return Scaffold(
      backgroundColor: AppColors.Aqua,
      appBar: AppBar(
        title: const Text(
          'GrubGuard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.Teal,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ScanningRFIDDialog.show(context, _controller);
            },
            icon: const Icon(Icons.rss_feed, color: Colors.white),
            tooltip: 'Scan RFID',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        backgroundColor: AppColors.Teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.06,
                  vertical: media.height * 0.04,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(media.width * 0.05),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.Mint,
                      ),
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: media.width * 0.15,
                        color: AppColors.Teal,
                      ),
                    ),
                    SizedBox(height: media.height * 0.02),
                    Text(
                      productName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: media.width * 0.055,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: media.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Expiry: $expiryDate',
                          style: TextStyle(
                            fontSize: media.width * 0.035,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: media.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rss_feed_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'RFID: $rfid',
                          style: TextStyle(
                            fontSize: media.width * 0.035,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: media.height * 0.02),

                    /// Weight Gauge
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: weight),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, animatedWeight, child) {
                        return SizedBox(
                          height: media.height * 0.3,
                          child: SfRadialGauge(
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
                                    endValue: 100,
                                    color: Colors.redAccent.shade100,
                                    startWidth: 0.2,
                                    endWidth: 0.2,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  ),
                                  GaugeRange(
                                    startValue: 100,
                                    endValue: 200,
                                    color: AppColors.YellowAccent,
                                    startWidth: 0.2,
                                    endWidth: 0.2,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  ),
                                  GaugeRange(
                                    startValue: 200,
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${animatedWeight.toStringAsFixed(1)} g',
                                          style: TextStyle(
                                            fontSize: media.width * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Current Weight'),
                                      ],
                                    ),
                                    angle: 90,
                                    positionFactor: 0.8,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    /// Warning Section
                    if (weightLevel != 'Normal')
                      Container(
                        margin: EdgeInsets.only(top: media.height * 0.03),
                        padding: EdgeInsets.symmetric(
                          horizontal: media.width * 0.04,
                          vertical: media.height * 0.018,
                        ),
                        decoration: BoxDecoration(
                          color: weightLevel == 'Critical'
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.orangeAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: weightLevel == 'Critical'
                                ? Colors.redAccent
                                : Colors.orangeAccent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: weightLevel == 'Critical'
                                  ? Colors.redAccent
                                  : Colors.orangeAccent,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              weightLevel == 'Critical'
                                  ? 'Critical: Weight is below 100g!'
                                  : 'Moderate: Weight is below 200g!',
                              style: TextStyle(
                                color: weightLevel == 'Critical'
                                    ? Colors.redAccent
                                    : Colors.orangeAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: media.height * 0.03),
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
