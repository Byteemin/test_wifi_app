import 'package:flutter/material.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';

class NetworkData extends StatelessWidget {
  const NetworkData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Экран данныйх по вай фай'),
      ),
      bottomNavigationBar: BoottomNavigationWidget(),
    );
  }
}