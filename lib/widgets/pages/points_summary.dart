import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
import 'package:redbacks/widgets/summary_container.dart';

class PointsSummary extends StatefulWidget {
  UserGW userGW;
  int currGW;
  Function onPressed;

  PointsSummary(this.userGW, this.currGW, this.onPressed);

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
      children: widget.userGW == null
          ? rowChildrenNoUserGW(context)
          : rowChildrenWithUserGW(context),
    ));
  }

  List<Widget> rowChildrenWithUserGW(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => widget.onPressed(widget.currGW - 1),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      ),
      SummaryContainer(
          body: PointsText("GW", "${widget.userGW.gw.id}",
              Theme.of(context).primaryColor, Colors.white)),
      SummaryContainer(
          body: PointsText("${widget.userGW.points}", "pts", Colors.white,
              Theme.of(context).primaryColor)),
      SummaryContainer(
          body: PointsText("${widget.userGW.hits}", " hits", Colors.white,
              Theme.of(context).primaryColor)),
      IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () => widget.onPressed(widget.currGW + 1),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      )
    ];
  }

  List<Widget> rowChildrenNoUserGW(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => widget.onPressed(widget.currGW - 1),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      ),
      SummaryContainer(
          body: PointsText("GW", "${widget.currGW}",
              Theme.of(context).primaryColor, Colors.white)),
      SummaryContainer(
          body: PointsText(
              "?", "pts", Colors.white, Theme.of(context).primaryColor)),
      SummaryContainer(
          body: PointsText(
              "?", " hits", Colors.white, Theme.of(context).primaryColor)),
      IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () => widget.onPressed(widget.currGW + 1),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      )
    ];
  }

  Widget PointsText(String t1, String t2, Color c1, Color c2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: t1,
          style:
              TextStyle(color: c1, fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: t2,
              style: TextStyle(color: c2, fontSize: 24),
            )
          ]),
    );
  }
}
