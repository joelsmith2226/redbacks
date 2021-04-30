import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/rFirebase/authentication.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';

class RootView extends StatefulWidget {
  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  bool _loadedAdmin;
  bool _loadNextView;

  @override
  void initState() {
    _loadInfo();
    super.initState();
  }

  Future<void> _loadInfo() async {
    _loadedAdmin = false;
    _loadNextView = true;
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);
    await user.getAdminInfo();
    if (this.mounted)
      setState(() {
        _loadedAdmin = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);

    // Build patchmode, login or loading depending on status of user/patching
    // Will reload when patchmode notifys listeners
    print("this is a print from root level");
    if (_loadNextView && _loadedAdmin) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (user.patchMode && !user.admin) {
          Navigator.pushNamed(context, Routes.Patch);
        } else if (isLoggedIn()) {
          Navigator.pushNamed(context, Routes.Loading);
        } else {
          Navigator.pushNamed(context, Routes.Login);
        }
      });
      _loadNextView = false;
    }

    return Scaffold(
      backgroundColor: Color(0xffFEB6BE),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset("assets/spider.png")),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: MaterialButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("Refresh"),
                      onPressed: () => setState(() {
                        _loadInfo();
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoggedIn() {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);

    var isSignedIn = Authentication().isLoggedIn();
    if (isSignedIn == null) {
      return false;
    }
    return isSignedIn && !user.signingUp;
  }
}
