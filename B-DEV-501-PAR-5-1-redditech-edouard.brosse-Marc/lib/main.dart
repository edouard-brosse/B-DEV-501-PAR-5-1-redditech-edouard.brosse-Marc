import 'package:flutter/material.dart';
import 'package:redditech/connection.dart';
import 'package:provider/provider.dart';
import 'package:redditech/dashboard.dart';
import 'package:redditech/profile.dart';
import 'package:redditech/user.dart';
import 'package:redditech/search.dart';
import 'package:redditech/home.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redditech',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConnectPage(title: 'Redditech'),
      routes: {
        '/home': (context) => Home(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => Profile(),
        '/search' : (context) => Search(),
      },
    );
  }
}
