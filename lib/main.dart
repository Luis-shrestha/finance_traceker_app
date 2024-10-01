import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'package:sales_tracker/ui/mainScreen/dashboard/dashboardView.dart';
import 'package:sales_tracker/ui/mainScreen/homeScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'floorDatabase/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clear old database (for debugging purposes, do not use in production)
  final appDocDir = await getApplicationDocumentsDirectory();
  final dbPath = "${appDocDir.path}/finance_tracker.db";

  // Delete old database if necessary (for testing)
  try {
    await deleteDatabase(dbPath);
  } catch (e) {
    print('Error deleting database: $e');
  }

  // Initialize the database
  final appDatabase = await $FloorAppDatabase.databaseBuilder(dbPath).build();

  // Run the app
  runApp(MyApp(appDatabase: appDatabase));
}


class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;

  const MyApp({super.key, required this.appDatabase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginRegisterView(appDatabase: appDatabase),
      // home: HomeScreen(appDatabase: appDatabase),
    );
  }
}
