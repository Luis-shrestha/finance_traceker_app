import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/ui/mainScreen/income/widget/addIncome.dart';

import '../../../configs/palette.dart';
import '../../../floorDatabase/entity/incomeEntity.dart';
import '../../../supports/routeTransition/routeTransition.dart';

class IncomeView extends StatefulWidget {
  final AppDatabase appDatabase;
  const IncomeView({super.key, required this.appDatabase});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {

  List<IncomeEntity> allIncome = [];

  getAllIncome() async{
    List<IncomeEntity> list = await widget.appDatabase.mainDao.getAllIncome();
    setState(() {
      allIncome = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,  customPageRouteBuilder(AddIncomeView(database: widget.appDatabase, updateIncome: getAllIncome,)));
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add,color: Palette.contentColorBlue,),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
