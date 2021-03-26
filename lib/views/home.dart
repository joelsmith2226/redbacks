import 'package:flutter/material.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/team_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/564x/a2/10/ad/a210ad3666aeedcdeac03fdeaa291ee4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            HomepageSummary(),
            TeamWidget(Team.blank()),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text("Settings"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                }),
            MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text("Logout"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                })
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: "Transfers"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_baseball), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar), label: "Leaderboard"),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
