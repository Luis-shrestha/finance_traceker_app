import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/ui/mainScreen/income/widget/addIncome.dart';
import '../../../configs/palette.dart';
import '../../../floorDatabase/entity/incomeEntity.dart';
import '../../../floorDatabase/entity/registerEntity.dart';
import '../../../supports/routeTransition/routeTransition.dart';
import '../../../supports/utils/sharedPreferenceManager.dart';
import '../../../utility/ToastUtils.dart';
import '../../../utility/applog.dart';
import '../../../utility/textStyle.dart';

class IncomeView extends StatefulWidget {
  final AppDatabase appDatabase;
  const IncomeView({super.key, required this.appDatabase});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  List<IncomeEntity> allIncome = [];
  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();
      AppLog.d("user details", "$username, $password");

      if (username != null && password != null) {
        user = await widget.appDatabase.registerDao.getUserByUsernameAndPassword(username, password);
        AppLog.d("user Id", "${user!.id}");
        if (user != null) {
          await getAllIncome();
        }
      }

    } catch (e) {
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getAllIncome() async {
    if (user != null) {
      List<IncomeEntity> list = await widget.appDatabase.incomeDao.findIncomesByUserId(user!.id!);
      setState(() {
        allIncome = list;
      });
    }
  }

  Future<void> deleteIncome(IncomeEntity income) async {
    await widget.appDatabase.incomeDao.deleteIncome(income);
    Toastutils.showToast('Delete Successfully');
    getAllIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, customPageRouteBuilder(AddIncomeView(database: widget.appDatabase, updateIncome: getAllIncome)));
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add, color: Colors.blue),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade100,
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : allIncome.isEmpty
              ? const Center(child: Text("Income details will be shown here"))
              : ListView.builder(
            itemCount: allIncome.length,
            itemBuilder: (context, index) {
              return IncomeListItem(
                income: allIncome[index],
                onEdit: () {
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
                },
                onDelete: () => deleteIncome(allIncome[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class IncomeListItem extends StatelessWidget {
  final IncomeEntity income;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const IncomeListItem({
    Key? key,
    required this.income,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(100, 100, 100, 100),
          items: [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ).then((value) {
          if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        });
      },
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              income.category!,
              style: regularTextStyle(
                textColor: Colors.black,
                fontSize: 25,
                fontFamily: 'arial',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "NPR. ${income.amount!}",
              style: regularTextStyle(
                textColor: Colors.black,
                fontSize: 20,
                fontFamily: 'arial',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Text(
          income.date!,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18.0,
            color: Colors.green,
            fontFamily: 'arial',
          ),
        ),
      ),
    );
  }
}
