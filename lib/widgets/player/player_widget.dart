import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/aura.dart';
import 'package:redbacks/widgets/player/player_card.dart';
import 'package:redbacks/widgets/player/player_selector_card.dart';

class PlayerWidget extends StatefulWidget {
  TeamPlayer teamPlayer;
  Player player;
  String mode;
  bool benched = false;
  VoidCallback callback = () => null;

  PlayerWidget(this.player, this.mode, {this.benched = false, this.callback});

  PlayerWidget.fromTeamPlayer(this.teamPlayer, this.mode,
      {this.benched = false, this.callback});

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.player == null) {
      LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
      widget.player = widget.teamPlayer.playerFromTeamPlayer(user.playerDB);
    }
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
    bool smallMode = widget.benched;
    var widthMultiplier = smallMode ? 0.15 : 0.25;
    double width = MediaQuery.of(context).size.width * widthMultiplier;
    return Container(
      child: InkWell(
        onTap: showPlayerCardFn(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Aura(
              teamPlayer: widget.teamPlayer,
              child: Column(
                children: [
                  Image.asset(
                    (widget.teamPlayer.name == "" ||
                            widget.teamPlayer.removed == true)
                        ? "assets/avatar-nobg-unset.png"
                        : "assets/avatar-nobg.png",
                    width: width,
                  ),
                  NameTag(),
                  SecondaryTag(_getSecondaryValue())
                ],
              ),
            ),
            widget.mode == PRICE
                ? Container()
                : CaptainsArmband(widget.teamPlayer.rank),
          ],
        ),
      ),
    );
  }

  Function showPlayerCardFn() {
    if (widget.teamPlayer.name != "") {
      PlayerCard pc = PlayerCard(
          player: widget.player,
          teamPlayer: widget.teamPlayer,
          context: context,
          mode: widget.mode,
          callback: widget.callback);
      return () => pc.displayCard();
    } else {
      PlayerSelectorCard psc = PlayerSelectorCard(
          outgoingPlayer: widget.teamPlayer, context: context);
      return () => psc.displayCard();
    }
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
          widget.teamPlayer.rank == CAPTAIN
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
        return "${widget.teamPlayer.currPts}pts";
      case PICK:
        return widget.player.position;
      case PRICE:
        return "\$${widget.player.price}m";
    }
  }
}
