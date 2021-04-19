import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';

class Gameweek extends ChangeNotifier {
  int _id;
  String _opposition;
  String _gameScore;
  List<PlayerGameweek> _playerGameweeks = [];
  int _currPlayerIndex = 0;
  int _stage = 0;

  Gameweek(List<Player> players) {
    for (int i = 0; i < players.length; i++) {
      this.playerGameweeks.add(PlayerGameweek(players[i]));
    }
  }

  Gameweek.fromData(Map<String, dynamic> data) {
    this.id = data["gw-number"];
    this.gameScore = data["score"];
    this.opposition = data["opposition"];
  }

  Gameweek.singlePlayer(Gameweek gw, PlayerGameweek pgw) {
    this.id = gw.id;
    this.opposition = gw.opposition;
    this.gameScore = gw.gameScore;
    this.playerGameweeks = [pgw];
  }

  Future<void> setTeamGWPts(CollectionReference teamCollection) async {
    await teamCollection.get().then((QuerySnapshot teamPlayerDocs) {
      // Loop over the 6 players in the team
      teamPlayerDocs.docs.asMap().forEach((index, teamPlayerDoc) async {
        // Find the corresponding playerGW for that player]
        try {
          PlayerGameweek pgw = this
              .playerGameweeks
              .singleWhere((pgw) => pgw.id == teamPlayerDoc.get('name'));
          await teamCollection.doc('Player-${index}').set({
            'gw-pts': pgw.gwPts,
          }, SetOptions(merge: true));
        } catch (e) {
          print(
              "Cant find a corresponding pgw for ${teamPlayerDoc.get('name')}");
        }
      });
    });
  }

  Future<void> setCaptainViceGWPts(CollectionReference teamCollection) async {
    // Identify captain/vice captain and check if captain played
    await teamCollection.get().then((QuerySnapshot teamPlayerDocs) async {
      QueryDocumentSnapshot captainDoc;
      QueryDocumentSnapshot viceCaptainDoc;
      if (teamPlayerDocs.docs.length == 6) {
        teamPlayerDocs.docs.asMap().forEach((index, teamPlayerDoc) {
          if (teamPlayerDoc.data()["rank"] == CAPTAIN)
            captainDoc = teamPlayerDoc;
          if (teamPlayerDoc.data()["rank"] == VICE)
            viceCaptainDoc = teamPlayerDoc;
        });
        if (captainDoc == null || viceCaptainDoc == null) {
          print("cant find captains... no bonus for u");
          return;
        }
        PlayerGameweek captainGW = this
            .playerGameweeks
            .singleWhere((pgw) => pgw.id == captainDoc.get('name'));
        PlayerGameweek viceCaptainGW = this
            .playerGameweeks
            .singleWhere((pgw) => pgw.id == viceCaptainDoc.get('name'));

        // Set who is getting the multiplier
        int index = -1;
        PlayerGameweek pgw;
        if (captainGW.appearance) {
          index = teamPlayerDocs.docs.indexWhere((x) => x.id == captainDoc.id);
          pgw = captainGW;
        } else if (viceCaptainGW.appearance) {
          index =
              teamPlayerDocs.docs.indexWhere((x) => x.id == viceCaptainDoc.id);
          pgw = viceCaptainGW;
        } else if (index == -1) {
          // no multiplier appropriate cos no vice/cap played
          return;
        }
        await teamCollection.doc('Player-${index}').set({
          'gw-pts': pgw.gwPts * 2,
        }, SetOptions(merge: true));
      }
    });
  }

