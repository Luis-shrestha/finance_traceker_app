import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:sales_tracker/ui/mainScreen/goal/widget/addGoal.dart';
import 'package:sales_tracker/utility/ToastUtils.dart';

import '../../../configs/palette.dart';
import '../../../supports/routeTransition/routeTransition.dart';
import '../../../utility/textStyle.dart';
import '../income/widget/addIncome.dart';

class GoalView extends StatefulWidget {
  final AppDatabase appDatabase;
  const GoalView({super.key, required this.appDatabase});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  List<GoalEntity> allGoal = [];

  getAllGoal() async{
    List<GoalEntity> list = await widget.appDatabase.goalDao.getAllGoal();
    setState(() {
      allGoal = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllGoal();
  }

  void deleteIncome(GoalEntity goal) async {
    await widget.appDatabase.goalDao.deleteGoal(goal);
    Toastutils.showToast('Delete successful');
    getAllGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,  customPageRouteBuilder(AddGoalView(database: widget.appDatabase, updateGoal: getAllGoal,)));
        },
        backgroundColor: Palette.backgroundColor,
        child: Icon(Icons.add,color: Colors.blue,),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade100,
          child: allGoal.isEmpty
              ? const Center(child: Text("Goal details will be shown here"))
              : ListView.builder(
            itemCount: allGoal.length,
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
                          builder: (context) => AddGoalView(
                            database: widget.appDatabase,
                            updateGoal: getAllGoal,
                            goalEntity: allGoal[index],
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      deleteIncome(allGoal[index]);
                    }
                  });
                },
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allGoal[index].goalName!,
                        style: regularTextStyle(
                            textColor: Colors.black,
                            fontSize: 25,
                            fontFamily:'arial',
                            fontWeight: FontWeight.w500
                        ),
                      ),

                      Text(
                        "NPR. ${allGoal[index].amount!}",
                        style: regularTextStyle(
                            textColor: Colors.black,
                            fontSize: 20,
                            fontFamily:'arial',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  subtitle:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allGoal[index].goalDescription!,
                        style: regularTextStyle(
                            textColor: Colors.black54,
                            fontSize: 20,
                            fontFamily:'arial',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "until ${allGoal[index].date!}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0,
                            color: Colors.green,
                            fontFamily: 'arial'),
                      ),
                    ],
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
