import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/choose_team_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class ChooseTeamView extends StatefulWidget {
  @override
  _ChooseTeamViewState createState() => _ChooseTeamViewState();
}

class _ChooseTeamViewState extends State<ChooseTeamView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    Team team = user.team;
    return Scaffold(
      key: _scaffoldKey,
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChooseTeamSummary(),
              Expanded(child: TeamWidget(team, mode: "money", bench: false)),
              Container(
                margin: EdgeInsets.all(20),
                child: MaterialButton(
                  padding: EdgeInsets.all(20),
                  color: Theme.of(context).canvasColor,
                  onPressed: team.isComplete()
                      ? () {
                          user.userDetailsPushDB();
                          user.signingUp = false;
                          Navigator.pushReplacementNamed(context, Routes.Home);
                        }
                      : null,
                  child: Text('Confirm'),
                ),
              ),
            ]),
      ),
    );
  }
}
