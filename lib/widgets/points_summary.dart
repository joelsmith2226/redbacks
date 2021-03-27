import 'package:flutter/material.dart';
import 'package:redbacks/widgets/homepage_summary.dart';

class PointsSummary extends StatefulWidget {
  @override
  _PointsSummaryState createState() => _PointsSummaryState();
}

class _PointsSummaryState extends State<PointsSummary> {
  @override
  Widget build(BuildContext context) {
    return HomepageSummary(
      body: Text("    GW12        25pts    ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}
