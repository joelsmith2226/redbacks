import 'package:flutter/material.dart';

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
            image: NetworkImage("https://i.pinimg.com/564x/a2/10/ad/a210ad3666aeedcdeac03fdeaa291ee4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: "Transfers"),
          BottomNavigationBarItem(icon: Icon(Icons.sports_baseball), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.wine_bar), label: "Leaderboard"),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: (index) {_onItemTapped(index);},
      ),
    );
  }
}
