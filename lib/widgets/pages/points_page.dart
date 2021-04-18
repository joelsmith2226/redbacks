import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int currentWeek = 1;
  List<UserGW> userGWHistory = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    print("this: ${currentWeek} ${user.userGWs.length}");
    if (user.userGWs.isEmpty) {
      return Container(child: Text("NO POINTS TO SHOW"));
    } else {
      if (currentWeek > user.userGWs.length) {
        currentWeek = user.userGWs.length;
      } else if (currentWeek <= 0) {
        currentWeek = 1;
      }

      UserGW ugw = user.userGWs.length >= currentWeek
          ? user.userGWs[currentWeek - 1]
          : null;

      if (ugw != null) {
        ugw = ugw.gw == null ? null : ugw;
      }

      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PointsSummary(
                ugw, currentWeek, (val) => setState(() => currentWeek = val)),
            ugw == null
                ? Container(child:Text("No points for this GW"))
                : TeamWidget(ugw.team, bench: true, mode: POINTS),
          ],
        ),
      );
    }
  }
}
