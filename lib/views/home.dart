import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/leaderboard.dart';
import 'package:redbacks/widgets/pick_page.dart';
import 'package:redbacks/widgets/points_page.dart';
import 'package:redbacks/widgets/transfers_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [ TransfersPage(), PointsPage(), PickPage(), Leaderboard()];
    List<String> titles = ["Transfers", "Points", "Pick Team","Leaderboard"];
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    return Scaffold(
      key: _scaffoldKey,
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
                  Text(user.uid + "\n" + user.email),
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
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: titles[0]),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_baseball), label: titles[1]),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: titles[2]),
          BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar), label: titles[3]),
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
