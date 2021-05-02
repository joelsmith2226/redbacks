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
import 'package:sizer/sizer.dart';

class PlayerWidget extends StatefulWidget {
  TeamPlayer teamPlayer;
  Player player;
  String mode;
  bool benched = false;

  PlayerWidget(this.player, this.mode, {this.benched = false});

  PlayerWidget.fromTeamPlayer(this.teamPlayer, this.mode,
      {this.benched = false});

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
      case PRICE:
        return PricePlayer();
      default:
        return PointPickPlayer();
    }
  }

  Widget CarouselPlayer() {
    return FittedBox(
      child: Container(
        child: InkWell(
          child: Column(
            children: [
              Image.asset(
                (widget.player.name == "")
                    ? "assets/avatar-nobg-unset.png"
                    : "assets/avatar-nobg.png",
                width: MediaQuery.of(context).size.width * 0.15,
              ),
              NameTag(),
            ],
          ),
        ),
      ),
    );
  }

  Widget PointPickPlayer() {
    bool smallMode = widget.benched;
    var widthMultiplier = smallMode ? 0.2 : 0.3;
    if (SizerUtil.deviceType == DeviceType.tablet)
      widthMultiplier = smallMode ? 0.15 : 0.2;

    double width = MediaQuery.of(context).size.width * widthMultiplier;
    return Container(
      width: width,
      child: InkWell(
        onTap: showPlayerCardFn(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Aura(
              player: widget.player,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      (widget.teamPlayer.name == "" ||
                              widget.teamPlayer.removed == true)
                          ? "assets/avatar-nobg-unset.png"
                          : "assets/avatar-nobg.png",
                      // fit: BoxFit.scaleDown,
                    ),
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

  Widget PricePlayer() {
    bool smallMode = widget.benched;
    var widthMultiplier = smallMode ? 0.2 : 0.3;
    if (SizerUtil.deviceType == DeviceType.tablet)
      widthMultiplier = smallMode ? 0.15 : 0.2;
    double width = MediaQuery.of(context).size.width * widthMultiplier;
    return Container(
      width: width,
      child: InkWell(
        onTap: showPlayerCardFn(),
        child: Aura(
          teamPlayer: widget.teamPlayer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Image.asset(
                  (widget.teamPlayer.name == "" ||
                          widget.teamPlayer.removed == true)
                      ? "assets/avatar-nobg-unset.png"
                      : "assets/avatar-nobg.png",
                  width: width,
                ),
              ),
              NameTag(),
              SecondaryTag(_getSecondaryValue())
            ],
          ),
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
      );
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.player.getNameTag(),
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: GoogleFonts.merriweatherSans().fontFamily),
          ),
        ),
      ),
      color: Colors.black.withAlpha(180),
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget SecondaryTag(String value) {
    return Container(
      child: Container(
        height: 15,
        padding: EdgeInsets.all(1),
        child: FittedBox(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: GoogleFonts.merriweatherSans().fontFamily)),
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
    if (rank == "") {
      return Container();
    }
    return Positioned(
      right: MediaQuery.of(context).size.width * 0.05,
      bottom: MediaQuery.of(context).size.width * 0.12,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.07,
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
