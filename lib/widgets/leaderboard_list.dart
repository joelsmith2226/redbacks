import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseLeaderboard.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class LeaderboardList extends StatefulWidget {
  LeaderboardList();

  @override
  _LeaderboardListState createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  List<LeaderboardListEntry> _entries = [];
  bool loading = true;

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _entries.sort((a, b) => b.totalPts.compareTo(a.totalPts));

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: loading
            ? CircularProgressIndicator()
            : Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  itemCount: _entries.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Build category row
                      return Column(children: [
                        CategoryListTile(),
                        LeaderboardListTile(_entries[index], index),
                      ]);
                    } else {
                      return LeaderboardListTile(_entries[index], index);
                    }
                  },
                ),
              ),
      ),
    );
  }

  void _loadEntries() async {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    if (user.leaderBoard.length == 0) {
      user.leaderBoard = this._entries = await FirebaseLeaderboard().loadUserLeadeboard();
    }
    this._entries = user.leaderBoard;
    setState(() {
      loading = false;
    });

  }

  Widget loadBtn() {
    return MaterialButton(
      child: Text("load leaders"),
      onPressed: () {
        setState(() {
          print("SET STATE");
          loading = false;
        });
      },
    );
  }
}

class CategoryListTile extends StatelessWidget {
  BuildContext context;

  CategoryListTile();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      child: categoryColumns(),
    );
  }

  Widget categoryColumns() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categoryColumnCell("", 0.1),
          categoryColumnCell("Name", 0.4),
          categoryColumnCell("GW Pts", 0.1),
          categoryColumnCell("Total Pts", 0.1),
        ],
      ),
    );
  }

  Widget categoryColumnCell(String value, double width) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * width,
      child: RichText(
          overflow: TextOverflow.fade,
          text: TextSpan(
            text: value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }
}

class LeaderboardListTile extends StatelessWidget {
  LeaderboardListEntry entry;
  BuildContext context;
  int pos;

  LeaderboardListTile(this.entry, this.pos);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    Color tileColor = pos % 2 == 0 ? Theme.of(context).buttonColor : Colors.white;
    return ListTile(
      tileColor: tileColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        Navigator.pushNamed(context, Routes.PointPageOther,
            arguments: OtherPointPageArgs(this.entry.uid, this.entry.name,
                this.entry.teamName, user.gwHistory.length, this.entry.preAppPoints));
      },
      leading: Text(
        "${pos + 1}",
        textScaleFactor: 0.9,
      ),
      title: columns(),
    );
  }

  Widget columns() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          columnCell('${this.entry.teamName}', 0.35, subtitle: this.entry.name),
          columnCell("${this.entry.gwPts}pts", 0.16,
              align: Alignment.centerRight),
          columnCell("${this.entry.totalPts}pts", 0.16,
              align: Alignment.centerRight),
        ],
      ),
    );
  }

  Widget columnCell(String value, double width,
      {Alignment align = Alignment.centerLeft, String subtitle = ''}) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * width,
      alignment: align,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                textScaleFactor: 0.8,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                textScaleFactor: 0.6,
              ),
            ]),
      ),
    );
  }
}
