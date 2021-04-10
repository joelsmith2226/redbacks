import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointsPage extends StatelessWidget {
  RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    return Container(
        child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(completeDuration: Duration(seconds:4),),
            controller: _refreshController,
            onRefresh: () => _onRefresh(),
            onLoading: () => _onLoading(user),
            child: ListView(
              children: [
                Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                  PointsSummary(),
                  TeamWidget(user.team, bench: true, mode: POINTS),
                ]))
              ],
            )));
  }

  void _onLoading(LoggedInUser user) {
    user.calculatePoints();
    print("REFRESHING");
    this._refreshController.loadComplete();
    return;
  }

  void _onRefresh(){
    this._refreshController.refreshToIdle();
  }
}
