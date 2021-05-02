import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/theme_switcher.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  TabController _controller;

  void changeColor(Color color) async {
    setState(() => pickerColor = color);
    ThemeSwitcher.of(context).switchTheme(Theme.of(context)
        .copyWith(primaryColor: color, accentColor: color.withAlpha(150)));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', color.value);
  }

  void changeColorUsingPicker(Color color) async {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Change App Theme Color?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: TabBarView(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: BlockPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: MaterialPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                                enableLabel: true, // only on portrait mode
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _controller,
                    labelColor: pickerColor,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(
                          Icons.grid_on,
                          color: pickerColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.table_chart,
                          color: pickerColor,
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    child: Text("Default Colour",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () => changeColor(DEFAULT_COLOR),
                    color: DEFAULT_COLOR,
                  )
                ],
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(
            "Settings",
            style: GoogleFonts.merriweatherSans(),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
