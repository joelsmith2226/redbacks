import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';

class FormWidgets {
  FormWidgets();

  Widget TextForm(String name, String label, BuildContext context,
      {req = false, String initial = "", double width = 0.75}) {
    var validators = [
      FormBuilderValidators.required(context),
    ];
    UniqueKey key = UniqueKey();
    return Container(
      width: MediaQuery.of(context).size.width * width,
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

  Widget NumberForm(int value, String name, String label,
      {Function onChanged}) {
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
                onChanged(val);
              },
            );
          },
        ),
      ],
    );
  }

  Widget dropdownForm(String name, String label, List<String> options,
      {String initial = "", Function onChanged}) {
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
          (index) => FormBuilderFieldOption(
              value: options[index],
              child: Text(
                options[index],
                style: TextStyle(fontSize: 10),
              ))),
      onChanged: (val) {
        onChanged(val);
      },
    );
  }
}
