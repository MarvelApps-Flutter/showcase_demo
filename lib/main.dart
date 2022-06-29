import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database_app/constants/app_constants.dart';
import 'package:realtime_database_app/screens/home_screen.dart';
import 'package:realtime_database_app/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.titleString,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
      ),
    );
  }
}

