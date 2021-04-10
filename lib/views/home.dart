import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
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
  List<Widget> _pages = [];

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["Transfers", "Points", "Pick Team", "Leaderboard"];
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    bool loaded = user.team != null;
    if (loaded) {
      user.team.checkCaptain();
      this._pages = [TransfersPage(), PointsPage(), PickPage(), Leaderboard()];
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: loaded ? _pages[_selectedIndex] : CircularProgressIndicator()),
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.black.withAlpha(
                180), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text("Admin"),
                    onPressed: () {
                      if (!user.admin) {
                        var sb = SnackBar(
                            content: Text(
                                "Yeah nah laddie, you don't have admin access"));
                        ScaffoldMessenger.of(context).showSnackBar(sb);
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamed(context, Routes.Admin);
                      }
                    }),
                MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text("Settings"),
                    onPressed: () {
                      var sb = SnackBar(
                          content: Text(
                              "Yeah look would've loved to add settings but ran out of time"));
                      ScaffoldMessenger.of(context).showSnackBar(sb);
                      Navigator.pop(context);
                    }),
                MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Logout"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                )
              ],
            ),
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
          BottomNavigationBarItem(icon: Icon(Icons.wine_bar), label: titles[3]),
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
