import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/flag.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_card.dart';

class PlayerListTile extends StatelessWidget {
  Player player;
  TeamPlayer outgoing;
  String mode;
  BuildContext context;

  PlayerListTile({this.player, this.outgoing, this.mode = TRANSFER});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          switch (this.mode) {
            case TRANSFER:
              transferFn();
              break;
            case PLAYERSTATS:
              playerStatsFn();
              break;
            default:
          }
        },
        title: columns());
  }

  void transferFn() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    Navigator.pop(context);
    // on error after attempting transfer
    user.beginTransfer(this.outgoing);
    String result = user.completeTransfer(
        this.outgoing, TeamPlayer.fromPlayer(this.player, this.outgoing.index));
    print(
        "Transfer was attempted and now removed: length - ${user.pendingTransfer.length}");
    if (result != "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Transfer fail: ${result}")));
    } else if (!user.signingUp &&
        ModalRoute.of(context).settings.name != Routes.ChooseTeam) {
      //Pushes to choose team if required otherwise it doesnt
      bool isNewRouteSameAsCurrent = false;
      Navigator.popUntil(context, (route) {
        if (route.settings.name == Routes.ChooseTeam) {
          isNewRouteSameAsCurrent = true;
        }
        return true;
      });
      if (!isNewRouteSameAsCurrent) {
        Navigator.pushNamed(context, Routes.ChooseTeam);
      }
    }
  }

  void playerStatsFn() {
    PlayerCard pc =
        PlayerCard(player: this.player, context: context, mode: this.mode);
    pc.displayCard();
  }

  Widget columns() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withAlpha(100),
        ),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          columnCell(this.player.position, 0.1),
          columnCell(this.player.name, 0.28, showFlag: true),
          columnCell("\$${this.player.price}m", 0.15),
          columnCell("${this.player.currPts}pts", 0.15),
          columnCell("${this.player.totalPts}pts", 0.15),
          columnCell("${this.player.transferredIn}", 0.1),
          columnCell("${this.player.transferredOut}", 0.1),
        ],
      ),
    );
  }

  Widget columnCell(String value, double width, {bool showFlag = false}) {
    Flag f = this.player.flag;
    TextStyle t = TextStyle(color: Colors.black);
    Color c = Colors.white;
    if (f != null && showFlag) {
      c = f.severity == 1 ? Colors.amber : Colors.red;
      t = TextStyle(color: Colors.white);
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * width,
      color: c,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(value,
            textAlign: TextAlign.center, textScaleFactor: 0.8, style: t),
      ),
    );
  }
}

class CategoryListTile extends StatelessWidget {
  BuildContext context;
  Function onTap;
  String currCategory;
  bool ascending;

  CategoryListTile(this.onTap, this.currCategory, this.ascending);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      child: categoryColumns(),
    );
  }

  Widget categoryColumns() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(
          color: Colors.black.withAlpha(100),
        ),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categoryColumnCell("Pos", 0.1),
          categoryColumnCell("Name", 0.28),
          categoryColumnCell("Price", 0.15),
          categoryColumnCell("GW Pts", 0.15),
          categoryColumnCell("Total Pts", 0.15),
          categoryColumnCell("In", 0.1),
          categoryColumnCell("Out", 0.1),
        ],
      ),
    );
  }

  Widget categoryColumnCell(String value, double width) {
    return InkWell(
      onTap: () => this.onTap(value),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * width,
        child: RichText(
          text: TextSpan(
            text: value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: this.currCategory == value
                    ? Icon(
                        this.ascending
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    : Container(),
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
