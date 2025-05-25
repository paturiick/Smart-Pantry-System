import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(40),
              color: Colors.green.shade100,
              child: Column(
                children: [
                  Text(
                    '🧠 Make Your Pantry Smarter',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Track weight, monitor stock, and never miss an expiration again.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Go to Dashboard'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Learn More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FeatureTile(
                    icon: Icons.monitor_weight,
                    title: 'Real-Time Monitoring',
                    subtitle: 'Live stock updates from sensors.',
                  ),
                  FeatureTile(
                    icon: Icons.warning,
                    title: 'Expiration Alerts',
                    subtitle: 'Be notified before items expire.',
                  ),
                  FeatureTile(
                    icon: Icons.cloud,
                    title: 'Remote Access',
                    subtitle: 'Monitor from your phone or laptop.',
                  ),
                  FeatureTile(
                    icon: Icons.rss_feed,
                    title: 'RFID Tracking',
                    subtitle: 'Identify every item via RFID tags.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔄 How It Works',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('1. Scan item using RFID'),
                  Text('2. Place item on smart scale'),
                  Text('3. Track and manage via app'),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Live Data Preview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: Icon(Icons.kitchen),
                      title: Text("Item: Rice"),
                      subtitle: Text(
                        "Weight: 1.2 kg | Stock: ✅ OK | Exp: Jun 20, 2025",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
