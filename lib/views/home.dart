import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/homepage_summary.dart';
import 'package:redbacks/widgets/leaderboard.dart';
import 'package:redbacks/widgets/points_page.dart';
import 'package:redbacks/widgets/team_widget.dart';
import 'package:redbacks/widgets/transfers_page.dart';

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
    List<Widget> pages = [ TransfersPage(), PointsPage(), Leaderboard()];
    List<String> titles = ["Transfers", "Points", "Leaderboard"];
    return Scaffold(
      body: pages[_selectedIndex],
      appBar: AppBar(
        title: Text(titles[_selectedIndex], style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
      drawer: Container(
        decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),

            ),
        width: MediaQuery.of(context).size.width * 0.35,
        child: Drawer(
          child: Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Settings"),
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, "/login");
                  }),
              MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Logout"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  })
            ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: titles[0]),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_baseball), label: titles[1]),
          BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar), label: titles[2]),
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
