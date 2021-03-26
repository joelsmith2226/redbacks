import 'package:flutter/material.dart';

class HomepageSummary extends StatefulWidget {
  @override
  _HomepageSummaryState createState() => _HomepageSummaryState();
}

class _HomepageSummaryState extends State<HomepageSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(bottom: 50),
      color: Colors.black.withAlpha(100),
      child: Text("    GW12        25pts    ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)), alignment: Alignment.center,
    );
  }
}
