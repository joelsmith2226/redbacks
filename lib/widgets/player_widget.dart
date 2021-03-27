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
        child: Stack(children: [
          Column(
            children: [
              Image.asset(
                "assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              NameTag(),
              PointsTag(),
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
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      color: Colors.black.withAlpha(150),
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget PointsTag() {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "${widget.player.currPts}",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      color: Colors.black.withAlpha(100),
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget CaptainsArmband(String rank){
    print(rank);
    // if (rank == "") {
    //   return Container();
    // }
    return Container(
      width:100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black
      ),
      // child: Text(rank, style: TextStyle(color: Colors.white)),
    );
  }
}
