import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/flag.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_point_breakdowns.dart';
import 'package:redbacks/widgets/player/player_selector_card.dart';

class PlayerCard extends StatelessWidget {
  Player player;
  TeamPlayer teamPlayer; // player is data from DB. teamPlayer is data from team
  AlertDialog pc;
  BuildContext context;
  String mode;
  VoidCallback callback;

  PlayerCard(
      {this.player, this.context, this.mode, this.callback, this.teamPlayer}) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    this.pc = AlertDialog(
      insetPadding: EdgeInsets.all(27.0),
      title: Text(
        '${this.player.name}',
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            this.player.flag == null ? Container() : _flagSummary(),
            Image.asset("assets/profilepics/${player.pic}",
                width: MediaQuery.of(context).size.width * 0.3),
            SizedBox(height: 30),
            Text(
                'Value: \$${this.player.price}m    Total Points: ${this.player.totalPts}\n'),
            PlayerPointBreakdowns(user.gwHistory, player),
          ]),
      actions: cardActions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.pc;
  }

  List<Widget> cardActions() {
    switch (this.mode) {
      case POINTS:
        return pointsActions();
      case PICK:
        return pickActions();
      case PRICE:
        return transferActions();
      default:
        return pointsActions();
    }
  }

  List<Widget> pickActions() {
    return [
      this.teamPlayer.index != 5 ? rankCheckBox(CAPTAIN) : Container(),
      this.teamPlayer.index != 5 ? rankCheckBox(VICE) : Container(),
      this.teamPlayer.index != 5
          ? MaterialButton(
              textColor: Color(0xFF6200EE),
              onPressed: () {
                LoggedInUser user =
                    Provider.of<LoggedInUser>(context, listen: false);
                String result = user.benchPlayer(this.teamPlayer);
                if (result != "") {
                  print(result);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                }
                Navigator.pop(context);
              },
              child: Text('Bench'),
            )
          : Container(),
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('OK'),
      ),
    ];
  }

  List<Widget> pointsActions() {
    return [
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('OK'),
      ),
    ];
  }

  List<Widget> transferActions() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);

    return [
      this.teamPlayer.inConsideration && !user.signingUp
          ? this.restoreOriginalTeamMember()
          : this.removeRestoreBtn(),
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          Navigator.pop(context);
          PlayerSelectorCard psc = PlayerSelectorCard(
              outgoingPlayer: this.teamPlayer, context: context);
          psc.displayCard();
        },
        child: Text('Replace'),
      ),
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('OK'),
      ),
    ];
  }

  Widget removeRestoreBtn() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    return MaterialButton(
      textColor: Color(0xFF6200EE),
      onPressed: () {
        user.removePlayer(this.teamPlayer);
        if (!user.signingUp &&
            ModalRoute.of(context).settings.name != Routes.ChooseTeam) {
          Navigator.pushNamed(context, Routes.ChooseTeam);
        } else {
          Navigator.pop(context);
        }
      },
      child: Text(this.teamPlayer.removed ? 'Restore' : 'Remove'),
    );
  }

  Widget restoreOriginalTeamMember() {
    return MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
          user.reinstateOriginalTeamPlayerFromCard(this.teamPlayer);
          if (!user.signingUp &&
              ModalRoute.of(context).settings.name != Routes.ChooseTeam) {
            Navigator.pushNamed(context, Routes.ChooseTeam);
          } else {
            Navigator.pop(context);
          }
        },
        child: Text('Restore Original Player'));
  }

  void displayCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this.pc;
      },
    );
  }

  Widget rankCheckBox(rank) {
    return Container(
        child: Column(children: [
      Checkbox(
        value: this.teamPlayer.rank == rank,
        onChanged: (value) => updateCaptaincy(value, rank),
      ),
      Text(rank)
    ]));
  }

  void updateCaptaincy(bool value, String rank) {
    if (!value) {
      return;
    }
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    user.updateCaptaincy(this.teamPlayer, rank);
    Navigator.pop(context);
    user.pushTeamToDB();
  }

  Widget _flagSummary() {
    Flag f = this.player.flag;
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: f.severity == 1 ? Colors.amberAccent : Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: double.maxFinite,
      child: Text("${f.printStats()}", style: TextStyle(color: Colors.white)),
    );
  }
}
