import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/ui/mainScreen/dashboard/widget/incomeExpensesCard.dart';
import '../../reusableWidget/chart.dart';

class DashboardView extends StatefulWidget {
  final AppDatabase appDatabase;
  const DashboardView({super.key, required this.appDatabase});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBarChart(),
          SizedBox(height: 12.0),
          Container(
            child: IncomeExpensesCardView(appDatabase: widget.appDatabase,),
          ),
        ],
      ),
    );
  }
}

