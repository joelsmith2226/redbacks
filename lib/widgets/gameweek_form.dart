import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/playerGameweek.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_gameweek_form.dart';

class GameweekForm extends StatefulWidget {
  @override
  _GameweekFormState createState() => _GameweekFormState();
}

class _GameweekFormState extends State<GameweekForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormBuilderState> _gameFormKey =
      GlobalKey<FormBuilderState>();
  final double heightMultiplier = 0.4;

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
    _stage = this.GW.stage;

    return this._stage == 0 ? GameweekForm() : PlayerGameweekForm();
  }

  Widget GameweekForm() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * heightMultiplier,
              child: gameScoreForm()),
          gameScoreActions(),
        ],
      ),
    );
  }

  Widget gameScoreForm() {
    String opposition = this.GW.opposition == null ? "" : this.GW.opposition;
    List<String> score =
        this.GW.gameScore == null ? ["", ""] : this.GW.gameScore.split("-");
    if (score.length != 2) score = ["", ""];
    List<Widget> _formElements = <Widget>[
      NumberForm(user.gwHistory.length + 1, GAMEWEEK, "Gameweek #"),
      TextForm(OPPOSITION, "Enter Opposition", initial: opposition, width: 0.3),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextForm(HOME, "Redbacks", req: true, initial: score[0], width: 0.3),
        Text('-'),
        TextForm(AWAY, "Opposition", req: true, initial: score[1], width: 0.3)
      ]),
      SizedBox(height: 15),
      Text(
        "Enter Score",
        textAlign: TextAlign.center,
      )
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
          String home = _gameFormKey.currentState.value[HOME];
          String away = _gameFormKey.currentState.value[AWAY];
          print('_');
          this.GW.gameScore = "${home}-${away}";
          this.GW.id = _gameFormKey.currentState.value[GAMEWEEK];
          this.GW.opposition = _gameFormKey.currentState.value[OPPOSITION];
          this.GW.stage = 1;
        });
        print("Gameweek saved");
      },
    );
  }

  Widget _form(List<Widget> formElements, GlobalKey<FormBuilderState> key) {
    String opposition = this.GW.opposition == null ? "" : this.GW.opposition;
    List<String> score =
        this.GW.gameScore == null ? ["", ""] : this.GW.gameScore.split("-");
    if (score.length != 2) score = ["", ""];
    return FormBuilder(
      key: key,
      child: Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              NumberForm(user.gwHistory.length + 1, GAMEWEEK, "Gameweek #"),
              TextForm(OPPOSITION, "Enter Opposition", initial: opposition),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextForm(HOME, "Redbacks",
                    req: true, initial: score[0], width: 0.3),
                Text('-'),
                TextForm(AWAY, "Opposition",
                    req: true, initial: score[1], width: 0.3)
              ]),
              SizedBox(height: 15),
              Text(
                "Enter Score",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget TextForm(String name, String label,
      {req = false, String initial = "", double width = 0.75}) {
    var validators = [
      FormBuilderValidators.required(context),
    ];

    return Container(
      width: MediaQuery.of(context).size.width * width,
      child: FormBuilderTextField(
        textAlign: TextAlign.center,
        initialValue: initial,
        name: name,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: FormBuilderValidators.compose(validators),
        keyboardType: TextInputType.text,
        onEditingComplete: () => saveCurrPlayerGWState(this._gameFormKey),
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
                saveCurrPlayerGWState(
                    this._stage == 0 ? this._gameFormKey : this._currKey);
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
      options: List.generate(
          options.length,
          (index) => FormBuilderFieldOption(
              value: options[index], child: Text(options[index]))),
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
}
