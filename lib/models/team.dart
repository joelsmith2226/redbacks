import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/models/transfer.dart';

class Team {
  List<TeamPlayer> _players;

  Team(this._players);

  Team.blank() {
    this._players = [
      TeamPlayer.blank(0),
      TeamPlayer.blank(1),
      TeamPlayer.blank(2),
      TeamPlayer.blank(3),
      TeamPlayer.blank(4),
      TeamPlayer.blank(5),
    ];
  }

  Team.fromData(teamData, List<Player> players) {
    this.players = [];
    teamData.forEach((playerData) {
      Player p = players.firstWhere((p) => p.name == playerData.data()["name"]);
      this
          .players
          .add(TeamPlayer.fromData(playerData.data(), p, this.players.length));
    });
  }

  Team.fromDataNoPlayers(QuerySnapshot teamData) {
    this.players = [];
    teamData.docs
        .asMap()
        .forEach((int index, QueryDocumentSnapshot playerData) {
      this.players.add(TeamPlayer.fromDataNoPlayer(playerData.data(), index));
    });
  }

  String transfer(Transfer pendingTransfer) {
    try {
      TeamPlayer incoming = pendingTransfer.incoming;
      TeamPlayer outgoing = pendingTransfer.outgoing;
      if (outgoing.index == null) {
        return "Player doesn't exist"; // something went wrong, player doesn't exist
      } else {
        incoming.index = outgoing.index;
        this._players[outgoing.index] = incoming;
        incoming.inConsideration = true;
        return "";
      }
    } catch (e) {
      return "${e}";
    }
  }

  double teamValue() {
    double value = 0;
    this.players.forEach((player) {
      value += player.currPrice;
    });

    return value;
  }

  List<TeamPlayer> get players => _players;

  set players(List<TeamPlayer> value) {
    _players = value;
  }

  bool isComplete() {
    return this.players.every((p) => !p.removed);
  }

  void benchPlayer(TeamPlayer benchwarmer) {
    int index =
        this.players.indexWhere((player) => player.name == benchwarmer.name);
    this.players[index] = this.players[5];
    this.players[5] = benchwarmer;
  }

  // Checks a captain and vice cap have been set, otherwise defaults.
  void checkCaptain() {
    int vice = -1;
    int cap = -1;
    this.players.forEach((player) {
      if (player.rank == VICE) {
        vice = vice == -1 ? this.players.indexOf(player) : 5;
      } else if (player.rank == CAPTAIN) {
        cap = cap == -1 ? this.players.indexOf(player) : 5;
      }
    });

    // If none set or bench player is cap/vice, randomly select cap/vice
    List<int> badIndexes = [-1, 5];
    if (badIndexes.contains(vice)) {
      vice = cap == 0 ? 1 : 0; // sets vice to 0 if cap not 0
    }

    if (badIndexes.contains(cap)) {
      cap = vice == 0 ? 1 : 0; // sets vice to 0 if cap not 0
    }

    // Ensure cap/vice set
    this.players[cap].rank = CAPTAIN;
    this.players[vice].rank = VICE;

    // Resets all other ranks
    this.players.asMap().forEach((index, player) {
      if (![cap, vice].contains(index)) player.rank = '';
    });
  }

  void updateCaptaincy(TeamPlayer updatePlayer, String rank) {
    if (updatePlayer.rank == CAPTAIN && rank == VICE) {
      // switch captain/vice
      TeamPlayer oldVice =
          this.players.firstWhere((player) => player.rank == VICE);
      oldVice.rank = CAPTAIN;
    } else if (updatePlayer.rank == VICE && rank == CAPTAIN) {
      // switch captain/vice
      TeamPlayer oldCap =
          this.players.firstWhere((player) => player.rank == CAPTAIN);
      oldCap.rank = VICE;
    } else {
      // find current captain/vice. Remove rank. Update current
      TeamPlayer oldCap =
          this.players.firstWhere((player) => player.rank == rank);
      oldCap.rank = "";
    }
    TeamPlayer newCap =
        this.players.firstWhere((player) => player.name == updatePlayer.name);
    newCap.rank = rank;
  }

  double removalBudget() {
    double removalBudget = 0.0;
    this.players.forEach((p) {
      if (p.removed) {
        removalBudget += p.currPrice;
      }
    });
    return removalBudget;
  }

  double teamPoints() {
    double teamPoints = 0;
    this.players.forEach((p) {
      teamPoints += p.currPts;
    });
    return teamPoints;
  }
}
