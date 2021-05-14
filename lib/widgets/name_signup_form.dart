import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/player_pic_grid.dart';

class NameSignupForm extends StatefulWidget {
  @override
  _NameSignupFormState createState() => _NameSignupFormState();
}

final _formKeyName = GlobalKey<FormBuilderState>();

class _NameSignupFormState extends State<NameSignupForm> {
  String teamName;
  String name;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: BuildForm(),
      ),
    );
  }

  Widget SignupTextForm(String name, String label, bool pwd,
      {TextInputType keyboard = TextInputType.text, String initial = ""}) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          child: FormBuilderTextField(
            initialValue: initial,
            name: name,
            textCapitalization: keyboard == TextInputType.text
                ? TextCapitalization.words
                : TextCapitalization.none,
            obscureText: pwd,
            decoration: InputDecoration(
              labelText: label,
            ),
            // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose(validators),
            keyboardType: keyboard,
            textInputAction: TextInputAction.next,
          ),
        ),
      ]),
    );
  }

  Widget BuildForm() {
    List<Widget> columnChildren = _columnChildrenWithTitle();
    _addNameForm(columnChildren);
    columnChildren.add(_submitButton());
    if (loading) columnChildren.add(CircularProgressIndicator());

    // Make up for white space with a picture
    columnChildren.add(PlayerPicGrid());

    return Container(
      height: MediaQuery.of(context).size.height * 1.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnChildren
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8),
                child: e,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _columnChildrenWithTitle() {
    List<Widget> columnChildren = [
      Container(
        child: Text("Confirm Name Details", style: TextStyle(fontSize: 20)),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    ];
    return columnChildren;
  }

  void _addNameForm(List<Widget> columnChildren) {
    LoggedInUser user = Provider.of<LoggedInUser>(context, listen: false);

    columnChildren.add(FormBuilder(
      key: _formKeyName,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SignupTextForm("displayName", "Display Name *", false,
              keyboard: TextInputType.text, initial: user.name ?? ""),
          SignupTextForm("teamName", "Enter Team Name *", false,
              keyboard: TextInputType.text),
        ],
      ),
    ));
  }

  Widget _submitButton() {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async {
          if (_formKeyName.currentState.saveAndValidate()) {
            setState(() {
              this.name = _formKeyName.currentState.value["displayName"];
              this.teamName = _formKeyName.currentState.value["teamName"];

              // Set user details
              LoggedInUser user =
                  Provider.of<LoggedInUser>(context, listen: false);
              user.signingUp = true;
              user.teamName = this.teamName;
              user.name = this.name;

              // Dismiss keyboard
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }

              // Go to loading
              Navigator.pushReplacementNamed(context, Routes.Loading);
            });
          }
        },
      ),
    );
  }
}
