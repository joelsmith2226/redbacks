import 'package:flutter/material.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';

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
      color: Colors.white.withAlpha(200),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          child: loading ? loadBtn() : ListView.builder(
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

  void _loadEntries() {
    FirebaseCore()
        .loadUserLeadeboard()
        .then((List<LeaderboardListEntry> entries) => setState(() {
              _entries = entries;
            }));
  }

  Widget loadBtn() {
    return MaterialButton(
      child: Text("load leaders"),
      onPressed: () {
        setState(() {
          print("SET STATE");
          loading = false;
      });},
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
        border: Border.all(
          color: Colors.black.withAlpha(100),
        ),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categoryColumnCell("", 0.14),
          categoryColumnCell("Name", 0.43),
          categoryColumnCell("", 0.02),
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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        Navigator.pushNamed(context, Routes.PointPageOther,
            arguments: OtherPointPageArgs(
                this.entry.uid, this.entry.name, this.entry.teamName));
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
          columnCell('${this.entry.teamName}', 0.45, subtitle: this.entry.name),
          columnCell("${this.entry.gwPts}pts", 0.1,
              align: Alignment.centerRight),
          columnCell("${this.entry.totalPts}pts", 0.1,
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
    );
  }
}
