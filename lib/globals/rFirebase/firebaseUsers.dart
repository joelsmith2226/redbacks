import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/logged_in_user.dart';

import '../constants.dart';

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
            print("User doesnt exist");
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
        .set({}, SetOptions(merge: true))
        .then((value) => print("User Added: ${uid}"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> pushMiscFieldsToDB(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollection = firestore.collection('users');
    List<String> transfersAsStrings = user.completedTransferAsList();
    return userCollection
        .doc(user.uid)
        .set({
          "email": user.email,
          "name": user.name,
          "budget": user.budget,
          "team-value": user.teamValue,
          "gw-pts": user.gwPts,
          "total-pts": user.totalPts,
          "team-name": user.teamName,
          "free-transfers": user.freeTransfers,
          "completed-transfers": transfersAsStrings,
          "hits": user.hits,
          "pre-app-pts": user.preAppPoints,
          "wildcard": user.chips == null ? null : user.chips[0].toMap(),
          "free-hit": user.chips == null ? null : user.chips[1].toMap(),
          "triple-cap": user.chips == null ? null : user.chips[2].toMap(),
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

  Future<void> resetMiscDetailsForNewWeek(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollection = firestore.collection('users');
    DocumentSnapshot userDetails = await userCollection.doc(uid).get();
    int freeTransfers = userDetails.get('free-transfers');

    // Unlimited frees could be triggered on signup or wildcard
    if (freeTransfers == UNLIMITED) {
      freeTransfers = 1;
    }

    return userCollection
        .doc(uid)
        .set({
          "free-transfers": freeTransfers,
          "completed-transfers": [],
          "hits": 0,
        }, SetOptions(merge: true))
        .then((value) => print("Reset misc fields for deadline: ${uid}"))
        .catchError(
            (error) => print("Failed to add user misc details: $error"));
  }

  // GLOBAL ADMIN INFO
  Future<void> getAdminInfo(LoggedInUser user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    DocumentSnapshot docs = await users.doc('admin').get();
    user.currGW = docs.data()["curr-gw"];
    user.patchMode = docs.data()["patch-mode"];
    user.admins = docs.data()["admins"];
    user.deadlineTime = docs.data()["deadline-time"] ?? "1pm";
  }

  Future<void> pushAdminCurrGW(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return users.doc('admin').set(
      {
        "curr-gw": user.currGW,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> pushPatchMode(LoggedInUser user) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return users.doc('admin').set(
      {
        "patch-mode": user.patchMode,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> resetChips(bool wc, bool tc, bool fh) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    QuerySnapshot userList = await users.get();
    for (int i = 0; i < userList.docs.length; i++) {
      if (userList.docs[i].id != 'admin') if (wc) {
        setChip(userList, i, 0, "Wildcard");
      }
      if (fh) {
        setChip(userList, i, 1, "Free Hit");
      }
      if (tc) {
        setChip(userList, i, 2, "Triple Cap");
      }
    }
  }

  void setChip(QuerySnapshot userList, int i, int chipIndex, String name) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(userList.docs[i].id).set({
      name: {
        "active": false,
        "available": true,
      }
    }, SetOptions(merge: true));
  }

  void activateDeactivateChip(String uid, String name, bool activeStatus) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(uid).set({
      name: {
        "active": activeStatus,
      }
    }, SetOptions(merge: true));
  }

  void availableUnavailableChip(String uid, String name, bool availableStatus) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(uid).set({
      name: {
        "available": availableStatus,
      }
    }, SetOptions(merge: true));
  }

  Future<void> calculateTotalsWithPreapp() async {
    // for every user
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    QuerySnapshot userList = await users.get();
    for (int i = 0; i < userList.docs.length; i++) {
      if (userList.docs[i].id != 'admin') {
        DocumentSnapshot currUser =
            await firestore.collection('users').doc(userList.docs[i].id).get();
        // get pre app pts
        int totalPts = currUser.data()['pre-app-pts'] ?? 0;
        // get each gw pts
        totalPts += await totalPtsFromGWforUser(currUser.id);
        // calculate new total and save to db
        firestore.collection('users').doc(userList.docs[i].id).set({
          'total-pts': totalPts,
        }, SetOptions(merge: true));
      }
    }
  }

  Future<int> totalPtsFromGWforUser(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot gws = await firestore
        .collection('users')
        .doc(uid)
        .collection('GW-History')
        .get();
    int totalPtsFromGWs = 0;
    for (int i = 0; i < gws.docs.length; i++) {
      totalPtsFromGWs += gws.docs[i].data()['gw-pts'] ?? 0;
    }
    return totalPtsFromGWs;
  }
}
