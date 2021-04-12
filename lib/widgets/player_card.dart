import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_selector_card.dart';

class PlayerCard extends StatelessWidget {
  Player player;
  TeamPlayer teamPlayer; // player is data from DB. teamPlayer is data from team
  AlertDialog pc;
  BuildContext context;
  String mode;
  VoidCallback callback;

  PlayerCard({this.player, this.context, this.mode, this.callback, this.teamPlayer}) {
    this.pc = AlertDialog(
      title: Text(
        'Player Card',
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/profilepics/${player.pic}",
                width: MediaQuery.of(context).size.width * 0.3),
            SizedBox(height: 30),
            Text(
                'Name: ${this.player.name}\nValue: \$${this.player.price}\nGW Pts: ${this.player.currPts}\nTotal Points: ${this.player.totalPts}\n'),
          ]),
      actions: cardActions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.pc;
  }

  List<Widget> cardActions(){
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

  List<Widget> pickActions(){
    return [
      rankCheckBox(CAPTAIN),
      rankCheckBox(VICE),
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
          user.benchPlayer(this.teamPlayer);
          Navigator.pop(context);
          this.callback();
        },
        child: Text('Bench'),
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

  List<Widget> pointsActions(){
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

  List<Widget> transferActions(){
    return [
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
          user.removePlayer(this.teamPlayer);
          if (!user.signingUp && ModalRoute.of(context).settings.name != Routes.ChooseTeam) {
            Navigator.pushNamed(context, Routes.ChooseTeam);
          } else {
            Navigator.pop(context);
          }
        },
        child: Text(this.teamPlayer.removed ? 'Restore' : 'Remove'),
      ),
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          Navigator.pop(context);
          PlayerSelectorCard psc = PlayerSelectorCard(outgoingPlayer: this.teamPlayer, context: context);
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
      child: Column(
        children: [
          Checkbox(value: this.player.rank == rank, onChanged: (value) => updateCaptaincy(value, rank)),
          Text(rank)
        ]
      )
    );
  }

  void updateCaptaincy(bool value, String rank) {
    if (!value){
      return;
    }
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    user.updateCaptaincy(this.teamPlayer, rank);
    user.pushTeamToDB();
    Navigator.pop(context);
  }
}
