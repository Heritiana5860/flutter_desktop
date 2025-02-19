import 'package:flutter/material.dart';
import 'package:tragnambo/pages/dashboard.dart';
import 'package:tragnambo/pages/form_page.dart';
import 'package:tragnambo/pages/liste.dart';
import 'package:tragnambo/pages/login.dart';
import 'package:tragnambo/pages/statistic/statistique_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SignInScreen(),
        "/dashboard": (context) => Dashboard(),
        "/formpage": (context) => FormPage(),
        "/liste": (context) => MembersList(),
        "/stats": (context) => StatisticsPage(),
      },
    );
  }
}
