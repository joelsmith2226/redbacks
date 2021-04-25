import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/widgets/pages/homepage_summary.dart';
import 'package:redbacks/widgets/pages/transfers_footer.dart';
import 'package:redbacks/widgets/summary_container.dart';

class TransfersSummary extends StatefulWidget {
  @override
  _TransfersSummaryState createState() => _TransfersSummaryState();
}

class _TransfersSummaryState extends State<TransfersSummary> {
  @override
  Widget build(BuildContext context) {
    LoggedInUser user = Provider.of<LoggedInUser>(context);
    String fts = user.freeTransfers == UNLIMITED
        ? UNLIMITED_SYMBOL
        : '${user.freeTransfers}';
    return Column(children: [
      HomepageSummary(
        bottomMargin: 0,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TransfersSummaryContainer("Free Transfers", fts),
            TransfersSummaryContainer("Hits Taken", "${user.hits}"),
            TransfersSummaryContainer("Bank", "\$${user.budget}m"),
          ],
        ),
      ),
      TransfersFooter()
    ]);
  }

  Widget TransfersSummaryContainer(String category, String value) {
    return SummaryContainer(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            category,
            style: TextStyle(fontSize: 11, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          color: Colors.black.withAlpha(50),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(value,
              style: TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.center),
          color: Theme.of(context).primaryColor.withAlpha(150),
        )
      ],
    ));
  }
}
