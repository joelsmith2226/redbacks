import 'package:redbacks/models/team_player.dart';

class Transfer {
  TeamPlayer incoming;
  TeamPlayer outgoing;

  Transfer();

  Transfer.fromPlayers({this.incoming, this.outgoing});
}