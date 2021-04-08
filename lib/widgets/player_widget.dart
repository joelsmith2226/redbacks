import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/globals/constants.dart';
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
    switch (widget.mode) {
      case CAROUSEL:
        return CarouselPlayer();
      default:
        return PointPricePickPlayer();
    }
  }

  Widget CarouselPlayer() {
    return Container(
      child: InkWell(
        child: Column(
          children: [
            Image.asset(
              "assets/avatar-nobg.png",
              width: MediaQuery.of(context).size.width * 0.15,
            ),
            NameTag(),
          ],
        ),
      ),
    );
  }

  Widget PointPricePickPlayer() {
    PlayerCard pc = PlayerCard(
        player: widget.player,
        context: context,
        mode: widget.mode,
        callback: widget.callback);
    var showPlayerCard = () => pc.displayCard();
    bool smallMode = widget.benched || widget.mode == CAROUSEL;
    var widthMultiplier = smallMode ? 0.15 : 0.25;

    return Container(
      child: InkWell(
        onTap: widget.mode != CAROUSEL ? showPlayerCard : null,
        child: Stack(alignment: Alignment.center, children: [
          Column(
            children: [
              Image.asset(
                (widget.player.name == "" || widget.player.removed == true)
                    ? "assets/avatar-nobg-unset.png"
                    : "assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * widthMultiplier,
              ),
              NameTag(),
              widget.mode != CAROUSEL
                  ? SecondaryTag(_getSecondaryValue())
                  : Container(),
            ],
          ),
          CaptainsArmband(widget.player.rank),
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
              fontFamily: GoogleFonts.merriweatherSans().fontFamily),
        ),
      ),
      color: Colors.black.withAlpha(180),
      width: MediaQuery.of(context).size.width * 0.2,
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
                  fontFamily: GoogleFonts.merriweatherSans().fontFamily)),
        ),
        color: Theme.of(context).primaryColor.withAlpha(150),
        width: MediaQuery.of(context).size.width * 0.2,
      ),
      color: Colors.black,
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget CaptainsArmband(String rank) {
    if (rank == "") {
      return Container();
    }
    return Positioned(
      right: 1,
      bottom: 40,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.08,
        child: Image.asset(
          widget.player.rank == CAPTAIN
              ? "assets/captain.png"
              : "assets/vice.png",
          alignment: Alignment.bottomRight,
        ),
      ),
    );
  }

  String _getSecondaryValue() {
    switch (widget.mode) {
      case POINTS:
        return "${widget.player.currPts}pts";
      case PICK:
        return widget.player.position;
      case PRICE:
        return "\$${widget.player.price}m";
    }
  }
}
