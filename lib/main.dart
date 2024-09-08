import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sales_tracker/supports/utils/sharedPreferenceManager.dart';
import 'package:sales_tracker/ui/authenticationScreen/loginScreen.dart';
import 'package:sales_tracker/ui/onBoardingScreen/onBoardingScreen.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    Timer(
      const Duration(seconds: 2),
          () {
        navigate();
      },
    );
  }

  navigate() async {
    bool isWalkThroughShown =
    await SharedPreferenceManager.getWalkthroughShown();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => isWalkThroughShown
            ? const LoginScreen()
            : const OnBoardingScreen(),
      ),
    );
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnBoardingView(),
      ),
    );*/
    if (isWalkThroughShown) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnBoardingScreen(),
    );
  }
}

