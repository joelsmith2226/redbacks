import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_card.dart';

class PlayerWidget extends StatefulWidget {
  Player player;
  String secondaryValue;

  PlayerWidget(this.player, this.secondaryValue);

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
        child: Stack(children: [
          Column(
            children: [
              Image.asset(
                "assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              NameTag(),
              SecondaryTag(widget.secondaryValue),
            ],
          ),
          CaptainsArmband(widget.player.rank),
        ]),
      ),
    );
  }

  Widget NameTag() {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "${widget.player.getLastName()}",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      color: Colors.black.withAlpha(180),
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget SecondaryTag(String value) {
    return Container(
      child: Container(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: value,
            style: TextStyle(fontSize: 14, color: Colors.white)
          ),
        ),
        color: Theme.of(context).primaryColor.withAlpha(150),
        width: MediaQuery.of(context).size.width * 0.2,
      ),
      color: Colors.black,
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget CaptainsArmband(String rank) {
    print(rank);
    // if (rank == "") {
    //   return Container();
    // }
    return Container(
      width: 100,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      // child: Text(rank, style: TextStyle(color: Colors.white)),
    );
  }
}
