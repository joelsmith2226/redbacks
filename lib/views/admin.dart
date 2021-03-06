import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/admin/admin_actions.dart';
import 'package:redbacks/widgets/admin/edit_gameweeks.dart';
import 'package:redbacks/widgets/admin/gameweek_form.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _pages = [];

  void _onItemTapped(index) {
    if (index == 3) {
      AlertDialog alert = goBack();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      "Enter New GW",
      "Edit Past GWs",
      "Various Actions",
      "Back To User Mode"
    ];
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    bool loaded = true;
    this._pages = [
      ChangeNotifierProvider(
          create: (context) => Gameweek(user.playerDB), child: GameweekForm()),
      EditGameweeks(),
      AdminActions(),
      Text("Edit past gws?"),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width),
          loaded ? _pages[_selectedIndex] : CircularProgressIndicator(),
        ],
      ),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.all(10),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Theme.of(context).accentColor,
                      child: FittedBox(
                          child: Text("Go Back",
                              style: TextStyle(color: Colors.white))),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.Home);
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.all(10),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Theme.of(context).accentColor,
                    child: FittedBox(
                        child: Text("Logout",
                            style: TextStyle(color: Colors.white))),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                  ),
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
              icon: Icon(Icons.calculate), label: titles[0]),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: titles[1]),
          BottomNavigationBarItem(
              icon: Icon(Icons.alt_route), label: titles[2]),
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_backspace_sharp), label: titles[3]),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }

  AlertDialog goBack() {
    return AlertDialog(
      title: Text(
        'Go back?',
        textAlign: TextAlign.center,
      ),
      content: Text("Sure you wanna go back boss?"),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.Home);
          },
          child: Text('Yes'),
        ),
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
