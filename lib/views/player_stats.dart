import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_list.dart';

class PlayerStatsView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    print("user players: ${user.playerDB.length}");
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                PlayerList(players: user.playerDB, mode: PLAYERSTATS,),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Player Stats",
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
    );
  }
}
