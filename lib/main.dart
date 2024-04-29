import 'package:flutter/material.dart';
import 'package:test_wifi_app/screens/network_connection_screen.dart';
// import 'package:test_wifi_app/screens/network_settings_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NetworkConectionSreen.create(),
    );
  }
}


// UserSettingsScreen.create()
// NetworkConectionSreen.create()