import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  Widget body;
  Function onPress;
  SummaryContainer({this.body, this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPress,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black38.withAlpha(170),
        ),
        margin: EdgeInsets.all(3),
        child: FittedBox(fit: BoxFit.scaleDown, child: body),
      ),
    );
  }
}
