import 'package:flutter/material.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class PointsSummary extends StatefulWidget {
  @override
  _PointsSummaryState createState() => _PointsSummaryState();
}

class _PointsSummaryState extends State<PointsSummary> {
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);
    return HomepageSummary(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SummaryContainer(
            body: PointsText("GW", "12", Theme.of(context).primaryColor, Colors.white)),
        SummaryContainer(
            body: PointsText("25", "pts", Colors.white, Theme.of(context).primaryColor)),
      ],
    ));
  }

  Widget PointsText(String t1, String t2, Color c1, Color c2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(text: t1, style: TextStyle(color: c1, fontSize: 24, fontWeight: FontWeight.bold),
          children: [
        TextSpan(text: t2, style: TextStyle(color: c2, fontSize: 24),)
      ]),
    );
  }
}
