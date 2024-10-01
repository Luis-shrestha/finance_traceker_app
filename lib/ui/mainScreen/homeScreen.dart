import 'package:flutter/material.dart';
import 'package:sales_tracker/configs/palette.dart';
import 'package:sales_tracker/ui/mainScreen/dashboard/dashboardView.dart';
import 'package:sales_tracker/ui/mainScreen/income/incomeView.dart';
import 'package:sales_tracker/utility/textStyle.dart';

import '../../floorDatabase/database/database.dart';

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
    'Details',
  ];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      DashboardView(appDatabase: widget.appDatabase),
      IncomeView(appDatabase: widget.appDatabase),
      Text(
        'Expenses',
        style: optionStyle,
      ),
      Text(
        'Details',
        style: optionStyle,
      ),
    ];
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
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
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
            ListTile(
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Income'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Expenses'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('See Details'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

