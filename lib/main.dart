import 'package:flutter/material.dart';
import 'user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}