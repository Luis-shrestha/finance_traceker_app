
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/ui/custom/customProceedButton.dart';
import 'package:sales_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:sales_tracker/utility/ToastUtils.dart';
import 'package:sales_tracker/utility/textStyle.dart';

enum CategoryLabel {
  Food_and_Drinks,
  Loan_Payment,
  Daily_Expenses,
  // Add other categories as needed
}

class AddExpenseView extends StatefulWidget {
  final AppDatabase database;
  final Function updateIncome;
  final ExpensesEntity? expenseEntity;

  const AddExpenseView({
    super.key,
    required this.database,
    required this.updateIncome,
    this.expenseEntity,
  });

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.expenseEntity!=null){
      amountController.text = widget.expenseEntity!.amount!.toString();
      dateController.text = widget.expenseEntity!.date!.toString();
      categoryController.text = widget.expenseEntity!.category!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseEntity == null ? "Add Expenses" : "Update Expenses",
          style: LargeTextStyle(textColor: Colors.black, fontSize: 25),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(padding),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                      controller: amountController,
                      hintText: 'Enter amount',
                      labelText: 'Amount',
                      prefixIcon: Icons.money,
                      keyboardType: TextInputType.number,

                    ),
                    SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownMenu<CategoryLabel>(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * .92,
                          controller: categoryController,
                          enableFilter: true,
                          enableSearch: true,
                          requestFocusOnTap: true,
                          leadingIcon: const Icon(
                            Icons.category_outlined, color: Colors.grey,),
                          label: const Text(
                            'Select Category',
                            style: TextStyle(
                              fontSize: 16, // Customize label font size
                              color: Colors.grey, // Customize label color
                            ),
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue, // Border color
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors
                                    .blueAccent, // Focused border color
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, // Error border color
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors
                                    .redAccent, // Focused error border color
                              ),
                            ),
                          ),
                          dropdownMenuEntries: <DropdownMenuEntry<
                              CategoryLabel>>[
                            DropdownMenuEntry(
                              value: CategoryLabel.Food_and_Drinks,
                              label: 'Food_and_Drinks',
                            ),
                            DropdownMenuEntry(
                              value: CategoryLabel.Loan_Payment,
                              label: 'Loan_Payment',
                            ),
                            DropdownMenuEntry(
                              value: CategoryLabel.Daily_Expenses,
                              label: 'Daily_Expenses',
                            ),
                            // Add more entries as needed
                          ],
                        ),
                      ],
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
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void save() async {
    if (key.currentState!.validate()) {
      if (widget.expenseEntity==null){
        ExpensesEntity expenses = ExpensesEntity(
          amount: amountController.text,
          date: dateController.text,
          category: categoryController.text,
        );
        await widget.database.expensesDao.insertExpenses(expenses);
        Toastutils.showToast('Added Successfully');
        Navigator.pop(context);
        widget.updateIncome();
      } else{
        ExpensesEntity expenses = ExpensesEntity(
          id: widget.expenseEntity!.id,
          amount: amountController.text,
          date: dateController.text,
          category: categoryController.text,
        );
        await widget.database.expensesDao.updateExpenses(expenses);
        Toastutils.showToast("Data has been updated.");
        Navigator.pop(context);
        widget.updateIncome();
      }
    }
  }
}