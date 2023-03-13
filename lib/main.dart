import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:strive/auth.dart';
import 'package:strive/loading.dart';
import 'package:strive/login.dart';
import 'package:strive/profile_page.dart';
import 'package:strive/strive_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          //checking for errors
          if (snapshot.hasError) {}
          //Once complete, show app:
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Strive!',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: const MaterialColor(0xFFE2E2F0, <int, Color>{
                  50: Color(0xFFE2E2F0),
                  100: Color(0xFFE2E2F0),
                  200: Color(0xFFE2E2F0),
                  300: Color(0xFFE2E2F0),
                  400: Color(0xFFE2E2F0),
                  500: Color(0xFFE2E2F0),
                  600: Color(0xFFE2E2F0),
                  700: Color(0xFFE2E2F0),
                  800: Color(0xFFE2E2F0),
                  900: Color(0xFFE2E2F0),
                }),
                primaryColor: const Color(0xFFE2E2F0),
                canvasColor: Colors.white12,
              ),
              home: const HomePage(title: 'Strive Home'),
            );
          }
          Widget loading = const MaterialApp();
          return loading;
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error!'),
          );
        } else if (snapshot.hasData) {
          String? userID() {
            if (snapshot.hasData) {
              return snapshot.data!.uid;
            } else {
              return '';
            }
          }

          return ProfilePage(userID().toString());
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
