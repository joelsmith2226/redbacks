import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbacks/globals/rFirebase/firebaseUsers.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';

class FirebaseLeaderboard {
  Future<List<LeaderboardListEntry>> loadUserLeadeboard() async {
    List<LeaderboardListEntry> leaderboard = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    QuerySnapshot userList = await users.get();
    for (int i = 0; i < userList.docs.length; i++) {
      if (userList.docs[i].id != 'admin')
        leaderboard = await loadLeaderboardDetails(userList.docs[i], leaderboard);
    }
    return leaderboard;
  }

  Future<List<LeaderboardListEntry>> loadLeaderboardDetails(
      QueryDocumentSnapshot val, List<LeaderboardListEntry> leaderboard) async {
    String uid = val.id;
    DocumentSnapshot userDeets = await FirebaseUsers().getMiscDetails(uid);
    String name =
    userDeets.data().containsKey('name') ? userDeets.get('name') : '';
    String teamName = userDeets.data().containsKey('team-name')
        ? userDeets.get('team-name')
        : '';
    int gwPts =
    userDeets.data().containsKey('gw-pts') ? userDeets.get('gw-pts') : 0;
    int totalPts = userDeets.data().containsKey('total-pts')
        ? userDeets.get('total-pts')
        : 0;
    int preAppPoints = userDeets.data().containsKey('pre-app-pts')
        ? userDeets.get('pre-app-pts')
        : 0;
    leaderboard.add(LeaderboardListEntry(name, teamName, gwPts, totalPts, uid, preAppPoints));
    return leaderboard;
  }

  userRank(String uid) async {
    List<LeaderboardListEntry> leaderBoard = await this.loadUserLeadeboard();
    leaderBoard.sort((a, b) => b.totalPts.compareTo(a.totalPts));
  }
}