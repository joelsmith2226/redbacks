import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class FirebaseUsers {
  // Pushes the user's current team to the Firebase DB
  Future<void> pushTeamToDB(Team team, String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);
    // First check if the doc already exists then update, otherwise add
    team.players.asMap().forEach((index, player) {
      addPlayerToTeamInDB(player, index, user);
    });
  }

  Future<Team> getTeam(String uid, List<Player> players) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);
    return user
        .collection("Team")
        .get()
        .then((QuerySnapshot playerData) =>
            Team.fromData(playerData.docs, players))
        .onError((error, stackTrace) {
      print("Error! ${error}");
      return null;
    });
  }

  Future<void> addPlayerToTeamInDB(
      TeamPlayer p, int index, DocumentReference doc) {
    return doc
        .collection("Team")
        .doc("Player-${index}")
        .set({
          'name': p.name,
          'bought-price': p.boughtPrice,
          'rank': p.rank,
        })
        .then((value) => print("Team Updated with player ${p.name}"))
        .catchError((error) => print("Failed to update team: $error"));
  }

  //---- Manage USERS ----//

  Future<void> checkUserInDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    // add a new user if the user is not in users
    return users
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) {
          if (!doc.exists) {
            addUserToDB(uid);
          }
        })
        .then((value) => print("User SOrted out: ${uid}"))
        .catchError((error) => print("Failed to sort out user: $error"));
  }

  Future<void> addUserToDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return users
        .doc(uid)
        .set({})
        .then((value) => print("User Added: ${uid}"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> pushMiscFieldsToDB(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollection = firestore.collection('users');

    return userCollection
        .doc(user.uid)
        .set({
      "email": user.email,
      "budget": user.budget,
      "team-value": user.teamValue,
      "gw-pts": user.gwPts,
      "total-pts": user.totalPts,
      "team-name": user.teamName,
      "free-transfers": user.freeTransfers,
      "completed-transfers": user.completedTransferAsList(),
      "hits": user.hits,
    })
        .then((value) => print("User Misc Details Added: ${user.uid}"))
        .catchError(
            (error) => print("Failed to add user misc details: $error"));
  }

  Future<DocumentSnapshot> getMiscDetails(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference user = firestore.collection('users');

    return user.doc(uid).get().then((data) {
      return data;
    }).catchError((error) => print("Failed to add user misc details: $error"));
  }

  // GLOBAL ADMIN INFO
  Future<void> getAdminInfo(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return users.doc('admin').get().then((DocumentSnapshot docs) {
      user.currGW = docs.data()["curr-gw"];
    }).onError((error, stackTrace) {
      print("Error in getting admin data: ${error}");
    });
  }

  Future<void> pushAdminInfo(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return users.doc('admin').set(
        {
          "curr-gw": user.currGW,
        }
    );
  }

}
