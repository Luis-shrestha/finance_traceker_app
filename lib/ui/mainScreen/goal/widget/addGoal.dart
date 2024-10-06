import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:sales_tracker/ui/custom/customProceedButton.dart';
import 'package:sales_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:sales_tracker/utility/ToastUtils.dart';
import 'package:sales_tracker/utility/textStyle.dart';

import '../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../supports/utils/sharedPreferenceManager.dart';
import '../../../../utility/applog.dart';

class AddGoalView extends StatefulWidget {
  final AppDatabase database;
  final Function updateGoal;
  final GoalEntity? goalEntity;

  const AddGoalView({
    super.key,
    required this.database,
    required this.updateGoal,
    this.goalEntity,
  });

  @override
  State<AddGoalView> createState() => _AddGoalViewState();
}

class _AddGoalViewState extends State<AddGoalView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController goalNameController = TextEditingController();
  TextEditingController goalDescriptionController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  RegisterEntity? user;
  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.goalEntity != null) {
      amountController.text = widget.goalEntity!.amount!;
      dateController.text = widget.goalEntity!.date!;
      goalNameController.text = widget.goalEntity!.goalName!;
      goalDescriptionController.text = widget.goalEntity!.goalDescription!;
    }
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();

      AppLog.d("user details", "$username, $password");

      if (username != null && password != null) {
        user = await widget.database.registerDao.getUserByUsernameAndPassword(username, password);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              widget.goalEntity == null ? "Add Goal" : "Update Goal",
              style: LargeTextStyle(textColor: Colors.black, fontSize: 25),
            ),
            Container(
              padding: EdgeInsets.all(padding),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      line: 1,
                      controller: goalNameController,
                      hintText: 'Enter Goal Name',
                      labelText: 'Name',
                      prefixIcon: Icons.drive_file_rename_outline_outlined,
                    ),
                    SizedBox(height: 12.0),
                    CustomTextFormField(
                      line: 1,
                      controller: goalDescriptionController,
                      hintText: 'Enter goal description',
                      labelText: 'Description',
                      prefixIcon: Icons.description,
                    ),
                    SizedBox(height: 12.0),
                    CustomTextFormField(
                      line: 1,
                      controller: amountController,
                      hintText: 'Enter amount',
                      labelText: 'Amount',
                      prefixIcon: Icons.money,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12.0),
                    CustomTextFormField(
                      line: 1,
                      controller: dateController,
                      hintText: 'Enter date',
                      labelText: 'Date',
                      prefixIcon: Icons.calendar_month,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    SizedBox(height: 12.0),
                    // Add a button to submit the form and validate
                    GestureDetector(
                      onTap: () {
                        save();
                      },
                      child: CustomProceedButton(
                        titleName: 'save',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void save() async {
    if (key.currentState!.validate()) {
      if (widget.goalEntity == null) {
        GoalEntity expenses = GoalEntity(
            userId: user!.id!,
            amount: amountController.text,
            date: dateController.text,
            goalDescription: goalDescriptionController.text,
            goalName: goalNameController.text);
        await widget.database.goalDao.insertGoal(expenses);
        Toastutils.showToast('Added Successfully');
        Navigator.pop(context);
        widget.updateGoal();
      } else {
        GoalEntity expenses = GoalEntity(
            userId: user!.id!,
            id: widget.goalEntity!.id,
            amount: amountController.text,
            date: dateController.text,
            goalDescription: goalDescriptionController.text,
            goalName: goalNameController.text);
        await widget.database.goalDao.updateGoal(expenses);
        Toastutils.showToast("Data has been updated.");
        Navigator.pop(context);
        widget.updateGoal();
      }
    }
  }
}
