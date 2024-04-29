import 'package:flutter/material.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WifiSettingsWidget(),
            _BluetoothSettingsWidget(),
            _SaveButtonWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BoottomNavigationWidget(),
    );
  }
}

class _WifiSettingsWidget extends StatefulWidget {
  const _WifiSettingsWidget();

  @override
  _WifiSettingsWidgetState createState() => _WifiSettingsWidgetState();
}

class _WifiSettingsWidgetState extends State<_WifiSettingsWidget> {
  bool _isWifiSettingsDataVisible = false;
  void _toggleWifiSettingsDataVisibility() {
    setState(() {
      _isWifiSettingsDataVisible = !_isWifiSettingsDataVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _toggleWifiSettingsDataVisibility,
              icon: const Icon(Icons.star),
            ),
            const Text('WI-FI Settings'),
          ],
        ),
        if (_isWifiSettingsDataVisible) const _WifiSettingsDataWidget(),
      ],
    );
  }
}

class _WifiSettingsDataWidget extends StatelessWidget {
  const _WifiSettingsDataWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 1, 35, 63),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Логин',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Пароль',
            ),
          ),
        ],
      ),
    );
  }
}

class _BluetoothSettingsWidget extends StatefulWidget {
  const _BluetoothSettingsWidget();

  @override
  State<_BluetoothSettingsWidget> createState() =>
      _BluetoothSettingsWidgetState();
}

class _BluetoothSettingsWidgetState extends State<_BluetoothSettingsWidget> {
  bool _isBluetoothSettingsDataVisible = false;

  void _toggleBluetoothSettingsDataVisibility() {
    setState(() {
      _isBluetoothSettingsDataVisible = !_isBluetoothSettingsDataVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: _toggleBluetoothSettingsDataVisibility,
                icon: const Icon(Icons.star)),
            const Text('BT Settings'),
          ],
        ),
         if (_isBluetoothSettingsDataVisible) const _BluetoothSettingsDataWidget(),
      ],
    );
  }
}

class _BluetoothSettingsDataWidget extends StatelessWidget {
  const _BluetoothSettingsDataWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 1, 35, 63),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ssid',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SaveButtonWidget extends StatelessWidget {
  const _SaveButtonWidget();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Сохранить'),
    );
  }
}
