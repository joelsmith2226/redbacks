import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseGWHistory.dart';
import 'package:redbacks/models/user_GW.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/points_summary.dart';
import 'package:redbacks/widgets/pre_app_points.dart';
import 'package:redbacks/widgets/team_widget.dart';

class PointPageOtherUser extends StatefulWidget {
  PointPageOtherUser();

  @override
  _PointPageOtherUserState createState() => _PointPageOtherUserState();
}

class _PointPageOtherUserState extends State<PointPageOtherUser> {
  int currentWeek;
  List<UserGW> userGWHistory = [];
  bool loading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String uid;
  String name;
  String teamName;
  int preAppPoints;

  @override
  void initState() {
    loading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OtherPointPageArgs args =
    ModalRoute
        .of(context)
        .settings
        .arguments as OtherPointPageArgs;
    if (loading) {
      uid = args.uid;
      name = args.name;
      teamName = args.teamName;
      currentWeek = args.currWeek;
      preAppPoints = args.preAppPoints;
    } // load once

    UserGW ugw;
    // CurrentWeek Controller
    if (!loading && currentWeek > userGWHistory.length)
      currentWeek = userGWHistory.length;
    else if (currentWeek < 0) currentWeek = 0;

    if (loading)
      _loadInUserGWHistory();
    else if (!loading && userGWHistory.isNotEmpty && currentWeek != 0) {
      userGWHistory.sort((a, b) => a.id.compareTo(b.id));
      ugw = userGWHistory[currentWeek - 1];
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
          Container(
            child: loading
                ? CircularProgressIndicator()
                : currentWeek == 0
                ? PreAppPoints(
                callback: (val) => setState(() => currentWeek = val),
                preAppPoints: this.preAppPoints)
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PointsSummary(ugw, currentWeek,
                        (val) => setState(() => currentWeek = val)),
                ugw == null
                    ? Container(child: Text("No points for this GW"))
                    : Expanded(
                  child: Container(
                    child: TeamWidget(ugw.team,
                        bench: true, mode: POINTS, ugw: ugw),
                  ),
                ),
              ],
            ),
            alignment: Alignment.center,
          ),
          loading
              ? Container() : (ugw.chip != '' ? chipContainer(ugw.chip) : Container()),
        ],
      ),
      appBar: AppBar(
        title: Text(
          this.teamName,
          style: GoogleFonts.merriweatherSans(),
        ),
        centerTitle: true,
      ),
    );
  }

  void _loadInUserGWHistory() async {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    userGWHistory =
    await FirebaseGWHistory().getCompleteUserGWHistory(uid, user.gwHistory);
    setState(() {
      loading = false;
    });
  }


  Widget chipContainer(String chip) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black38.withAlpha(170),
        ),
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(15),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: PointsText(
            "Chip Used\n",
            CHIPS[chip],
            Theme.of(context).primaryColor,
            Colors.white,
          ),
        ),
      ),
    );
  }

  Widget PointsText(String t1, String t2, Color c1, Color c2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: t1,
          style:
          TextStyle(color: c1, fontSize: 16, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: t2,
              style: TextStyle(color: c2, fontSize: 26),
            )
          ]),
    );
  }
}
