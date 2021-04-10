import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/models/original_models.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/providers/gameweek.dart';

class LoggedInUser extends ChangeNotifier {
  String _email;
  String _pwd = ""; // don't think we can access this
  String _uid;
  String _teamName;
  bool _admin;
  Team _team;
  int _totalPts;
  int _gwPts;
  List<Transfer> _pendingTransfers = [];
  double _teamValue;
  double _budget;
  List<Player> _playerDB;
  bool _signingUp = false;
  int _freeTransfers;
  List<Gameweek> _gwHistory;
  OriginalModels _originalModels;
  int _currGW;

  LoggedInUser();

  // Checks if user already logged in, then loads all appropriate details from DB

  Future<void> initialiseUser() async {
    print("SIGNING UP VALUE: ${this.signingUp}");
    this.signingUp
        ? initialiseUserSignup(teamName)
        : initialiseUserLogin().whenComplete(() => null);
  }

  Future<void> initialiseUserLogin() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      this.email = user.email;
      this.uid = user.uid;
      this.admin = admins.contains(this.email);
      this.pendingTransfer = []; //Resets any residual transfers
      RedbacksFirebase().getTeam(this.uid, this.playerDB).then((Team t) {
        this.calculatePoints();
        print("Team is sorted");
        this.team = t;
        //this.calculateTeamValue();
        return RedbacksFirebase()
            .getMiscDetails(this.uid)
            .then((DocumentSnapshot data) {
          this.loadMiscDetailsFromDB(data);
          print(
              "Loaded user successfully ${this.uid}. Should proceed to home page");
          this.signingUp = false; // safety ensured check
          this.team.checkCaptain();
          notifyListeners();
        });
      });
    } else {
      print('User is currently signed out! Continue with login');
    }
  }

// Initialises the user once signup is finalised
  void initialiseUserSignup(String teamName) {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      this.email = user.email;
      this.uid = user.uid;
      this.admin = admins.contains(this.email);
      this.teamName = teamName;
      this.gwPts = 0;
      this.totalPts = 0;
      this.freeTransfers = 100;
      this.pendingTransfer = []; //Resets any residual transfers
      this.setInitialTeam();
      //this.calculateTeamValue();

      // push all details to DB now set
      this.userDetailsPushDB();
      print("User is all signed up and sent to DB ${this.uid}");
    } else {
      print(
          'User isn\'t signed in. Hopefully something went wrong that\'s fixable');
    }
  }

  void setInitialTeam() {
    this.team = Team.blank();
    this.budget = 100.0;
  }

  void beginTransfer(TeamPlayer outgoing) {
    this.pendingTransfer.add(Transfer());
    this.pendingTransfer.last.outgoing = outgoing;
  }

  String completeTransfer(TeamPlayer outgoing, TeamPlayer incoming) {
    try {
      Transfer currTransfer =
          this.pendingTransfer.firstWhere((t) => (t.outgoing == outgoing));
      currTransfer.incoming = incoming;
      String result = this.adjustBudget(currTransfer);
      if (result == "") {
        result = this.team.transfer(currTransfer);
        //Remove pending transfer regardless of outcome
        this.pendingTransfer.remove(currTransfer);
        if (result == "") {
          notifyListeners();
          return result;
        }
      }
      return "${result}";
    } catch (e) {
      return "${e}";
    }
  }

