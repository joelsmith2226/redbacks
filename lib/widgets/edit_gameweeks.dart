import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class EditGameweeks extends StatefulWidget {
  @override
  _EditGameweeksState createState() => _EditGameweeksState();
}

class _EditGameweeksState extends State<EditGameweeks> {
  bool _loading = true;
  List<Gameweek> _gwHistory = [];
  int _currIndex = 0;

  @override
  void initState() {
    _loading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    if (_loading) {
      _loadingFn(user);
      print("YO");
    }
    return Container(
      alignment: Alignment.center,
      child: _loading
          ? CircularProgressIndicator()
          : Stack(
              children: [
                GWGrid(),
                actionBtns(),
              ],
            ),
    );
  }

  void _loadingFn(LoggedInUser user) async {
    await user.loadInGWHistory();
    setState(() {
      _gwHistory = user.gwHistory;
      _loading = false;
    });
  }

  Widget GWGrid() {
    return GridView.builder(
      itemCount: _gwHistory.length * 5,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => setState(() {
            _currIndex = index;
          }),
          highlightColor: Colors.blue,
          child: Card(
            shadowColor: _currIndex == index
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                width: 10,
                color: _currIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Gameweek-${_gwHistory[0].id}"),
                  Text("Score: ${_gwHistory[0].gameScore}"),
                  Text(
                    "Opposition: ${_gwHistory[0].opposition}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget actionBtns() {
    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
              child: Text("Update Users Pts", style: TextStyle(color: Colors.white),),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                RedbacksFirebase().updateUsersGW(_gwHistory[_currIndex]);
              }),
          MaterialButton(
              child: Text("Edit GW", style: TextStyle(color: Colors.white),),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("EDIT GW COMING SOON"),
                ));
              }),
        ],
      ),
    );
  }
}
