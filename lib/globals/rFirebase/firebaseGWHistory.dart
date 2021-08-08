import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/rFirebase/firebasePlayers.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/gameweek.dart';

import 'firebaseUsers.dart';

class FirebaseGWHistory {
  Future<void> addUserGWHistoryToDB(
      QueryDocumentSnapshot doc, int currGw) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user =
        firestore.collection('users').doc(doc.reference.id);
    var hits = doc.data().containsKey('hits') ? doc.data()['hits'] : 0;
    var transfers = doc.data().containsKey('completed-transfers')
        ? doc.data()['completed-transfers']
        : 0;
    var budget = doc.data().containsKey('budget') ? doc.data()['budget'] : 0.0;
    var activeChip = "";
    if (doc.data().containsKey('free-hit') && doc.data()['free-hit'].containsKey('active') && doc.data()['free-hit']['active']) {
      activeChip = 'free-hit';
    }
    if (doc.data().containsKey('wildcard') && doc.data()['wildcard'].containsKey('active') && doc.data()['wildcard']['active']) {
      activeChip = 'wildcard';
    }
    if (doc.data().containsKey('triple-cap') && doc.data()['triple-cap'].containsKey('active') && doc.data()['triple-cap']['active']) {
      activeChip = 'triple-cap';
    }

    DocumentReference gwHistoryDoc =
        user.collection("GW-History").doc("GW-${currGw}");

    // Add misc details
    await gwHistoryDoc.set({
      "gw-pts": 0,
      "total-pts": 0,
      "transfers": transfers,
      "hits": hits,
      "chips-used": activeChip,
      "budget": budget,
    }).catchError((error) => print("Failed to add gw history: $error"));

    if (activeChip != "") {
      FirebaseUsers().activateDeactivateChip(doc.reference.id, activeChip, false);
    }

