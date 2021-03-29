import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_selector_card.dart';

class PlayerCard {
  Player player;
  AlertDialog pc;
  BuildContext context;

  PlayerCard({this.player, this.context}) {
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
      actions: [
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
      ],
    );
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
