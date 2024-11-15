import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/ui/custom/customProceedButton.dart';
import 'package:sales_tracker/ui/mainScreen/homeScreen.dart';
import 'package:sales_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../floorDatabase/database/database.dart';
import '../../floorDatabase/entity/registerEntity.dart';
import '../../supports/utils/sharedPreferenceManager.dart';
import '../../utility/applog.dart';
import '../../utility/textStyle.dart';

class LoginScreen extends StatefulWidget {
  final AppDatabase appDatabase;

  const LoginScreen({super.key, required this.appDatabase});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<RegisterEntity> userDetails = [];
  var _formKey = GlobalKey<FormState>();
  bool _obscurePassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void initState() {
    super.initState();
    _loadFingerprintSetting();
  }

  Future<void> _loadFingerprintSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFingerprintEnable =
          prefs.getBool(SharedPreferenceManager.isFingerprintEnroll) ?? false;
    });
  }

  Future<bool> _validateCredentials(String username, String password) async {
    final user = await widget.appDatabase.registerDao
        .getUserByUsernameAndPassword(username, password);
    if (user != null && user.password == password) {
      return true;
    }
    return false;
  }

  final LocalAuthentication auth = LocalAuthentication();
  late bool isFingerprintEnable = false;

  void fingerprintEnable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFingerprintEnable =
      prefs.getBool(SharedPreferenceManager.isFingerprintEnroll)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.all(doublePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header(),
                SizedBox(height: 32.0),
                form(),
                SizedBox(height: 32.0),
                button(),
                SizedBox(height: 4.0),
                fingerPrint(),
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
      key: _formKey,
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
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          final isValid = await _validateCredentials(
              userNameController.text, passwordController.text);

          AppLog.i("username And Password",
              "${userNameController.text}, ${passwordController.text}");
          if (isValid) {
            await SharedPreferenceManager.setUsername(userNameController.text);
            await SharedPreferenceManager.setPassword(passwordController.text);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(appDatabase: widget.appDatabase),
              ),
            );
          } else {
            // Show an error message if credentials are invalid
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid username or password'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: CustomProceedButton(titleName: 'Login'),
    );
  }

  Widget fingerPrint() {
    if (isFingerprintEnable) {
      return IconButton(
        onPressed: () async {
         try{
           final bool canAuthenticateWithBiometric =
           await auth.canCheckBiometrics;
           if (canAuthenticateWithBiometric) {
             final bool didAuthenticate = await auth.authenticate(
                 localizedReason: "Please authenticate to login or use password",
                 options: const AuthenticationOptions(
                   biometricOnly: true,
                 ));
           }
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) =>
                   HomeScreen(appDatabase: widget.appDatabase),
             ),
           );
         }catch(e){
           AppLog.e("Error while using fingerprint", "${e}");
         }
        },
        icon: Icon(
          Icons.fingerprint,
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget registerText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: regularTextStyle(textColor: Colors.black, fontSize: 15),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the Register Page
            final tabController = DefaultTabController.of(context);
            if (tabController != null) {
              // Switch to the second tab (index 1 for Register)
              tabController.animateTo(1);
            }
          },
          child: Text(
            "Register Here",
            style: regularTextStyle(textColor: Colors.red, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
