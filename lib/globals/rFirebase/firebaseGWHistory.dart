import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/providers/gameweek.dart';

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
    DocumentReference gwHistoryDoc =
        user.collection("GW-History").doc("GW-${currGw}");

    // Add misc details
    await gwHistoryDoc.set({
      "gw-pts": 0,
      "total-pts": 0,
      "transfers": transfers,
      "hits": hits,
      "chips-used": "",
    }).catchError((error) => print("Failed to add gw history: $error"));

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

    // Set baseline points
    await gw.setTeamGWPts(teamCollection);
    print("SET TEAM PTS");
    // Check captain/vice captain who gets double points
    await gw.setCaptainViceGWPts(teamCollection);
    print("SET CAP PTS");

    // Check if bench sub is required
    await gw.setBenchSub(teamCollection);
    print("SET BENCH PTS");

    // Pull total points acquired and set the parent with GW and total pts
    teamCollection.get().then((teamPlayerDocs) async {
      int teamGWPts = 0;
      // count points minus bench player
      for (int i = 0; i < 5; i++){
        teamGWPts += teamPlayerDocs.docs[i].get('gw-pts');
        print("ADDED ${teamPlayerDocs.docs[i].get('gw-pts')} POINTS");
      }

      // Reduce by hits if required
      DocumentSnapshot gwHistorySnapshot = await gwHistoryDoc.get();
      int hits = gwHistorySnapshot.get('hits');
      teamGWPts -= (hits * 4);

      int prevTotal = 0;
      if (gw.id > 1) {
        DocumentSnapshot prevGWHistory =
            await getUserGWHistory(gw.id - 1, doc.reference.id);
        prevTotal = prevGWHistory.get("total-pts");
      }
      int newTotal = prevTotal + teamGWPts;
      // Add misc details
      await gwHistoryDoc.set(
        {
          "gw-pts": teamGWPts,
          "total-pts": newTotal,
        },
        SetOptions(merge: true,),
      ).catchError((error) => print("Failed to update gw history: $error"));
      print("GLOBAL SET");
    });


    // // add team details
    // CollectionReference submissionTeam = user.collection('Team');
    // await FirebaseCore().copyCollection(submissionTeam, gwHistoryDoc);
  }

  Future<DocumentSnapshot> getUserGWHistory(int gwId, String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('GW-History')
        .doc('GW-${gwId}')
        .get();
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
    CollectionReference playerGWs = firestore
        .collection('gw-history')
        .doc('gw-${gwModels[0].id}')
        .collection('player-gameweeks');
    QuerySnapshot qs = await playerGWs.get();
    await _populatePlayerGWs(qs, players, gwModels[0]);
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
      print("Player GW Added ${doc.id} added to list");
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

  void addAllPlayerGWs(Gameweek gw) {
    gw.playerGameweeks.forEach((pgw) {
      this.addPlayerGW(pgw, gw.id);
    });
  }

  Future<void> addPlayerGW(PlayerGameweek gw, int gwNumber) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gwHistoryDB = firestore.collection('gw-history');
    return gwHistoryDB
        .doc('gw-${gwNumber}')
        .collection('player-gameweeks')
        .doc(gw.id)
        .set({
          'appearance': gw.appearance,
          'position': gw.position,
          'goals': gw.goals,
          'assists': gw.assists,
          'saves': gw.saves,
          'goals-conceded': gw.goalsConceded,
          'quarter-clean': gw.quarterClean,
          'half-clean': gw.halfClean,
          'full-clean': gw.fullClean,
          'yellow': gw.yellowCards,
          'red': gw.redCards,
          'owns': gw.ownGoals,
          'pens': gw.penaltiesMissed,
          'bonus': gw.bonus,
          'saved': gw.saved,
          'gw-pts': gw.gwPts,
          'point-breakdown': gw.pointBreakdown.toMap(),
        })
        .then((value) => print("Player GW Added: ${gw.id}"))
        .catchError((error) => print("Failed to add player GW: $error"));
  }
}
