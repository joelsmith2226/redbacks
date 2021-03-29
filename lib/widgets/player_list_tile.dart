import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/error_dialog.dart';

class PlayerListTile extends StatefulWidget {
  Player player;
  bool outgoing;

  PlayerListTile({this.player, this.outgoing});

  @override
  _PlayerListTileState createState() => _PlayerListTileState();
}

class _PlayerListTileState extends State<PlayerListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, Routes.ChooseTeam);

        // on error after attempting transfer
        if(!user.completeTransfer(widget.player)){
          ErrorDialog err = ErrorDialog(body: "Couldn't complete transfer", context: context);
          err.displayCard();
        }

      },
      leading: Text("${widget.player.position}"),
      title: Text("${widget.player.name}"),
      trailing: Text("${widget.player.price}"),
    );
  }
}
