import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workgest/screens/login.dart';

import 'utils/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,m
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}