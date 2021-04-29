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
      return PreAppPoints(callback: (val) => setState(() => currentWeek = val));
    } else if (currentWeek < 0) {
      currentWeek = 0;
    }

    // Sort userGWs by GW id;
    user.userGWs.sort((UserGW a, UserGW b) => a.id.compareTo(b.id));
    UserGW ugw = user.userGWs.length >= currentWeek
        ? user.userGWs[currentWeek - 1]
        : null;

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PointsSummary(
              ugw, currentWeek, (val) => setState(() => currentWeek = val)),
          ugw == null
              ? Container(
              margin: EdgeInsets.all(20), child: Text("No points for this GW"))
              : TeamWidget(ugw.team, bench: true, mode: POINTS),
        ],
      ),
    );
  }
}
