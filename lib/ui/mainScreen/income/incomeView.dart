import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/ui/mainScreen/income/widget/addIncome.dart';

import '../../../configs/palette.dart';
import '../../../floorDatabase/entity/incomeEntity.dart';
import '../../../supports/routeTransition/routeTransition.dart';
import '../../../utility/textStyle.dart';

class IncomeView extends StatefulWidget {
  final AppDatabase appDatabase;
  const IncomeView({super.key, required this.appDatabase});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {

  List<IncomeEntity> allIncome = [];

  getAllIncome() async{
    List<IncomeEntity> list = await widget.appDatabase.incomeDao.getAllIncome();
    setState(() {
      allIncome = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllIncome();
  }

  void deleteIncome(IncomeEntity income) async {
    await widget.appDatabase.incomeDao.deleteIncome(income);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success',
        message:
        'Delete successful',

        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
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
        child: Icon(Icons.add,color: Colors.blue,),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade100,
          child: allIncome.isEmpty
              ? const Center(child: Text("Income details will be shown here"))
              : ListView.builder(
            itemCount: allIncome.length,
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
                          builder: (context) => AddIncomeView(
                            database: widget.appDatabase,
                            updateIncome: getAllIncome,
                            incomeEntity: allIncome[index],
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      deleteIncome(allIncome[index]);
                    }
                  });
                },
                child: ListTile(
                  title: Text(
                    allIncome[index].category!,
                    style: regularTextStyle(
                        textColor: Colors.black,
                        fontSize: 25,
                        fontFamily:'arial',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  subtitle: Text(
                    allIncome[index].date!,
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
