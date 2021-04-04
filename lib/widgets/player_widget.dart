import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_card.dart';

class PlayerWidget extends StatefulWidget {
  Player player;
  String mode;
  bool benched = false;
  VoidCallback callback = () => null;

  PlayerWidget(this.player, this.mode, {this.benched = false, this.callback});

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    PlayerCard pc = PlayerCard(player: widget.player, context: context, mode: widget.mode, callback: widget.callback);
    var showPlayerCard = () => pc.displayCard();
    var widthMultiplier = widget.benched ? 0.15 : 0.25;

    return Container(
      child: InkWell(
        onTap: showPlayerCard,
        child: Stack(children: [
          Column(
            children: [
              Image.asset(
                widget.player.name == ""
                    ? "assets/avatar-nobg-unset.png"
                    : "assets/avatar-nobg.png",
                width: MediaQuery
                    .of(context)
                    .size
                    .width * widthMultiplier,
              ),
              NameTag(),
              SecondaryTag(_getSecondaryValue()),
            ],
          ),
          // CaptainsArmband(widget.player.rank),
        ]),
      ),
    );
  }

  Widget NameTag() {
    return Container(
      padding: EdgeInsets.all(1),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "${widget.player.getLastName()}",
          style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: GoogleFonts
                  .merriweatherSans()
                  .fontFamily),
        ),
      ),
      color: Colors.black.withAlpha(180),
      width: MediaQuery
          .of(context)
          .size
          .width * 0.2,
    );
  }

  Widget SecondaryTag(String value) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(1),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: GoogleFonts
                      .merriweatherSans()
                      .fontFamily)),
        ),
        color: Theme
            .of(context)
            .primaryColor
            .withAlpha(150),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.2,
      ),
      color: Colors.black,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.2,
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

  String _getSecondaryValue() {
    switch (widget.mode) {
      case "points":
        return "${widget.player.currPts}pts";
      case "pick":
        return widget.player.position;
      case "money":
        return "\$${widget.player.price}m";
    }
  }
}
