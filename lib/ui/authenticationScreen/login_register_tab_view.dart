import 'package:flutter/material.dart';
import 'package:sales_tracker/configs/palette.dart';
import 'package:sales_tracker/configs/iconsConstant.dart';
import 'package:sales_tracker/ui/authenticationScreen/loginScreen.dart';
import 'package:sales_tracker/ui/authenticationScreen/registerScreen.dart';

class LoginRegisterView extends StatelessWidget {
  const LoginRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.primaryColor,
                ),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 25,
                          child: IconsConstant.loginIcon,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Register"),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 25,
                          child: IconsConstant.registerIcon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: <Widget>[
                    LoginScreen(),
                    RegisterScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
