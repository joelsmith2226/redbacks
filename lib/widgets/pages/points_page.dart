import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  RefreshController _refreshController = new RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          // completeDuration: Duration(seconds: 4),
        ),
        controller: _refreshController,
        onRefresh: () => _onRefresh(user),
        onLoading: () => _onLoading(user),
        child: ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PointsSummary(),
                  TeamWidget(user.team, bench: true, mode: POINTS),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onLoading(LoggedInUser user) async {
    try {
      await user.generalDBPull();
    } catch (e) {
      _onError(e);
    }
    this._refreshController.loadComplete();
    return;
  }

  void _onRefresh(LoggedInUser user) async {
    try {
      await user.generalDBPull();
      user.calculatePoints();
    } catch (e) {
      _onError(e);
    }
    this._refreshController.refreshCompleted();
    setState(() {});
  }

  void _onError(dynamic e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong: ${e}"),));
  }
}
