import 'package:flutter/material.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/points_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

import 'homepage_summary.dart';

class PointsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          PointsSummary(),
          TeamWidget(Team.blank(), "points"),
        ],
      ),
    );
  }
}