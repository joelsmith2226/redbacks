import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_card.dart';

class PlayerWidget extends StatefulWidget {
  Player player;

  PlayerWidget(this.player);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    PlayerCard pc = PlayerCard(player: widget.player, context: context);
    var showPlayerCard = () => pc.displayCard();
    return Container(
      child: InkWell(
        onTap: showPlayerCard,
        child: Column(
          children: [
            Image.asset("assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.3),
            Container(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "${widget.player.currPts}",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.2,
            )
          ],
        ),
      ),
    );
  }
}
