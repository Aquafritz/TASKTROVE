// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktroveprojects/Splash_Screen.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await SharedPreferences.getInstance();
    
    await Firebase.initializeApp( 
      options: FirebaseOptions(
        apiKey: "AIzaSyBuDxMqaJkS2b6t-saVBUxsivF97zhZGQc", 
        appId: "1:741440101599:android:777eeafd2033c7f701dd6a", 
        messagingSenderId: "741440101599",    
        projectId: "tasktrove-76a6b",
        authDomain: "tasktrove-76a6b.firebaseapp.com",
        storageBucket: "tasktrove-76a6b.appspot.com",
        )
        
    );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
       child: MainApp()
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (SplashScreen()),
      theme: Provider.of<ThemeProvider>(context).themeData,
      );
  }
}
