import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:sales_tracker/ui/mainScreen/dashboard/widget/incomeExpensesCard.dart';
import 'package:sales_tracker/utility/ToastUtils.dart';
import '../../../floorDatabase/entity/registerEntity.dart';
import '../../../supports/utils/sharedPreferenceManager.dart';

class DashboardView extends StatefulWidget {
  final AppDatabase appDatabase;

  const DashboardView({super.key, required this.appDatabase});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<IncomeEntity> allIncome = [];
  List<ExpensesEntity> allExpenses = [];
  RegisterEntity? user;
  bool isLoading = true;

  // Variables to hold total amounts
  double? totalIncome;
  double? totalExpenses;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch username and password from shared preferences
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();

      if (username != null && password != null) {
        user = await widget.appDatabase.registerDao
            .getUserByUsernameAndPassword(username, password);

        if (user != null) {
          // Fetch income and expenses if user is found
          await getAllIncomeAndExpenses();
        }
      } else {
        throw Exception("Username or password is missing.");
      }
    } catch (e) {
      print("Error loading user data: $e");
      Toastutils.showToast('Failed to load user data');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getAllIncomeAndExpenses() async {
    if (user != null) {
      // Fetch total income and expenses and cast as double
      totalIncome = (await widget.appDatabase.incomeDao.getTotalIncomeByUserId(user!.id!) ?? 0.0).toDouble();
      totalExpenses = (await widget.appDatabase.expensesDao.getTotalExpensesByUserId(user!.id!) ?? 0.0).toDouble();

      // Fetch all income and expenses details
      allIncome = await widget.appDatabase.incomeDao.findIncomesByUserId(user!.id!);
      allExpenses = await widget.appDatabase.expensesDao.findExpensesByUserId(user!.id!);

      // Update the UI after fetching data
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator if loading
        : SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          totalAmount(),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget totalAmount() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 2,
        children: [
          IncomeExpensesCardView(
            title: "Total Income",
            amount: totalIncome != null? totalIncome!.toStringAsFixed(2) : "0.0",
            icon: Icons.insert_chart,
            color: Colors.green,
          ),
          IncomeExpensesCardView(
            title: "Total Expenses",
            amount:totalExpenses != null? totalExpenses!.toStringAsFixed(2) : "0.0",
            icon: Icons.insert_chart_sharp,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