    // add team details
    CollectionReference submissionTeam = user.collection('Team');
    await FirebaseCore().copyCollection(submissionTeam, gwHistoryDoc);
  }

  Future<void> updateUserGWHistoryInDB(
      QueryDocumentSnapshot doc, Gameweek gw) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user =
        firestore.collection('users').doc(doc.reference.id);
    DocumentReference gwHistoryDoc =
        user.collection("GW-History").doc("GW-${gw.id}");
    CollectionReference teamCollection = gwHistoryDoc.collection('Team');
    print("Updating points for ${doc.reference.id}");

    // Set baseline points
    await gw.setTeamGWPts(teamCollection);
    print("SET TEAM PTS");
    // Check captain/vice captain who gets double points
    DocumentSnapshot gwHistorySnapshot = await gwHistoryDoc.get();
    await gw.setCaptainViceGWPts(teamCollection, gwHistorySnapshot.get("chips-used"));
    print("SET CAP PTS");

    // Check if bench sub is required
    await gw.setBenchSub(teamCollection);
    print("SET BENCH PTS");

    // Pull total points acquired and set the parent with GW and total pts
    teamCollection.get().then((teamPlayerDocs) async {
      int teamGWPts = 0;
      // count points minus bench player
      for (int i = 0; i < 5; i++) {
        try {
          teamGWPts += teamPlayerDocs.docs[i].get('gw-pts');
          print("ADDED ${teamPlayerDocs.docs[i].get('gw-pts')} POINTS");
        } catch (e) {
          print("Team player doc doesnt contain gw-pts");
        }
      }

      // Reduce by hits if required
      int hits = gwHistorySnapshot.get('hits');
      teamGWPts -= (hits * 4);

      int prevTotal = 0;
      try {
        if (gw.id > 1) {
          DocumentSnapshot userDocSnap = await user.get();
          prevTotal = userDocSnap.get("total-pts");
        }
      } catch (e) {
        print("something went wrong, couldnt find a document probs but we caught it");
      }
      int newTotal = prevTotal + teamGWPts;
      // Add misc details
      await gwHistoryDoc.set(
        {
          "gw-pts": teamGWPts,
          "total-pts": newTotal,
        },
        SetOptions(
          merge: true,
        ),
      ).catchError((error) => print("Failed to update gw history: $error"));

      // Update misc details with gw-pts and total-pts
      user.set({
        "gw-pts": teamGWPts,
        "total-pts": newTotal,
      }, SetOptions(merge: true));

      print("GLOBAL SET");

      // If limitless was previously active, revert to previous week
      if (gwHistorySnapshot.get("chips-used") == "free-hit") {
        // reset team
        DocumentReference gwHistoryDoc =
        user.collection("GW-History").doc("GW-${gw.id - 1}");
        CollectionReference oldTeam = gwHistoryDoc.collection('Team');
        await FirebaseCore().copyCollection(oldTeam, user);
        DocumentSnapshot prevGW = await user.collection("GW-History").doc("GW-${gw.id - 1}").get();
        // reset budget
        user.set({
          "budget": prevGW.data().containsKey("budget") ? prevGW.data()["budget"] :  0.0,
        }, SetOptions(merge: true));
      }
    });

    // // add team details
    // CollectionReference submissionTeam = user.collection('Team');
    // await FirebaseCore().copyCollection(submissionTeam, gwHistoryDoc);
  }

  Future<DocumentSnapshot> getUserGWHistory(String gwId, String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("finding resulting");
    return firestore
        .collection('users')
        .doc(uid)
        .collection('GW-History')
        .doc(gwId)
        .get();
  }

  Future<List<UserGW>> getCompleteUserGWHistory(
      String uid, List<Gameweek> globalGWHistory) async {
    List<UserGW> userGWHistory = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("Collecting complete user history 2");
    CollectionReference gwHistoryDB =
        firestore.collection('users').doc(uid).collection('GW-History');
    QuerySnapshot gwSnapshot = await gwHistoryDB.get();
    try {
      for (int i = 0; i < gwSnapshot.docs.length; i++){
        await addUserGWFromGW(gwSnapshot.docs[i], uid, globalGWHistory, gwHistoryDB, userGWHistory);
      }
      return userGWHistory;
    } catch (e) {
      print("Error in finding complete history");
      return userGWHistory;
    }
  }

  Future addUserGWFromGW(QueryDocumentSnapshot gwDoc, String uid, List<Gameweek> globalGWHistory, CollectionReference gwHistoryDB, List<UserGW> userGWHistory) async {
    DocumentSnapshot userGW = await this.getUserGWHistory(gwDoc.id, uid);
    print("Got userGW started for ${gwDoc.id} 4");
    int gwNum = int.parse(gwDoc.id.split('-')[1]);
    Gameweek globalGW = globalGWHistory.length >= gwNum ? globalGWHistory[gwNum-1] : null;
    QuerySnapshot teamQS =
        await gwHistoryDB.doc('GW-${gwNum}').collection('Team').get();
    print("Got team 5");
    
    Team gwTeam = Team.fromDataNoPlayers(teamQS);
    userGWHistory.add(UserGW(
      id: gwNum,
      team: gwTeam,
      gw: globalGW,
      hits: userGW.get('hits'),
      chip: userGW.get('chips-used'),
      points: userGW.get('gw-pts'),
      totalPts: userGW.get('total-pts'),
      completedTransfers: [],
    ));
  }

  Future<void> getGWHistory(
      List<Gameweek> gwHistory, List<Player> players) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gwHistoryDB = firestore.collection('gw-history');
    QuerySnapshot querySnapshot = await gwHistoryDB.get();
    querySnapshot.docs.forEach((doc) {
      gwHistory.add(Gameweek.fromData(doc.data()));
      print("Gameweek ${doc.data()["gw-number"]} added to list 4");
    });
  }

  Future<void> getPlayerGWs(
      List<Gameweek> gwModels, List<Player> players) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    gwModels.forEach((gw) async {
      CollectionReference playerGWs = firestore
          .collection('gw-history')
          .doc('gw-${gw.id}')
          .collection('player-gameweeks');
      QuerySnapshot qs = await playerGWs.get();
      await _populatePlayerGWs(qs, players, gw);
    });
  }

  Future<void> _populatePlayerGWs(
      QuerySnapshot qs, List<Player> players, Gameweek gwModel) {
    qs.docs.forEach((doc) {
      //Obtain correct player
      Player curr = players.firstWhere((p) => p.name == doc.id);
      gwModel.playerGameweeks
          .add(PlayerGameweek.fromData(doc.data(), doc.id, curr));
      curr.gwResults
          .add(Gameweek.singlePlayer(gwModel, gwModel.playerGameweeks.last));
    });
  }

  Future<void> addGW(Gameweek gw) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gwHistoryDB = firestore.collection('gw-history');

    return gwHistoryDB
        .doc("gw-${gw.id}")
        .set({
          'gw-number': gw.id,
          'score': gw.gameScore,
          'opposition': gw.opposition,
        })
        .then((value) => print("GW Added: GW${gw.id}"))
        .catchError((error) => print("Failed to add GW: $error"));
  }

  Future<void> addAllPlayerGWs(Gameweek gw) async {
    for (int i = 0; i < gw.playerGameweeks.length; i++){
      await this.addPlayerGW(gw.playerGameweeks[i], gw.id);
      // copy this pgw into corresponding player
      await FirebasePlayers().addPlayerGW(gw.playerGameweeks[i], gw.id);
    }
  }

  Future<void> addPlayerGW(PlayerGameweek pgw, int gwNumber) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gwHistoryDB = firestore.collection('gw-history');
    return gwHistoryDB
        .doc('gw-${gwNumber}')
        .collection('player-gameweeks')
        .doc(pgw.id)
        .set({
          'appearance': pgw.appearance,
          'position': pgw.position,
          'goals': pgw.goals,
          'assists': pgw.assists,
          'saves': pgw.saves,
          'goals-conceded': pgw.goalsConceded,
          'quarter-clean': pgw.quarterClean,
          'half-clean': pgw.halfClean,
          'full-clean': pgw.fullClean,
          'yellow': pgw.yellowCards,
          'red': pgw.redCards,
          'owns': pgw.ownGoals,
          'pens': pgw.penaltiesMissed,
          'bonus': pgw.bonus,
          'heroism': pgw.heroism,
          'saved': pgw.saved,
          'gw-pts': pgw.gwPts,
          'point-breakdown': pgw.pointBreakdown.toMap(),
        })
        .then((value) => print("Player GW Added: ${pgw.id}"))
        .catchError((error) => print("Failed to add player GW: $error"));
  }
}
