import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class PointsSummary extends StatefulWidget {
  @override
  _PointsSummaryState createState() => _PointsSummaryState();
}

class _PointsSummaryState extends State<PointsSummary> {
  @override
  Widget build(BuildContext context) {
    var style = GoogleFonts.merriweatherSans();
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);

    return HomepageSummary(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SummaryContainer(
            body: PointsText("GW", "1", Theme.of(context).primaryColor, Colors.white)),
        SummaryContainer(
            body: PointsText("${user.gwPts}", "pts", Colors.white, Theme.of(context).primaryColor)),
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
