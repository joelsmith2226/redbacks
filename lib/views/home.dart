import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/leaderboard.dart';
import 'package:redbacks/widgets/pages/pick_page.dart';
import 'package:redbacks/widgets/pages/points_page.dart';
import 'package:redbacks/widgets/pages/transfers_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _pages = [];
  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);
  Timer loadingTimer;
  LoggedInUser user;

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
    user = Provider.of<LoggedInUser>(context);
    bool loaded = user.team != null;
    if (loaded) {
      user.team.checkCaptain();
      this._pages = [TransfersPage(), PointsPage(), PickPage(), Leaderboard()];
      this.loadingTimer != null
          ? this.loadingTimer.cancel()
          : this.loadingTimer = null;
    } else {
      this.loadingTimer = Timer(Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Yeah this is taking too long, try logout/login")));
      });
    }

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
          ),
          loaded
              ? refresher(_pages[_selectedIndex])
              : Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                ),
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
            canvasColor: Colors.black.withAlpha(
                80),
          ),
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: drawerActions(user.name),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
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
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }

  List<Widget> drawerActions(String name) {
    return [
      Image.asset('assets/icon/spider.png'),
      actionBtn("${name}", _userFn),
      actionBtn("Player Stats", _playerStatsFn),
      user.admin ? actionBtn("Admin", _adminFn) : Container(),
      actionBtn("Settings", _settingsFn),
      actionBtn("Logout", () => Authentication().logoutFn(context))
    ];
  }

  void _adminFn() {
    if (!user.admin) {
      var sb = SnackBar(
          content: Text(
        "Yeah nah laddie, you don't have admin access",
        style: TextStyle(color: Colors.white),
      ));
      ScaffoldMessenger.of(context).showSnackBar(sb);
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, Routes.Admin);
    }
  }

  void _playerStatsFn() {
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.PlayerStats);
  }

  Widget actionBtn(String title, Function onPressed) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Theme.of(context).accentColor,
          child: FittedBox(
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: onPressed,
        ));
  }

  void _settingsFn() {
    Navigator.pushNamed(context, Routes.Settings);
  }

  void _userFn() {
    Navigator.pushNamed(context, Routes.User);
  }

  refresher(Widget page) {
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropMaterialHeader(
          // completeDuration: Duration(seconds: 4),
          ),
      controller: _refreshController,
      onRefresh: () => _onRefresh(user),
      onLoading: () => _onLoading(user),
      child: page,
    );
  }

  void _onLoading(LoggedInUser user) async {
    try {
      await user.generalDBPull();
    } catch (e) {
      _onError(e);
    }
    this._refreshController.loadComplete();
    return;
  }

  void _onRefresh(LoggedInUser user) async {
    try {
      await user.generalDBPull();
      print("the problem is simple: Dont be here until above is complete");
      user.calculatePoints();
    } catch (e) {
      _onError(e);
    }
    this._refreshController.refreshCompleted();
    setState(() {});
  }

  void _onError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Something went wrong: ${e}"),
    ));
  }
}
