import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';

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
      onTap: () {
        if (widget.mode == TRANSFER) {
          transferFn();
        } else {
          Navigator.pop(context);
          print("Listtile tapped not in transfer mode");
        }
      },
      leading: Text("${widget.player.position}"),
      title: Text("${widget.player.name}"),
      trailing: Text("${widget.player.price}"),
    );
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
}
