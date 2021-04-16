import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PointsSummary(),
          TeamWidget(user.team, bench: true, mode: POINTS),
        ],
      ),
    );
  }
}
