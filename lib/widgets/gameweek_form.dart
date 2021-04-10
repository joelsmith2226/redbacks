import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/redbacksFirebase.dart';
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
  GlobalKey<FormBuilderState> _currKey;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);
    this.GW = Provider.of<Gameweek>(context);
    this.currPlayerGW = this.GW.playerGameweeks[this.GW.currPlayerIndex];
    this._currKey = this.currPlayerGW.key;
    if(this.currPlayerGW.saved){
      this.currPlayerGW.loadKey();
    }

    List<Widget> forms = [gameScoreForm(), playerForm()];
    List<Widget> actions = [gameScoreActions(), playerFormActions()];

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
      NumberForm(10, GAMEWEEK, "Gameweek #"),
      TextForm(OPPOSITION, "Enter Opposition"),
      TextForm(SCORE, "Enter the Score", req: true),
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
          this.GW.gameScore = _gameFormKey.currentState.value[SCORE];
          this.GW.id = _gameFormKey.currentState.value[GAMEWEEK];
          this.GW.opposition = _gameFormKey.currentState.value[OPPOSITION];
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
      ),
    );
  }

  Widget playerForm() {
    List<Widget> formElements = <Widget>[
      dropdownForm(POSITION, "Select Position", ["GKP", "DEF", "MID", "FWD"],
          initial: this.currPlayerGW.player.position),
      goalAssistSaves(),
      Divider(
        thickness: 1,
      ),
      dropdownForm(CLEANS, "Cleans kept",
          [NO_CLEAN, QUARTER_CLEAN, HALF_CLEAN, FULL_CLEAN],
          initial: "0"),
      cardsOwnsPens(),
      Divider(
        thickness: 1,
      ),
      dropdownForm(BONUS, "Bonus Points", ["0", "1", "2", "3"], initial: "0"),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _loading ? CircularProgressIndicator() : Container(),
        _form(formElements, _currKey),
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
              saveStateToGWObject();
              print("Player saved");
              // Shift to next available index
              if (this.GW.currPlayerIndex < this.GW.playerGameweeks.length - 1){
                this.GW.currPlayerIndex += 1;
              }
            },
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              "Submit to DB",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              AlertDialog confirmDB = confirmPushToDB();
              showDialog(context: context, builder: (context) => confirmDB);
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

  Widget NumberForm(int value, String name, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Text(
          "${label}",
          style: TextStyle(color: Colors.black.withAlpha(160), fontSize: 10),
        ),
        FormBuilderField(
          name: name,
          builder: (FormFieldState<dynamic> field) {
            return TouchSpin(
              textStyle: TextStyle(fontSize: 16),
              value: field.value == null ? value : field.value,
              min: 0,
              step: 1,
              iconSize: 15.0,
              onChanged: (val) {
                field.setValue(val);
                saveCurrPlayerGWState(this._stage == 0 ? this._gameFormKey : this._currKey);
              },
            );
          },
        ),
      ],
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
      onChanged: (val) {
        saveCurrPlayerGWState(this._currKey);
      },
    );
  }

  void saveCurrPlayerGWState(GlobalKey<FormBuilderState> key) {
    key.currentState.save();
    print("State Saved ${key.currentState.value}");
  }

  dynamic loadCurrStateValue(String label, dynamic alternative) {
    print("Loading for ${this.GW.currPlayerIndex}");
    try {
      var result = this._currKey.currentState.fields[label].value;
      return result;
    } catch (e) {
      print("Error: ${e}");
      return alternative;
    }
  }

  void saveStateToGWObject() {
    this.GW.saveDataToGWObject(this._currKey.currentState);
  }

  Widget goalAssistSaves() {
    return Row(children: [
      NumberForm(loadCurrStateValue(GOALS, 0), GOALS, "Goals Scored"),
      NumberForm(loadCurrStateValue(ASSISTS, 0), ASSISTS, "Assists Scored"),
      NumberForm(loadCurrStateValue(SAVES, 0), SAVES, "2x Saves Scored"),
    ]);
  }

  Widget cardsOwnsPens() {
    return Container(
      width: 300,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: [
              NumberForm(0, YELLOW, "Number of yellow cards"),
              NumberForm(0, RED, "Red card received"),
            ]),
            Column(children: [
              NumberForm(0, OWNS, "Own goals conceded"),
              NumberForm(0, PENS, "Penalties Missed"),
            ])
          ]),
    );
  }

  AlertDialog confirmPushToDB() {
    return AlertDialog(
      title: Text(
        'Are you sure?',
        textAlign: TextAlign.center,
      ),
      content: Text("Are you sure you are happy to overwrite current GW in DB?"),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context);
            String message = "";
            if(this.GW.allPlayersSaved) {
              try {
                RedbacksFirebase().addGWToDB(this.GW);
                message = "Successfully added GW${this.GW.id} to DB!";
              } catch (e) {
                message = "Something went wrong in submitting to db: ${e}";
              }
            } else {
              message = "Not all players are saved!";
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
