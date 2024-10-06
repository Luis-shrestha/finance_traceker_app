import 'package:flutter/material.dart';
import 'package:sales_tracker/configs/dimension.dart';
import 'package:sales_tracker/configs/palette.dart';
import 'package:sales_tracker/supports/utils/sharedPreferenceManager.dart';
import 'package:sales_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'package:sales_tracker/ui/mainScreen/dashboard/dashboardView.dart';
import 'package:sales_tracker/ui/mainScreen/expenses/expenseView.dart';
import 'package:sales_tracker/ui/mainScreen/goal/goalView.dart';
import 'package:sales_tracker/ui/mainScreen/income/incomeView.dart';
import 'package:sales_tracker/ui/mainScreen/profile/editProfile/EditProfile.dart';
import 'package:sales_tracker/ui/mainScreen/profile/profileView.dart';
import 'package:sales_tracker/utility/textStyle.dart';
import '../../floorDatabase/database/database.dart';
import '../../utility/routeTransition.dart';
import '../authenticationScreen/loginScreen.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase appDatabase;

  const HomeScreen({super.key, required this.appDatabase});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Dashboard',
    'Income',
    'Expenses',
    "Goal",
    'Details',
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      DashboardView(appDatabase: widget.appDatabase),
      IncomeView(appDatabase: widget.appDatabase),
      ExpenseView(appDatabase: widget.appDatabase),
      GoalView(appDatabase: widget.appDatabase),
      Center(
          child: Text('Details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    ];
  }

  void _logout() {
    SharedPreferenceManager.clearToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginRegisterView(appDatabase: widget.appDatabase)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(halfPadding),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    customPageRouteFromRight(ProfileView(appDatabase: widget.appDatabase,)),
                  );
                },
                icon: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: _buildDrawer(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Palette.primaryColor,
            ),
            child: Text(
              'Finance Tracker App',
              textAlign: TextAlign.center,
              style: mediumTextStyle(textColor: Colors.white, fontSize: 20),
            ),
          ),
          ...List.generate(_titles.length, (index) {
            return ListTile(
              title: Text(_titles[index]),
              selected: _selectedIndex == index,
              onTap: () {
                _onItemTapped(index);
                Navigator.pop(context);
              },
            );
          }),
          Divider(thickness: 1.5),
          ListTile(
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
