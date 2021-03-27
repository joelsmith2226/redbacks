import 'package:flutter/material.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/team_widget.dart';
import 'package:redbacks/widgets/transfers_summary.dart';

class TransfersPage extends StatefulWidget {
  @override
  _TransfersPageState createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
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
          TransfersSummary(),
          TeamWidget(Team.blank(), "money"),
        ],
      ),
    );;
  }
}
