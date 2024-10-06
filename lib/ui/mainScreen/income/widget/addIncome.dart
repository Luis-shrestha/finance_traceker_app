import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:sales_tracker/ui/custom/customProceedButton.dart';
import 'package:sales_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:sales_tracker/utility/ToastUtils.dart';
import 'package:sales_tracker/utility/textStyle.dart';

enum CategoryLabel {
  salary,
  bonus,
  commission,
  // Add other categories as needed
}

class AddIncomeView extends StatefulWidget {
  final AppDatabase database;
  final Function updateIncome;
  final IncomeEntity? incomeEntity;

  const AddIncomeView({
    super.key,
    required this.database,
    required this.updateIncome,
    this.incomeEntity,
  });

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.incomeEntity!=null){
      amountController.text = widget.incomeEntity!.amount!.toString();
      dateController.text = widget.incomeEntity!.date!.toString();
      categoryController.text = widget.incomeEntity!.category!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.incomeEntity == null ? "Add Note" : "Update Note",
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
                              value: CategoryLabel.salary,
                              label: 'Salary',
                            ),
                            DropdownMenuEntry(
                              value: CategoryLabel.bonus,
                              label: 'Bonus',
                            ),
                            DropdownMenuEntry(
                              value: CategoryLabel.commission,
                              label: 'Commission',
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
      if (widget.incomeEntity==null){
        IncomeEntity income = IncomeEntity(
          amount: amountController.text,
          date: dateController.text,
          category: categoryController.text,
        );
        await widget.database.incomeDao.insertIncome(income);

       Toastutils.showToast( 'Added Successfully');
        Navigator.pop(context);
        widget.updateIncome();
      } else{
        IncomeEntity income = IncomeEntity(
          id: widget.incomeEntity!.id,
          amount: amountController.text,
          date: dateController.text,
          category: categoryController.text,
        );
        await widget.database.incomeDao.updateIncome(income);
        Toastutils.showToast( 'Data Updated Successfully');
        Navigator.pop(context);
        widget.updateIncome();
      }
    }
  }
}