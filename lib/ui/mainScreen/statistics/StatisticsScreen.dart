import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/ui/mainScreen/statistics/goal/goalView.dart';
import 'package:sales_tracker/ui/mainScreen/statistics/income/incomeView.dart';

import '../../../configs/dimension.dart';
import '../../../configs/palette.dart';
import '../../../floorDatabase/entity/expensesEntity.dart';
import '../../../floorDatabase/entity/incomeEntity.dart';
import '../../../floorDatabase/entity/registerEntity.dart';
import '../../userData/userDataService.dart';
import 'expenses/expenseView.dart';

class StatisticsScreen extends StatefulWidget {
  final AppDatabase appDatabase;
  const StatisticsScreen({super.key, required this.appDatabase});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin{

  late TabController _tabController;

  RegisterEntity? user;
  bool isLoading = true;

  List<IncomeEntity> allIncome = [];
  List<ExpensesEntity> allExpenses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getUserData();
  }

  Future<void> getUserData() async {
    UserDataService userDataService = UserDataService(widget.appDatabase);
    user = await userDataService.getUserData(context);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await fetchIncomeAndExpenses();
    }
  }

  fetchIncomeAndExpenses() async {
    List<IncomeEntity> income = await widget.appDatabase.incomeDao.findIncomesByUserId(user!.id!);
    setState(() {
      allIncome = income;
    });
    List<ExpensesEntity> expenses = await widget.appDatabase.expensesDao.getAllExpenses();
    setState(() {
      allExpenses = expenses;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 0,
                color: Theme.of(context).shadowColor,
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: Palette.primaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: extraSmallPadding, horizontal: extraSmallPadding),
                  decoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).textTheme.bodySmall?.color,
                      isScrollable: false,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor:
                      Theme.of(context).textTheme.bodyLarge?.color,
                      labelStyle: const TextStyle(fontSize: 13),
                      tabs: const [
                        Tab(text: "Income"),
                        Tab(text: "Expenses"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      IncomeView(appDatabase: widget.appDatabase),
                      ExpenseView(appDatabase: widget.appDatabase),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
