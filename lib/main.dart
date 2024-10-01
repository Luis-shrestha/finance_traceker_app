import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_tracker/supports/utils/sharedPreferenceManager.dart';
import 'package:sales_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'floorDatabase/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_tracker/ui/authenticationScreen/loginScreen.dart';
import 'package:sales_tracker/ui/mainScreen/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  final dbPath = "${appDocDir.path}/finance_tracker.db";

  // Initialize the database
  final appDatabase = await $FloorAppDatabase.databaseBuilder(dbPath).build();

  // Check for existing username and password in SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedUsername = prefs.getString(SharedPreferenceManager.username);
  String? storedPassword = prefs.getString(SharedPreferenceManager.password);

  // Ensure isLoggedIn is a boolean value
  bool isLoggedIn = (storedUsername != null && storedUsername.isNotEmpty) &&
      (storedPassword != null && storedPassword.isNotEmpty);

  runApp(MyApp(
    appDatabase: appDatabase,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;
  final bool isLoggedIn;

  const MyApp({super.key, required this.appDatabase, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? HomeScreen(appDatabase: appDatabase)
          : LoginRegisterView(appDatabase: appDatabase),
    );
  }
}
