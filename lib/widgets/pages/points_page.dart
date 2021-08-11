import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';
import 'package:redbacks/widgets/pre_app_points.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int currentWeek;
  List<UserGW> userGWHistory = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    currentWeek = user.gwHistory.length;
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (user.userGWs.isEmpty) {
      currentWeek = 0;
    }

    if (currentWeek > user.userGWs.length) {
      currentWeek = user.userGWs.length;
    } else if (currentWeek == 0) {
      // PREAPP POINTS HERE
      return PreAppPoints(
        callback: (val) => setState(() => currentWeek = val),
        preAppPoints: user.preAppPoints,
      );
    } else if (currentWeek < 0) {
      currentWeek = 0;
    }

    // Sort userGWs by GW id;
    user.userGWs.sort((UserGW a, UserGW b) => a.id.compareTo(b.id));
    UserGW ugw = user.userGWs.length >= currentWeek
        ? user.userGWs[currentWeek - 1]
        : null;

    return Container(
      height: double.maxFinite,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PointsSummary(
                  ugw, currentWeek, (val) => setState(() => currentWeek = val)),
              ugw == null
                  ? Container(
                      margin: EdgeInsets.all(20),
                      child: Text("No points for this GW"))
                  : Expanded(
                      child: TeamWidget(ugw.team, bench: true, mode: POINTS),
                    ),
            ],
          ),
          ugw.chip != '' ? chipContainer(ugw.chip) : Container(),
        ],
      ),
    );
  }

  Widget chipContainer(String chip) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black38.withAlpha(170),
        ),
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(15),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: PointsText(
            "Chip Used\n",
            CHIPS[chip],
            Theme.of(context).primaryColor,
            Colors.white,
          ),
        ),
      ),
    );
  }

  Widget PointsText(String t1, String t2, Color c1, Color c2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: t1,
          style:
              TextStyle(color: c1, fontSize: 16, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: t2,
              style: TextStyle(color: c2, fontSize: 26),
            )
          ]),
    );
  }
}
