import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/choose_team_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class ChooseTeamView extends StatefulWidget {
  @override
  _ChooseTeamViewState createState() => _ChooseTeamViewState();
}

class _ChooseTeamViewState extends State<ChooseTeamView> {
  @override
  Widget build(BuildContext context) {
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
          TeamWidget(Team.blank(), "money", bench: false),
        ]),
      ),
    );
  }
}
