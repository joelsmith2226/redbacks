import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_card.dart';

class PlayerListTile extends StatefulWidget {
  Player player;
  TeamPlayer outgoing;
  String mode;

  PlayerListTile({this.player, this.outgoing, this.mode = TRANSFER});

  @override
  _PlayerListTileState createState() => _PlayerListTileState();
}

class _PlayerListTileState extends State<PlayerListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          switch (widget.mode) {
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
    user.beginTransfer(widget.outgoing);
    String result = user.completeTransfer(widget.outgoing,
        TeamPlayer.fromPlayer(widget.player, widget.outgoing.index));
    print(
        "Transfer was attempted and now removed: length - ${user.pendingTransfer.length}");
    if (result != "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Transfer fail: ${result}")));
    } else if (!user.signingUp &&
        ModalRoute.of(context).settings.name != Routes.ChooseTeam) {
      Navigator.pushNamed(context, Routes.ChooseTeam);
    }
  }

  void playerStatsFn() {
    PlayerCard pc =
        PlayerCard(player: widget.player, context: context, mode: widget.mode);
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
          columnCell(widget.player.position, 0.1),
          columnCell(widget.player.name, 0.28),
          columnCell("\$${widget.player.price}m", 0.15),
          columnCell("${widget.player.currPts}pts", 0.15),
          columnCell("${widget.player.totalPts}pts", 0.15),
          columnCell("${widget.player.transferredIn}", 0.1),
          columnCell("${widget.player.transferredOut}", 0.1),
        ],
      ),
    );
  }

  Widget columnCell(String value, double width) {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width * width,
      child: Text(
        value,
        textAlign: TextAlign.center,
        textScaleFactor: 0.8,
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
