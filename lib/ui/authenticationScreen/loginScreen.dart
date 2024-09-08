import 'package:flutter/material.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/ui/custom/customProceedButton.dart';
import 'package:sales_tracker/ui/mainScreen/homeScreen.dart';
import 'package:sales_tracker/ui/reusableWidget/customTextFormField.dart';

import '../../utility/textStyle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var key = GlobalKey<FormState>();

  bool _obscurePassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(doublePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                header(),
                SizedBox(height: 32.0),
                form(),
                SizedBox(height: 32.0),
                button(),
                SizedBox(height: 16.0),
                registerText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo.png",
          height: 200,
        ),
        Text(
          "Welcome to Finance Tracker App",
          textAlign: TextAlign.center,
          style: LargeTextStyle(
            textColor: Colors.black,
            fontSize: 25,
          ),
        ),
        Text(
          "Login To continue",
          style: mediumTextStyle(
            textColor: Colors.black,
            fontSize: 23,
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: key,
      child: Column(
        children: [
          CustomTextFormField(
            line: 1,
            controller: userNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter username";
              }
              return null;
            },
            hintText: 'Enter your userName',
            labelText: 'username',
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 8.0),
          CustomTextFormField(
            line: 1,
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter password";
              }
              return null;
            },
            hintText: 'Enter your password',
            labelText: 'password',
            prefixIcon: Icons.lock,
            suffixIcon:
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: _togglePasswordVisibility,
            obscureText: _obscurePassword,
          ),
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: (){
        if(key.currentState!.validate()) {
          if (userNameController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        }
      },
      child: CustomProceedButton(titleName: 'Login'),
    );
  }

  Widget registerText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ",style: regularTextStyle(textColor: Colors.black, fontSize: 15),),
        GestureDetector(
          onTap: (){
            // Navigate to the Register Page
            final tabController = DefaultTabController.of(context);
            if (tabController != null) {
              // Switch to the second tab (index 1 for Register)
              tabController.animateTo(1);
            }
          },
          child: Text("Register Here",
          style: regularTextStyle(textColor: Colors.red, fontSize: 15),),
        ),
      ],
    );
  }
}
