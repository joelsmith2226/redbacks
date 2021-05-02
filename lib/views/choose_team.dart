import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/choose_team_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class ChooseTeamView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ChooseTeamView();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    // Immediately logout if in patchmode
    if (user.patchMode && !user.admin || !Authentication().isLoggedIn()) {
      Authentication().logoutFn(context);
    }

    Team team = user.team;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text(user.signingUp ? "Choose Team" : "Transfers",
                style: GoogleFonts.merriweatherSans()),
            centerTitle: true,
            leading: user.signingUp
                ? Container()
                : MaterialButton(
              onPressed: () {
                user.restoreOriginals();
                Navigator.of(context).pushReplacementNamed(Routes.Home);
              },
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
            )),
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                Expanded(
                  child: Container(
                    child: TeamWidget(team, mode: PRICE, bench: false),),),
                Container(
                  margin: EdgeInsets.all(20),
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: Theme
                        .of(context)
                        .canvasColor,
                    onPressed: () {
                      String errMsg = "";
                      print(team.corrupted());
                      if (!team.isComplete()) {
                        errMsg =
                        "Team is incomplete! Make sure no ? players left";
                      } else if (user.budget < 0) {
                        errMsg = "Not enough budget for this team!";
                      } else if (team.corrupted()) {
                        errMsg =
                        "Team was corrupted somehow with duplicate players, please try transfer process again!";
                        user.restoreOriginals();
                        Navigator.of(context).pushReplacementNamed(Routes.Home);
                      } else {
                        Navigator.of(context).pushNamed(Routes.Confirm);
                      }
                      if (errMsg != '')
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(errMsg)));
                      return;
                    },
                    child: Text('Confirm'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
