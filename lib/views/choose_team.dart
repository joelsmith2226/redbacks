import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/choose_team_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class ChooseTeamView extends StatefulWidget {
  @override
  _ChooseTeamViewState createState() => _ChooseTeamViewState();
}

class _ChooseTeamViewState extends State<ChooseTeamView> {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    Team team = user.team;
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Team", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
            children: [
          ChooseTeamSummary(),
          TeamWidget(team, "money", bench: false),
        ]),
      ),
    );
  }
}
