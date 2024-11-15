import 'package:flutter/material.dart';

import '../../../../utility/textStyle.dart';

class IncomeExpensesCardView extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const IncomeExpensesCardView(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            minRadius: 25,
            child: Icon(
              icon,
              size: 35,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regularTextStyle(textColor: color, fontSize: 15),
              ),
              Text(
                'Rs. $amount',
                style: regularTextStyle(
                    textColor: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }
}
