import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/fixture.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class FixtureTable extends StatefulWidget {
  List<Fixture> entries;

  FixtureTable(this.entries);

  @override
  _FixtureTableState createState() => _FixtureTableState();
}

class _FixtureTableState extends State<FixtureTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries == null) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text("Loading Table..."), CircularProgressIndicator()],
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        color: Colors.white,
        alignment: Alignment.center,
      );
    }
    widget.entries.sort((a, b) => int.tryParse(b.round).compareTo(int.tryParse(a.round)));
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            itemCount: widget.entries.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Build category row
                return Column(children: [
                  CategoryListTile(),
                  TableListTile(widget.entries[index], index),
                ]);
              } else {
                return TableListTile(widget.entries[index], index);
              }
            },
          ),
        ),
      ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            categoryColumnCell("Round", 0.12),
            categoryColumnCell("Home", 0.2),
            categoryColumnCell("Away", 0.2),
            categoryColumnCell("Time", 0.2),
            categoryColumnCell("Field", 0.18),
          ],
        ),
      ),
    );
  }

  Widget categoryColumnCell(String value, double width) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * width,
      child: RichText(
          overflow: TextOverflow.clip,
          text: TextSpan(
            text: value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }
}

class TableListTile extends StatelessWidget {
  Fixture entry;
  BuildContext context;
  int index;

  TableListTile(this.entry, this.index);

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    this.context = context;
    Color tileColor;
    if (user.currGW.toString() == entry.round) {
      HSLColor c = HSLColor.fromColor(Theme.of(context).primaryColor);
      tileColor =
          c.withLightness((c.lightness + 0.5).clamp(0.0, 1.0)).toColor();
    } else {
      tileColor = index % 2 == 0 ? Theme.of(context).buttonColor : Colors.white;
    }
    return ListTile(
      tileColor: tileColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: columns(),
    );
  }

  Widget columns() {
    return Container(
        height: 50,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              columnCell('${this.entry.round}', 0.1, subtitle: this.entry.date),
              columnCell("${this.entry.home}", 0.2),
              columnCell("${this.entry.away}", 0.2),
              columnCell("${this.entry.time}", 0.2),
              columnCell("${this.entry.field}", 0.18),
            ],
          ),
        ));
  }

  Widget columnCell(String value, double width,
      {Alignment align = Alignment.centerLeft, String subtitle = ''}) {
    List<Widget> children = [
      Text(
        value,
        textScaleFactor: 0.8,
        overflow: TextOverflow.ellipsis,
      ),
    ];

    if (subtitle != '') {
      children.add(SizedBox(height: 3));
      children.add(
        Text(
          subtitle,
          textScaleFactor: 0.6,
        ),
      );
    }

    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * width,
      alignment: align,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children),
      ),
    );
  }
}
