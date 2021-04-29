import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/rFirebase/firebasePlayers.dart';
import 'package:redbacks/models/flag.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/form_widgets.dart';

class EditFlag extends StatefulWidget {
  Flag flag;
  Player player;

  EditFlag({this.flag, this.player});

  @override
  _EditFlagState createState() => _EditFlagState();
}

class _EditFlagState extends State<EditFlag> {
  final GlobalKey<FormBuilderState> _formKey =
      new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.white,
      child: Stack(
        children: [
          _flagForm(),
          // Actions
          Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [removeFlagButton(), newFlagButton()]),
          )
        ],
      ),
    );
  }

  Widget newFlagButton() {
    return MaterialButton(
        child: Text(
          "Save Flag",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
        onPressed: () {
          _formKey.currentState.save();
          if (_formKey.currentState.validate()) {
            Flag temp = _loadFormIntoFlag();
            showDialog(
              context: this.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Update flag"),
                  content: Text(
                    "${widget.player.name}:\n${temp.printStats()}",
                    style: TextStyle(
                        color: Colors.white,
                        backgroundColor:
                            temp.severity == 1 ? Colors.yellow : Colors.red),
                  ),
                  actions: [
                    MaterialButton(
                      textColor: Color(0xFF6200EE),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.player.flag = temp;
                        FirebasePlayers().setFlag(widget.player);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Updated flag for ${widget.player.name}")));
                      },
                      child: Text('Submit flag to DB'),
                    ),
                    MaterialButton(
                      textColor: Color(0xFF6200EE),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    )
                  ],
                );
              },
            );
          }
        });
  }

  MaterialButton removeFlagButton() {
    return MaterialButton(
      child: Text(
        "Remove Flag",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
      onPressed: () {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Remove flag"),
              content: Text(
                  "Are you sure you want to clear ${widget.player.name}'s flag?"),
              actions: [
                MaterialButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.player.flag = null;
                    FirebasePlayers().setFlag(widget.player);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Cleared flag for ${widget.player.name}")));
                  },
                  child: Text('Yes'),
                ),
                MaterialButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _flagForm() {
    return FormBuilder(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            FormWidgets().dropdownForm(
              SEVERITY,
              "Select Severity",
              ["Yellow", "Red"],
              initial: _severity(),
            ),
            SizedBox(height: 10),
            _messageTextField(MESSAGE, 'Enter Message'),
            SizedBox(height: 10),
            FormWidgets().dropdownForm(
              PERCENT,
              "Percentage Likely To Play",
              ["0%", "25%", "50%", "75%"],
              initial: "${widget.flag.percent}%",
            ),
          ],
        ),
      ),
    );
  }

  String _severity() {
    switch (widget.flag.severity) {
      case 2:
        return "Red";
      case 1:
        return "Yellow";
      default:
        return "";
    }
  }

  dynamic ifValidReturn(
      FormBuilderState currentState, String field, dynamic fallback) {
    return currentState.value[field] == null
        ? fallback
        : currentState.value[field];
  }

  Flag _loadFormIntoFlag() {
    String message = _formKey.currentState.value[MESSAGE];
    int severity = _severityFromOptions(_formKey.currentState.value[SEVERITY]);
    int percent = _percentFromOptions(_formKey.currentState.value[PERCENT]);
    return Flag(message, severity, percent);
  }

  int _severityFromOptions(String severity) {
    switch (severity) {
      case 'Yellow':
        return 1;
      case 'Red':
        return 2;
      default:
        return 0;
    }
  }

  int _percentFromOptions(String percent) {
    switch (percent) {
      case '0%':
        return 0;
      case '25%':
        return 25;
      case '50%':
        return 50;
      case '75%':
        return 75;
      default:
        return 0;
    }
  }

  Widget _messageTextField(String name, String label) {
    var validators = [
      FormBuilderValidators.required(context),
      FormBuilderValidators.max(context, 70)
    ];
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: FormBuilderTextField(
        name: name,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: FormBuilderValidators.compose(validators),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
