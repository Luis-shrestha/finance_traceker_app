import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/ui/mainScreen/statistics/expenses/widget/addExpense.dart';

import '../../../../configs/palette.dart';
import '../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../supports/routeTransition/routeTransition.dart';
import '../../../../utility/ToastUtils.dart';
import '../../../../utility/textStyle.dart';
import '../../../userData/userDataService.dart';

class ExpenseView extends StatefulWidget {
  final AppDatabase appDatabase;
  const ExpenseView({super.key, required this.appDatabase});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {

  List<ExpensesEntity> allExpenses = [];

  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  
  Future<void> getUserData() async {
    UserDataService userDataService = UserDataService(widget.appDatabase);
    user = await userDataService.getUserData(context);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await getAllExpenses();
    }
  }

  getAllExpenses() async{
    List<ExpensesEntity> list = await widget.appDatabase.expensesDao.findExpensesByUserId(user!.id!);
    setState(() {
      allExpenses = list;
    });
  }

  void deleteExpenses(ExpensesEntity expenses) async {
    await widget.appDatabase.expensesDao.deleteExpenses(expenses);
   Toastutils.showToast('Delete successful');
    getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,  customPageRouteBuilder(AddExpenseView(database: widget.appDatabase, updateIncome: getAllExpenses,)));
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add,color: Colors.blue,),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade100,
          child: allExpenses.isEmpty
              ? const Center(child: Text("Expenses details will be shown here"))
              : ListView.builder(
            itemCount: allExpenses.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  // Show the menu when long-pressed
                  showMenu(
                    context: context,
                    position:
                    const RelativeRect.fromLTRB(100, 100, 100, 100),
                    items: [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpenseView(
                            database: widget.appDatabase,
                            updateIncome: getAllExpenses,
                            expenseEntity: allExpenses[index],
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      deleteExpenses(allExpenses[index]);
                    }
                  });
                },
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allExpenses[index].category!,
                        style: regularTextStyle(
                            textColor: Colors.black,
                            fontSize: 25,
                            fontFamily:'arial',
                            fontWeight: FontWeight.w500
                        ),
                      ),

                      Text(
                        "NPR. ${allExpenses[index].amount!}",
                        style: regularTextStyle(
                            textColor: Colors.black,
                            fontSize: 20,
                            fontFamily:'arial',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    allExpenses[index].date!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                        color: Colors.green,
                        fontFamily: 'arial'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
