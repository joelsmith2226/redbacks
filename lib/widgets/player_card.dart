import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_selector_card.dart';

class PlayerCard extends StatelessWidget {
  Player player;
  AlertDialog pc;
  BuildContext context;
  String mode;
  VoidCallback callback;

  PlayerCard({this.player, this.context, this.mode, this.callback}) {
    this.pc = AlertDialog(
      title: Text(
        'Player Card',
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.3),
            SizedBox(height: 30),
            Text(
                'Name: ${this.player.name}\nValue: \$${this.player.price}\nTotal Points: ${this.player.totalPts}\n'),
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
      case "points":
        return pointsActions();
      case "pick":
        return pickActions();
      case "money":
        return transferActions();
    }
  }

  List<Widget> pickActions(){
    return [
      MaterialButton(
        textColor: Color(0xFF6200EE),
        onPressed: () {
          LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
          user.benchPlayer(this.player);
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
          user.beginTransfer(this.player);
          Navigator.pop(context);
          // Navigator.pushNamed(context, Routes.Transfer);
          PlayerSelectorCard psc = PlayerSelectorCard(outgoingPlayer: this.player, context: context);
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
}
