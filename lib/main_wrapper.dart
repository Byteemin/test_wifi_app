import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:test_wifi_app/views/network_connection_view.dart';
import 'package:test_wifi_app/views/network_data_view.dart';
import 'package:test_wifi_app/views/network_settings_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    super.key,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const NetworkData(),
    UserSettingsScreen.create(),
    NetworkConectionSreen.create(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      floatingActionButton: _selectedIndex == 2
          ? null // Если мы находимся во вкладке NetworkConectionSreen, не отображаем кнопку
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex =
                      2; // Переключиться на вкладку NetworkConectionSreen
                });
              },
              backgroundColor: Colors.deepPurpleAccent,
              child: const Icon(
                  Icons.network_wifi), // Подходящая иконка для подключения
            ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: _onItemTapped,
        iconSize: 30,
        activeColor: Colors.black,
        selectedIndex: _selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Device',
          ),
          BarItem(
            icon: Icons.settings,
            title: 'Settings',
          ),
        ],
      ),
    );
  }
}
