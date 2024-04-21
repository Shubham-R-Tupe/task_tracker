import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'View/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins'
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(), // Initialize SharedPreferences
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error initializing SharedPreferences: ${snapshot.error}'),
              );
            } else {
              final SharedPreferences prefs = snapshot.data!;
              return HomeScreen(
                  prefs: prefs); // Pass SharedPreferences to HomeScreen
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