// Checks if user can afford to make the pending transfer
// Assumes only runs after confirming that both players are viable
// for transfer
  String adjustBudget(Transfer currTransfer) {
    TeamPlayer incoming = currTransfer.incoming;
    TeamPlayer outgoing = currTransfer.outgoing;
    this.budget -= incoming.boughtPrice;
    this.budget += outgoing.currPrice;
    return "";
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void calculateTeamValue() {
    this.teamValue = this.team.teamValue(); // todo seems bad style
  }

  Future<void> loadInPlayerAndGWHistoryDB() async {
    this.playerDB = [];
    await RedbacksFirebase().getPlayers(this.playerDB);
    await this.loadInGWHistory();
    return;
  }

  void loadInGWHistory() {
    this.gwHistory = [];
    print(
        "SO Player db SHOULD be done at this point... players: ${this.playerDB.length}");
    RedbacksFirebase().getGWHistory(this.gwHistory, this.playerDB);
  }

  void userDetailsPushDB() {
    // new user in users if needed
    try {
      RedbacksFirebase().checkUserInDB(this.uid);
      // new gw history in users/{user}/gw history if needed
      RedbacksFirebase().addUserGWHistoryToDB(this.uid);
      // // new/update team in users/{user}/team
      RedbacksFirebase().pushTeamToDB(this.team, this.uid);
      // // new/update other fields required to track
      RedbacksFirebase().pushMiscFieldsToDB(
          this.uid,
          this.budget,
          this.teamValue,
          this.email,
          this.gwPts,
          this.totalPts,
          this.teamName,
          this.freeTransfers);
    } catch (e) {
      print("Error in pushing details to DB: ${e}");
    }
  }

  void pushTeamToDB() {
    RedbacksFirebase().pushTeamToDB(this.team, this.uid);
  }

// GETTERS & SETTERS
  int get gwPts => _gwPts;

  set gwPts(int value) {
    _gwPts = value;
  }

  int get totalPts => _totalPts;

  set totalPts(int value) {
    _totalPts = value;
  }

  Team get team => _team;

  set team(Team value) {
    _team = value;
  }

  bool get admin => _admin;

  set admin(bool value) {
    _admin = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get pwd => _pwd;

  set pwd(String value) {
    _pwd = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  List<Transfer> get pendingTransfer => _pendingTransfers;

  set pendingTransfer(List<Transfer> value) {
    _pendingTransfers = value;
  }

  double get budget => _budget;

  set budget(double value) {
    _budget = value;
  }

  double get teamValue => _teamValue;

  set teamValue(double value) {
    _teamValue = value;
  }

  List<Player> get playerDB => _playerDB;

  set playerDB(List<Player> value) {
    _playerDB = value;
  }

  String get teamName => _teamName;

  set teamName(String value) {
    _teamName = value;
  }

  bool get signingUp => _signingUp;

  set signingUp(bool value) {
    _signingUp = value;
  }

  void loadMiscDetailsFromDB(DocumentSnapshot data) {
    this.totalPts = data.get("total-pts");
    this.gwPts = data.get("gw-pts");
    this.teamName = data.get("team-name");
    this.budget = data.get("budget");
    this.freeTransfers = data.get("free-transfers");
  }

  void benchPlayer(TeamPlayer player) {
    this.team.benchPlayer(player);
    notifyListeners();
  }

  void updateCaptaincy(TeamPlayer player, String rank) {
    this.team.updateCaptaincy(player, rank);
    RedbacksFirebase().pushTeamToDB(team, uid);
    notifyListeners();
  }

  void removePlayer(TeamPlayer player) {
    player.removed = !player.removed;
    print("Removed ${player.name}");
    notifyListeners();
  }

  void resetRemovedPlayers() {
    print("Reinstating removed players");
    this.team.players.forEach((element) {
      element.removed = false;
    });
  }

  int get freeTransfers => _freeTransfers;

  set freeTransfers(int value) {
    _freeTransfers = value;
  }

  List<Gameweek> get gwHistory => _gwHistory;

  set gwHistory(List<Gameweek> value) {
    _gwHistory = value;
  }

  List<Transfer> get pendingTransfers => _pendingTransfers;

  set pendingTransfers(List<Transfer> value) {
    _pendingTransfers = value;
  }

  OriginalModels get originalModels => _originalModels;

  set originalModels(OriginalModels value) {
    _originalModels = value;
  }

  void restoreOriginals() {
    this.team = this.originalModels.team;
    this.budget = this.originalModels.budget;
    this.freeTransfers = this.originalModels.freeTransfers;
  }

  int get currGW => _currGW;

  set currGW(int value) {
    _currGW = value;
  }

  void getAdminInfo() {
    RedbacksFirebase().getAdminInfo(this);
  }

  void calculatePoints() {
    this.totalPts = 0;
    this.playerDB.forEach((p) {
      p.currPts = p.gwResults[this.currGW-1].playerGameweeks[0].gwPts;
      p.gwResults.forEach((gw) {
        print(gw.playerGameweeks[0].gwPts);
        // if (gw.id <= this.currGW) p.totalPts += gw.playerGameweeks[0].gwPts;
      });
    });
  }
}
