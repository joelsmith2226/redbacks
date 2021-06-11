import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:redbacks/models/fixture.dart';
import 'package:redbacks/models/points_table_row.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/fixture_table.dart';
import 'package:redbacks/widgets/points_table.dart';
import 'package:web_scraper/web_scraper.dart';

class FixtureTablePage extends StatefulWidget {
  @override
  _FixtureTablePageState createState() => _FixtureTablePageState();
}

class _FixtureTablePageState extends State<FixtureTablePage>
    with TickerProviderStateMixin {
  LoggedInUser user;
  final webScraper = WebScraper('http://www.shirefootball.com');
  List<Fixture> fixtures;
  List<PointsTableRow> table;
  TabController _controller;

  @override
  void initState() {
    _scrapeSutherlandShireFootballWebsite();
    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoggedInUser>(context, listen: false);

    // Ensure captain is good
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Container(
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black.withAlpha(100),
              child: TabBar(
                controller: _controller,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.date_range,
                    ),
                    text: "Fixtures",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.emoji_events,
                    ),
                    text: "Table",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                            FixtureTable(this.fixtures),
                            PointsTable(this.table),
                          ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrapeSutherlandShireFootballWebsite() async {
    try {
      if (await webScraper.loadWebPage(
          '/ssfixtures.asp?Round=&Age=18&Grade=c&Club=Caringbah%20Redbacks')) {
        List<Map<String, dynamic>> elements = webScraper.getElement('tr', ['']);
        // Remove all non elements
        elements.removeWhere((s) => !"0123456789".contains(s["title"][0]));
        setState(() {
          this.fixtures =
              elements.map((e) => Fixture.fromString(e["title"])).toList();
        });
      }
      print("attempting table");
      if (await webScraper.loadWebPage('/sstables.asp?Age=18&Grade=c')) {
        print("found table info");
        List<Map<String, dynamic>> elements = webScraper.getElement('tr', ['']);
        // Remove all non elements
        setState(() {
          this.table =
              elements.map((e) => PointsTableRow((e["title"]))).toList();
          this.table.removeWhere((e) => e.position == null);
        });
      }
    } catch (e) {
      print(e);
      print("caught error");
    }
  }

  Future<http.Response> fetchFixture() async {
    return http.get(Uri.parse(
        'http://www.shirefootball.com/ssfixtures.asp?Round=&Age=18&Grade=c&Club=Caringbah%20Redbacks'));
  }
}