  Future<void> setBenchSub(CollectionReference teamCollection) async {
    QuerySnapshot teamPlayerDocs = await teamCollection.get();
    // Check if any player didn't play & check if bench did play and swap those players
    int noShowIndex = -1;
    // Loop over the 6 players in the team
    teamPlayerDocs.docs.asMap().forEach((index, teamPlayerDoc) {
      // Find the corresponding playerGW for that player
      try {
        PlayerGameweek pgw = this
            .playerGameweeks
            .singleWhere((pgw) => pgw.id == teamPlayerDoc.data()['name']);
        if (!pgw.appearance) {
          noShowIndex = index;
        }
        // If above conditional triggered on bench player, can't sub anyway so dw
        if (noShowIndex == 5) {
          noShowIndex = -1;
        }
      } catch (e) {
        print(
            "couldnt find a corr. pgw for a player or player doc is corrupted");
      }
    });

    // Swap bench and noShowIndex players
    if (noShowIndex != -1) {
      QueryDocumentSnapshot bench = teamPlayerDocs.docs[5];
      QueryDocumentSnapshot noShow = teamPlayerDocs.docs[noShowIndex];
      print(noShowIndex);
      await teamCollection.doc('Player-${noShowIndex}').set(
        {
          'name': bench.data()['name'],
          'bought-price': bench.data()['bought-price'],
          'rank': bench.data()['rank'],
          'gw-pts': bench.data()['gw-pts'],
        },
      );
      await teamCollection.doc('Player-5').set(
        {
          'name': noShow.data()['name'],
          'bought-price': noShow.data()['bought-price'],
          'rank': noShow.data()['rank'],
          'gw-pts': noShow.data()['gw-pts'],
        },
      );
    }
  }

  List<PlayerGameweek> get playerGameweeks => _playerGameweeks;

  bool get allPlayersSaved => this.playerGameweeks.every((pgw) => pgw.saved);

  set playerGameweeks(List<PlayerGameweek> value) {
    _playerGameweeks = value;
  }

  String get gameScore => _gameScore;

  set gameScore(String value) {
    _gameScore = value;
  }

  String get opposition => _opposition;

  set opposition(String value) {
    _opposition = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get currPlayerIndex => _currPlayerIndex;

  set currPlayerIndex(int value) {
    _currPlayerIndex = value;
    notifyListeners();
  }

  void saveDataToGWObject(FormBuilderState currentState) {
    PlayerGameweek curr = this.playerGameweeks[this.currPlayerIndex];
    curr.appearance = currentState.value[APPEARANCE] == "Yes";
    if (curr.appearance) {
      curr.position = ifValidReturn(currentState, POSITION, "DEF");
      curr.assists = ifValidReturn(currentState, ASSISTS, 0);
      curr.ownGoals = ifValidReturn(currentState, OWNS, 0);
      curr.penaltiesMissed = ifValidReturn(currentState, PENS, 0);
      curr.goals = ifValidReturn(currentState, GOALS, 0);
      curr.saves = ifValidReturn(currentState, SAVES, 0);
      curr.yellowCards = ifValidReturn(currentState, YELLOW, 0);
      curr.redCards = ifValidReturn(currentState, RED, 0);
      curr.bonus = int.parse(ifValidReturn(currentState, BONUS, "0"));
      setClean(currentState, curr);
      curr.calculatePoints();
    }
    curr.saved = true;
    notifyListeners();
  }

  dynamic ifValidReturn(
      FormBuilderState currentState, String field, dynamic fallback) {
    return currentState.value[field] == null
        ? fallback
        : currentState.value[field];
  }

  void setClean(FormBuilderState currentState, PlayerGameweek curr) {
    // Set all cleans to false;
    curr.fullClean = false;
    curr.halfClean = false;
    curr.quarterClean = false;
    switch (currentState.fields[CLEANS].value) {
      case NO_CLEAN:
        break;
      case QUARTER_CLEAN:
        curr.quarterClean = true;
        break;
      case HALF_CLEAN:
        curr.halfClean = true;
        break;
      case FULL_CLEAN:
        curr.fullClean = true;
        break;
    }
  }

  int get stage => _stage;

  set stage(int value) {
    _stage = value;
    notifyListeners();
  }
}
