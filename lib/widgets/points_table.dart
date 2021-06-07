import 'package:flutter/material.dart';
import 'package:redbacks/models/points_table_row.dart';

class PointsTable extends StatefulWidget {
  List<PointsTableRow> entries;

  PointsTable(this.entries);

  @override
  _PointsTableState createState() => _PointsTableState();
}

class _PointsTableState extends State<PointsTable> {
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
    widget.entries.sort((a, b) =>
        int.tryParse(a.position.replaceAll(".", "")) -
        int.tryParse(b.position.replaceAll(".", "")));
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
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categoryColumnCell("", 0.05),
          categoryColumnCell("", 0.2),
          categoryColumnCell("P", 0.05),
          categoryColumnCell("W", 0.05),
          categoryColumnCell("D", 0.05),
          categoryColumnCell("L", 0.05),
          categoryColumnCell("F", 0.05),
          categoryColumnCell("A", 0.05),
          categoryColumnCell("GD", 0.05),
          categoryColumnCell("Pts", 0.1),
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

class TableListTile extends StatelessWidget {
  PointsTableRow entry;
  BuildContext context;
  int index;

  TableListTile(this.entry, this.index);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Color tileColor;
    if (entry.teamName == "Caringbah\nRedbacks") {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          columnCell('${this.entry.position}', 0.05),
          columnCell("${this.entry.teamName}", 0.2),
          columnCell("${this.entry.played}", 0.05),
          columnCell("${this.entry.win}", 0.05),
          columnCell("${this.entry.draws}", 0.05),
          columnCell("${this.entry.losses}", 0.05),
          columnCell("${this.entry.goalsFor}", 0.05),
          columnCell("${this.entry.goalsAgainst}", 0.05),
          columnCell("${this.entry.goalDifference}", 0.05),
          columnCell("${this.entry.points}", 0.1),
        ],
      ),
    );
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
