import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/playerGameweek.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class RedbacksFirebase {
  // make instance accessible via constructor
  RedbacksFirebase();

  // User management
  User isSignedIn() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<Team> getTeam(String uid, List<Player> players) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);
    return user
        .collection("Team")
        .get()
        .then((QuerySnapshot playerData) => Team.fromData(playerData.docs, players))
        .onError((error, stackTrace) {
      print("Error! ${error}");
      return null;
    });
  }

  // Player Management
  Future<void> addPlayer(Player p) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    // Call the user's CollectionReference to add a new user
    return players
        .add({
          'name': p.name,
          'price': p.price,
          'position': p.position,
          'flagged': p.flagged,
          'transferredIn': p.transferredIn,
          'transferredOut': p.transferredOut,
          'gwPts': p.currPts,
          'totalPts': p.totalPts,
        })
        .then((value) => print("Player Added: ${p.name}"))
        .catchError((error) => print("Failed to add player: $error"));
  }

  Future<void> getPlayers(List<Player> playerModels) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference players = firestore.collection('players');
    print("Going into getPlayers");
    return players.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        playerModels.add(Player.fromData(doc.data(), uid: doc.id));
        print("Player ${doc.data()["name"]} added to list");
      });
    }).onError((error, stackTrace) {
      print("Error in getPlayers: ${error}");
    });
  }

  void addAllPlayers(List<Player> players) {
    players.forEach((p) {
      print("Attempting to add ${p.name}");
      this.addPlayer(p);
    });
  }

  // Pushes the user's current team to the Firebase DB
  Future<void> pushTeamToDB(Team team, String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);
    // First check if the doc already exists then update, otherwise add
    team.players.asMap().forEach((index, player) {
      addPlayerToTeamInDB(player, index, user);
    });
  }

  Future<void> addPlayerToTeamInDB(
      TeamPlayer p, int index, DocumentReference user) {
    return user
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

  Future<void> addUserGWHistoryToDB(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference user = firestore.collection('users').doc(uid);

    return user
        .collection("GW-History")
        .doc("GW-0")
        .set({
          "gw-pts": 0,
          "total-pts": 0,
          "hits-taken": 0,
          "chips-used": "",
        })
        .then((value) => print("GW history added"))
        .catchError((error) => print("Failed to add gw history: $error"));
  }

  Future<void> pushMiscFieldsToDB(
      String uid,
      double budget,
      double teamValue,
      String email,
      int gwPts,
      int totalPts,
      String teamName,
      int freeTransfers) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference user = firestore.collection('users');

    return user
        .doc(uid)
        .set({
          "email": email,
          "budget": budget,
          "team-value": teamValue,
          "gw-pts": gwPts,
          "total-pts": totalPts,
          "team-name": teamName,
          "free-transfers": freeTransfers,
        })
        .then((value) => print("User Misc Details Added: ${uid}"))
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

  // GW History Management

  Future<void> getGWHistory(List<Gameweek> gwHistory, List<Player> players) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gwHistoryDB = firestore.collection('gw-history');
    print("Going into getGWHistory");
    gwHistoryDB.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        gwHistory.add(Gameweek.fromData(doc.data()));
        print("Gameweek ${doc.data()["gw-number"]} added to list");
        return this.getPlayerGWs(gwHistory.last, doc, players);
      });
    }).onError((error, stackTrace) {
      print("Error in getGWHistory: ${error}");
    });
  }

  Future<void> getPlayerGWs(
      Gameweek gwModel, QueryDocumentSnapshot gwDoc, List<Player> players) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference playerGWs = firestore
        .collection('gw-history')
        .doc(gwDoc.id)
        .collection('player-gameweeks');

    playerGWs.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //Obtain correct player
        Player curr = players.firstWhere((p) => p.name == doc.id);
        gwModel.playerGameweeks
            .add(PlayerGameweek.fromData(doc.data(), doc.id, curr));
        curr.gwResults
            .add(Gameweek.singlePlayer(gwModel, gwModel.playerGameweeks.last));
        print("Player GW Added ${doc.id} added to list");
      });
      return;
    }).onError((error, stackTrace) {
      print("Error in getGWHistory: ${error}");
    });
  }

  void addGWToDB(Gameweek gw) {
    this.addGW(gw);
    this.addAllPlayerGWs(gw);
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
          'appearance':gw.appearance,
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
        })
        .then((value) => print("Player GW Added: ${gw.id}"))
        .catchError((error) => print("Failed to add player GW: $error"));
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

  void updateUsersGW(Gameweek gwHistory) {
    // get list of users
    // update user-GW-history with 1) gwpts achieved
  }

  void deadlineButton() {
    // get a list of users
    // create a GW-History with 1) locked in team (with cap/vice)
    // 2) num transfers/hits
    // 3) chips used
    // 4) shift admin curr gameweek ++
  }
}
