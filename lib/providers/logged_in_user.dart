import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/rFirebase/firebaseGWHistory.dart';
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
  List<Transfer> _completedTransfers = [];

  double _teamValue;
  double _budget;
  List<Player> _playerDB;
  bool _signingUp = false;
  int _freeTransfers;
  List<Gameweek> _gwHistory;
  OriginalModels _originalModels;
  int _currGW;
  int _hits;
  List<Chip> _chips = [];

  LoggedInUser();

  ///------ INITIALISATION METHODS ------///
  Future<void> initialiseUser() async {
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
      this.team = await FirebaseCore().getTeam(this.uid, this.playerDB);
      this.calculatePoints();
      this.loadMiscDetailsFromDB();
      print(
          "Loaded user successfully ${this.uid}. Should proceed to home page");
      this.signingUp = false; // safety ensured check
      this.team.checkCaptain();
      notifyListeners();
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
      this.pendingTransfer = []; //Resets any residual transfers
      this.completedTransfers = [];
      this.setInitialTeam();
      this.setInitialChips();

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
    this.freeTransfers = 100;
    this.hits = 0;
  }

  void setInitialChips() {
    this.chips = [];
    // todo add chips when we get here
  }

  ///------ DB METHODS ------///
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> loadInPlayerAndGWHistoryDB() async {
    this.playerDB = [];
    await FirebaseCore().getPlayers(this.playerDB);
    await this.loadInGWHistory();
    return;
  }

  Future<void> loadInGWHistory() async {
    this.gwHistory = [];
    await FirebaseCore().getGWHistory(this.gwHistory, this.playerDB);
    await FirebaseGWHistory().getPlayerGWs(this.gwHistory, this.playerDB);
    return;
  }

  Future<void> generalDBPull() async {
    await this.loadInPlayerAndGWHistoryDB();
    print("YO");
    await this.loadMiscDetailsFromDB();
  }

  void userDetailsPushDB() {
    // new user in users if needed
    try {
      FirebaseCore().checkUserInDB(this.uid);
      // // new/update team in users/{user}/team
      FirebaseCore().pushTeamToDB(this.team, this.uid);
      // // new/update other fields required to track
      FirebaseCore().pushMiscFieldsToDB(this);
    } catch (e) {
      print("Error in pushing details to DB: ${e}");
    }
  }

  void pushTeamToDB() async {
    FirebaseCore().pushTeamToDB(this.team, this.uid);
  }

  void loadMiscDetailsFromDB() async {
    DocumentSnapshot data = await FirebaseCore().getMiscDetails(this.uid);
    this.totalPts = data.get("total-pts");
    this.gwPts = data.get("gw-pts");
    this.teamName = data.get("team-name");
    this.budget = data.get("budget");
    this.freeTransfers = data.get("free-transfers");
    this.hits = data.get("hits");
    this.teamValue = data.get("team-value");
    print("here i bet");
    data.data()["completed-transfers"] != null
        ? completedTransfersFromData(data.get("completed-transfers"))
        : this.completedTransfers = [];
  }

  void getAdminInfo() {
    FirebaseCore().getAdminInfo(this);
  }

  ///------ TRANSFER METHODS ------///

  void beginTransfer(TeamPlayer outgoing) {
    this.pendingTransfer.add(Transfer());
    this.pendingTransfer.last.outgoing = outgoing;
  }

  String completeTransfer(TeamPlayer outgoing, TeamPlayer incoming) {
    try {
      Transfer currTransfer =
          this.pendingTransfer.firstWhere((t) => (t.outgoing == outgoing));
      currTransfer.incoming = incoming;
      this.adjustBudget(currTransfer);
      String result = this.team.transfer(currTransfer);
      //Remove pending transfer regardless of outcome
      this.pendingTransfer.remove(currTransfer);
      if (result == "") {
        this.adjustFreeTransfersAndHits(currTransfer);
        notifyListeners();
        return result;
      }
      return "${result}";
    } catch (e) {
      return "${e}";
    }
  }

  /// Checks if user can afford to make the pending transfer
  /// Assumes only runs after confirming that both players are viable
  /// for transfer
  String adjustBudget(Transfer currTransfer) {
    TeamPlayer incoming = currTransfer.incoming;
    TeamPlayer outgoing = currTransfer.outgoing;
    this.budget -= incoming.boughtPrice;
    this.budget += outgoing.currPrice;
    return "";
  }

  /// checks if making current transfer can be a free transfer otherwise adds a hit
  void subtractFreeTransferOrAddHit() {
    if (this.freeTransfers == 0) {
      this.hits += 1;
    } else {
      this.freeTransfers -= 1;
    }
  }

  /// checks if making current transfer can be a free transfer otherwise adds a hit
  void addFreeTransferOrSubtractHit() {
    if (this.hits > 0) {
      this.hits -= 1;
    } else {
      this.freeTransfers += 1;
    }
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

  void resetConsideredPlayers() {
    print("Removing consideration");
    this.team.players.forEach((p) {
      p.inConsideration = false;
    });
    notifyListeners();
  }

  void restoreOriginals() {
    this.team = this.originalModels.team;
    this.budget = this.originalModels.budget;
    this.freeTransfers = this.originalModels.freeTransfers;
    this.hits = this.originalModels.hits;
    this.completedTransfers = this.completedTransfers;
    this.originalModels = null;
    this.resetRemovedPlayers();
  }

  List<Transfer> completedTransfersFromData(List<dynamic> transfers) {
    this.completedTransfers = [];
    transfers.forEach((transfer) {
      List<String> inAndOut = transfer.split("=>");
      Player outP = this.playerDB.firstWhere((p) => p.name == inAndOut[0]);
      Player inP = this.playerDB.firstWhere((p) => p.name == inAndOut[1]);
      int index = 0; // index doesnt matter for these already completed.
      Transfer t = Transfer();
      t.incoming = TeamPlayer.fromPlayer(inP, index);
      t.outgoing = TeamPlayer.fromPlayer(outP, index);
      this.completedTransfers.add(t);
    });
  }

  List<String> completedTransferAsList() {
    List<String> comTrans = [];
    this.completedTransfers.forEach((Transfer t) {
      comTrans.add("${t.outgoing.name}=>${t.incoming.name}");
    });
    print(comTrans);
    return comTrans;
  }

  /// A transfer has just been made. Check if you
  /// a) reinstate an original team member, add a free/reduce cost
  /// b) remove an original member, subtract a free/reduce cost
  void adjustFreeTransfersAndHits(Transfer currTransfer) {
    Team originalTeam = this.originalModels.team;
    // If bringing back in an original team member, reinstate and readd frees/hits
    if (originalTeam.players.any((p) => p.name == currTransfer.incoming.name)) {
      reinstateOriginalTeamPlayer(currTransfer.incoming, originalTeam);
    } else if (originalTeam.players
        .any((p) => p.name == currTransfer.outgoing.name)) {
      subtractFreeTransferOrAddHit();
    }
  }

  /// This method will remove any 'middle' transfers that occurred in the tinkering
  /// process
  void addToCompletedTransfers() {
    // List of new completed transfers
    List<String> newTrans = [];
    for (int i = 0; i < this.team.players.length; i++) {
      TeamPlayer newTP = this.team.players[i];
      TeamPlayer oldTP = this.originalModels.team.players[i];
      if (newTP.name != oldTP.name) {
        this
            .completedTransfers
            .add(Transfer.fromPlayers(incoming: newTP, outgoing: oldTP));
        newTrans.add("${oldTP.name}=>${newTP.name}");
      }
    }
    ;
    print(newTrans);
  }

  void reinstateOriginalTeamPlayer(TeamPlayer player, Team originalTeam) {
    addFreeTransferOrSubtractHit();
    print("Incoming is from og squad. add a free or hit. Fix aura");
    // replace with original pricing info from originalTeam
    int index = this.team.players.indexOf(player);
    this.team.players[index] =
        originalTeam.players.firstWhere((p) => p.name == player.name);
    this.team.players[index].inConsideration = false;
    notifyListeners();
  }

  void reinstateOriginalTeamPlayerFromIndex(int index) {
    this.team.players[index] = this.originalModels.team.players[index];
    addFreeTransferOrSubtractHit();
    this.team.players[index].inConsideration = false;
    // Remove any 'completed transfers' with this original team member
    this
        .completedTransfers
        .removeWhere((t) => t.outgoing.name == this.team.players[index].name);

    notifyListeners();
  }

  void confirmTransfersButtonPressed() {
    this.resetConsideredPlayers();
    this.addToCompletedTransfers();
    this.signingUp = false;
    this.originalModels = null; //resets incase required
    this.userDetailsPushDB();
  }

  ///------ GAMEPLAY METHODS ------///

  void calculateTeamValue() {
    this.teamValue = this.team.teamValue(); // todo seems bad style
  }

  void benchPlayer(TeamPlayer player) {
    this.team.benchPlayer(player);
    notifyListeners();
  }

  void updateCaptaincy(TeamPlayer player, String rank) {
    this.team.updateCaptaincy(player, rank);
    FirebaseCore().pushTeamToDB(team, uid);
    notifyListeners();
  }

  void calculatePoints() {
    try {
      this.totalPts = 0;
      this.playerDB.forEach((p) {
        p.currPts = p.gwResults[this.currGW - 1].playerGameweeks[0].gwPts;
        p.totalPts = 0;
        p.gwResults.forEach((gw) {
          if (gw.id <= this.currGW) p.totalPts += gw.playerGameweeks[0].gwPts;
        });
      });
      if (this.team != null) {
        this.gwPts = 0;
        this.team.players.forEach((p) {
          this.gwPts += p.currPts;
        });
      }
    } catch (e) {
      print("Something's wrong: ${e}");
    }
  }

  ///------ GETTERS/SETTERS ------///

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

  int get currGW => _currGW;

  set currGW(int value) {
    _currGW = value;
  }

  int get hits => _hits;

  set hits(int value) {
    _hits = value;
  }

  List<Chip> get chips => _chips;

  set chips(List<Chip> value) {
    _chips = value;
  }

  List<Transfer> get completedTransfers => _completedTransfers;

  set completedTransfers(List<Transfer> value) {
    _completedTransfers = value;
  }
}
