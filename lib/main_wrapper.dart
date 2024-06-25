import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:test_wifi_app/domain/service/bluetooth_service.dart';
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
  late BluetoothController bleController;

  @override
  void initState() {
    super.initState();
    bleController = BluetoothController(); // Инициализация BleController
  }

  @override
  void dispose() {
    bleController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      NetworkData.create(bleController),
      UserSettingsScreen.create(),
      NetworkConectionSreen.create(bleController),
    ];
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      floatingActionButton: _selectedIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              backgroundColor: Colors.deepPurpleAccent,
              child: const Icon(Icons.network_wifi),
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
