import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/models/player_gameweek.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player/player_carousel.dart';

class PlayerGameweekForm extends StatefulWidget {
  Gameweek loadedGW;

  PlayerGameweekForm({this.loadedGW});

  @override
  _PlayerGameweekFormState createState() => _PlayerGameweekFormState();
}

class _PlayerGameweekFormState extends State<PlayerGameweekForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final double heightMultiplier = 0.54;
  LoggedInUser user;
  bool _loading = false;
  Gameweek GW;
  PlayerGameweek currPlayerGW;
  GlobalKey<FormBuilderState> _currKey;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.user = Provider.of<LoggedInUser>(context);
    if (widget.loadedGW != null) {
      this.GW = widget.loadedGW;
    } else {
      this.GW = Provider.of<Gameweek>(context);
    }
    this.currPlayerGW = this.GW.playerGameweeks[this.GW.currPlayerIndex];
    this._currKey = this.currPlayerGW.key;
    // if (this.currPlayerGW.saved) _loadKey();
    this.context = context;

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.75,
      child: Column(
        children: [
          PlayerCarousel(gw: this.GW),
          Container(
            margin: EdgeInsets.all(20),
            color: Colors.white,
            alignment: Alignment.center,
            height: MediaQuery
                .of(context)
                .size
                .height * heightMultiplier,
            child: playerForm(),
          ),
          playerFormActions(),
        ],
      ),
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
      dropdownForm(APPEARANCE, "Made appearance?", ["Yes", "No"],
          initial: "")
    ];
    try {
      if (this._currKey.currentState == null ||
          this._currKey.currentState.value[APPEARANCE] == "Yes") {
        formElements.addAll([
          dropdownForm(
              POSITION, "Select Position", ["GKP", "DEF", "MID", "FWD"],
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
          dropdownForm(BONUS, "Bonus Points", ["0", "1", "2", "3"],
              initial: "0"),
        ]);
      }
    } catch (e) {}

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _loading ? CircularProgressIndicator() : Container(),
        _form(formElements, _currKey),
      ],
    );
  }


  Widget playerFormFromLoaded() {
    List<Widget> formElements = <Widget>[
      dropdownForm(APPEARANCE, "Made appearance?", ["Yes", "No"],
          initial: this.currPlayerGW.appearance ? "Yes" : "No")
    ];
    try {
      if (this._currKey.currentState == null ||
          this._currKey.currentState.value[APPEARANCE] == "Yes") {
        formElements.addAll([
          dropdownForm(
              POSITION, "Select Position", ["GKP", "DEF", "MID", "FWD"],
              initial: this.currPlayerGW.player.position),
          goalAssistSaves(),
          Divider(
            thickness: 1,
          ),
          dropdownForm(CLEANS, "Cleans kept",
              [NO_CLEAN, QUARTER_CLEAN, HALF_CLEAN, FULL_CLEAN],
              initial: cleanIdentifier()),
          cardsOwnsPens(),
          Divider(
            thickness: 1,
          ),
          dropdownForm(BONUS, "Bonus Points", ["0", "1", "2", "3"],
              initial: '${this.currPlayerGW.bonus}'),
        ]);
      }
    } catch (e) {}

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
      height: MediaQuery
          .of(context)
          .size
          .height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            color: Theme
                .of(context)
                .primaryColor,
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              this.GW.stage = 0;
              print("Go back");
            },
          ),
          MaterialButton(
            color: Theme
                .of(context)
                .primaryColor,
            child: Text(
              "Save Player",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              saveStateToGWObject();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                  "Player saved: ${this._currKey.currentState.value} => points: ${this.currPlayerGW.gwPts}pts")));
                  // Shift to next available index
                  if (this.GW.currPlayerIndex <
                  this.GW.playerGameweeks.length - 1)
              {
                this.GW.currPlayerIndex += 1;
              }
            },
          ),
          MaterialButton(
            color: Theme
                .of(context)
                .primaryColor,
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

  Widget TextForm(String name, String label,
      {req = false, String initial = "", double width = 0.75}) {
    var validators = [
      FormBuilderValidators.required(context),
    ];
    UniqueKey key = UniqueKey();
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * width,
      child: FormBuilderTextField(
        key: key,
        textAlign: TextAlign.center,
        initialValue: initial,
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
                saveCurrPlayerGWState(this._currKey);
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
      spacing: 5,
      options: List.generate(
          options.length,
              (index) =>
              FormBuilderFieldOption(
                  value: options[index],
                  child: Text(
                    options[index],
                    style: TextStyle(fontSize: 10),
                  ))),
      onChanged: (val) {
        saveCurrPlayerGWState(this._currKey);
      },
    );
  }

  void saveCurrPlayerGWState(GlobalKey<FormBuilderState> key) {
    key.currentState.save();
    print("State Saved ${key.currentState.value}");
    setState(() {});
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
    setState(() {});
  }

  Widget goalAssistSaves() {
    return Row(children: [
      NumberForm(this.currPlayerGW.goals, GOALS, "Goals Scored"),
      NumberForm(this.currPlayerGW.assists, ASSISTS, "Assists Scored"),
      NumberForm(this.currPlayerGW.saves, SAVES, "2x Saves Scored"),
    ]);
  }

  Widget cardsOwnsPens() {
    return Container(
      width: 300,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              NumberForm(this.currPlayerGW.yellowCards, YELLOW,
                  "Number of yellow cards"),
              NumberForm(this.currPlayerGW.redCards, RED, "Red card received"),
            ]),
            Row(children: [
              NumberForm(
                  this.currPlayerGW.ownGoals, OWNS, "Own goals conceded"),
              NumberForm(
                  this.currPlayerGW.penaltiesMissed, PENS, "Penalties Missed"),
              NumberForm(this.currPlayerGW.goalsConceded, CONCEDED,
                  "2x Goals conceded")
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
      content:
      Text("Are you sure you are happy to overwrite GW-${this.GW.id} in DB?"),
      actions: [
        MaterialButton(
          textColor: Color(0xFF6200EE),
          onPressed: () async {
            Navigator.pop(context);
            String message = "";
            if (this.GW.allPlayersSaved) {
              try {
                await FirebaseCore().addGWToDB(this.GW);
                await FirebaseCore().updateUsersGW(this.GW);
                message = "Successfully added GW${this.GW.id} to DB!";
              } catch (e) {
                message = "Something went wrong in submitting to db: ${e}";
              }
            } else {
              message = "Not all players are saved!";
            }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
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

  cleansGoalsAgainst() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.6,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.55,
            child: dropdownForm(CLEANS, "Cleans kept",
                [NO_CLEAN, QUARTER_CLEAN, HALF_CLEAN, FULL_CLEAN],
                initial: "0"),
          ),
          NumberForm(0, CONCEDED, "Goals conceded")
        ]));
  }

  String cleanIdentifier() {
    if (this.currPlayerGW.fullClean) {
      return FULL_CLEAN;
    } else if (this.currPlayerGW.halfClean) {
      return HALF_CLEAN;
    } else if (this.currPlayerGW.quarterClean) {
      return QUARTER_CLEAN;
    } else {
      return "";
    }
  }

  void _loadKey() {
    // _formKey = new GlobalKey<FormState>();
    // _formKey.currentState.reset();
    //
    // _formKey.currentState.setInternalFieldValue('appearance', this.currPlayerGW.appearance);
    // _formKey.currentState.setInternalFieldValue('position', this.currPlayerGW.position);
    // _formKey.currentState.setInternalFieldValue('goals', this.currPlayerGW.goals);
    // _formKey.currentState.setInternalFieldValue('assists', this.currPlayerGW.assists);
    // _formKey.currentState.setInternalFieldValue('saves', this.currPlayerGW.saves);
    // _formKey.currentState.setInternalFieldValue('cleans', cleanIdentifier());
    // _formKey.currentState.setInternalFieldValue('yellow', this.currPlayerGW.yellowCards);
    // _formKey.currentState.setInternalFieldValue('red', this.currPlayerGW.redCards);
    // _formKey.currentState.setInternalFieldValue('owns', this.currPlayerGW.ownGoals);
    // _formKey.currentState.setInternalFieldValue('pens', this.currPlayerGW.penaltiesMissed);
    // _formKey.currentState.setInternalFieldValue('conceded', this.currPlayerGW.goalsConceded);
    // _formKey.currentState.setInternalFieldValue('bonus', '${this.currPlayerGW.bonus}');
  }
}
