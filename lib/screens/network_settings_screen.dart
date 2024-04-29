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
            SizedBox(height: 30),
            _BltetoothSettings(),
            SizedBox(height: 30),
            _SaveButtonWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BoottomNavigationWidget(),
    );
  }
}

class _WifiSettingsWidget extends StatelessWidget {
  const _WifiSettingsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
            const Text('WI-FI Settings'),
          ],
        ),
        const _WifiSettingsDataWidget(),
      ],
    );
  }
}

class _WifiSettingsDataWidget extends StatefulWidget {
  const _WifiSettingsDataWidget();

  @override
  State<_WifiSettingsDataWidget> createState() => _WifiSettingsDataWidgetState();
}

class _WifiSettingsDataWidgetState extends State<_WifiSettingsDataWidget> {
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

class _BltetoothSettings extends StatelessWidget {
  const _BltetoothSettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
            const Text('BT Settings'),
          ],
        ),
        const _BluetoothSettingsDataWidget(),
      ],
    );
  }
}

class _BluetoothSettingsDataWidget extends StatefulWidget {
  const _BluetoothSettingsDataWidget();

  @override
  State<_BluetoothSettingsDataWidget> createState() =>
      _BluetoothSettingsDataWidgetState();
}

class _BluetoothSettingsDataWidgetState
    extends State<_BluetoothSettingsDataWidget> {
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
                  // border: OutlineInputBorder(),
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
