import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/models/playerGameweek.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_carousel.dart';

class GameweekForm extends StatefulWidget {
  @override
  _GameweekFormState createState() => _GameweekFormState();
}

class _GameweekFormState extends State<GameweekForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormBuilderState> _gameFormKey =
      GlobalKey<FormBuilderState>();
  List<GlobalKey<FormBuilderState>> _playerFormKeys = [];
  final List<double> heightMultiplier = [0.4, 0.6];

  LoggedInUser user;
  bool _loading = false;
  int _stage = 0;
  Gameweek GW;
  PlayerGameweek currPlayerGW;

  @override
  void initState() {
    this.user = Provider.of<LoggedInUser>(context, listen: false);
    this.user.playerDB.forEach((player) {
      _playerFormKeys.add(GlobalKey<FormBuilderState>(debugLabel: player.name));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);
    this.GW = Provider.of<Gameweek>(context);
    List<Widget> forms = [gameScoreForm(), playerForm()];
    List<Widget> actions = [gameScoreActions(), playerFormActions()];
    this.currPlayerGW = this.GW.playerGameweeks[this.GW.currPlayerIndex];

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          this._stage == 1 ? PlayerCarousel(gw: this.GW) : Container(),
          Container(
            margin: EdgeInsets.all(20),
            color: Colors.white,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height *
                heightMultiplier[this._stage],
            child: forms[this._stage],
          ),
          actions[this._stage],
        ],
      ),
    );
  }

  Widget gameScoreForm() {
    List<Widget> _formElements = <Widget>[
      NumberForm(10, "gw", "Gameweek #"),
      TextForm("opposition", "Enter Opposition"),
      TextForm("score", "Enter the Score", req: true),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _loading ? CircularProgressIndicator() : Container(),
        _form(_formElements, _gameFormKey),
      ],
    );
  }

  Widget gameScoreActions() {
    return MaterialButton(
      color: Theme.of(context).primaryColor,
      child: Text(
        "Next",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _gameFormKey.currentState.save();
        setState(() {
          this.GW.gameScore = _gameFormKey.currentState.value["score"];
          this.GW.id = _gameFormKey.currentState.value["gw"];
          this.GW.opposition = _gameFormKey.currentState.value["opposition"];
          this._stage = 1;
        });
        print("Gameweek saved");
      },
    );
  }

  Widget _form(List<Widget> formElements, GlobalKey<FormBuilderState> key) {
    return FormBuilder(
        key: key,
        child: Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: formElements,
            ),
          ),
        ));
  }

  Widget playerForm() {
    print(this.currPlayerGW.player.name);
    List<Widget> formElements = <Widget>[
      dropdownForm("position", "Select Position", ["GKP", "DEF", "MID", "FWD"], initial:this.currPlayerGW.player.position),
      Row(children: [
        NumberForm(0, "goals", "Goals Scored"),
        NumberForm(0, "assists", "Assists Scored"),
        NumberForm(0, "saves", "2x Saves Scored"),
      ]),
      Divider(
        thickness: 1,
      ),
      dropdownForm("cleans", "Cleans kept", ["0", "1/4", "1/2", "Full"]),
      Container(
        width: 300,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(children: [
                NumberForm(0, "yellow", "Number of yellow cards"),
                NumberForm(0, "red", "Red card received"),
              ]),
              Column(children: [
                NumberForm(0, "owns", "Own goals conceded"),
                NumberForm(0, "penalty", "Penalties Missed"),
              ])
            ]),
      ),
      Divider(
        thickness: 1,
      ),
      dropdownForm("bonus", "Bonus Points", ["0", "1", "2", "3"]),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _loading ? CircularProgressIndicator() : Container(),
        _form(formElements, _playerFormKeys[this.GW.currPlayerIndex]),
      ],
    );
  }

  Widget playerFormActions() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                this._stage = 0;
              });
              print("Go back");
            },
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              "Save Player",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("Player saved");
            },
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              "Submit to DB",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("Player saved");
            },
          ),
        ],
      ),
    );
  }

  Widget TextForm(String name, String label, {req = false}) {
    var validators = [
      FormBuilderValidators.required(context),
    ];
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: FormBuilderValidators.compose(validators),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget SliderForm(String name, String label) {
    return FormBuilderSlider(
      name: name,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.min(context, 6),
      ]),
      onChanged: (value) => null,
      min: 0.0,
      max: 10.0,
      initialValue: 7.0,
      divisions: 20,
      activeColor: Colors.red,
      inactiveColor: Colors.pink[100],
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Widget NumberForm(int value, String name, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Text(
          "${label}",
          style: TextStyle(color: Colors.black.withAlpha(160), fontSize: 10),
        ),
        TouchSpin(
          textStyle: TextStyle(fontSize: 16),
          value: value,
          min: 0,
          step: 1,
          iconSize: 15.0,
        ),
      ],
    );
  }

  Widget CheckboxForm(String name, String label) {
    return Container(
      width: 10,
      child: FormBuilderCheckbox(
        title: Container(width: 10, child: Text(label)),
        name: name,
        initialValue: false,
        onChanged: (value) => null,
      ),
    );
  }

  Widget dropdownForm(String name, String label, List<String> options,
      {String initial = ""}) {
    return FormBuilderChoiceChip(
      alignment: WrapAlignment.center,
      initialValue: initial,
      name: name,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        labelText: label,
      ),
      spacing: 15,
      options: [
        FormBuilderFieldOption(value: options[0], child: Text(options[0])),
        FormBuilderFieldOption(value: options[1], child: Text(options[1])),
        FormBuilderFieldOption(value: options[2], child: Text(options[2])),
        FormBuilderFieldOption(value: options[3], child: Text(options[3])),
      ],
    );
  }

  void _errorHandler(error) {
    print("Here no???????");
    var errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
    var sb = SnackBar(
      content: Text(errorMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
    _loading = false;
  }
}
