import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/choose_team_summary.dart';
import 'package:redbacks/widgets/player_list.dart';
import 'package:redbacks/widgets/team_widget.dart';

class TransferView extends StatefulWidget {
  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    Player outgoing = user.pendingTransfer.outgoing;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Transfer", style: GoogleFonts.merriweatherSans()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(20),
          color: Colors.white70.withAlpha(240),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PlayerList(players: [
            Player.template(),
            Player.template(),
            Player.template()
          ]),
        ),
      ),
    );
  }
}
