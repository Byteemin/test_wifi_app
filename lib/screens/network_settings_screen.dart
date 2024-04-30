import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/entity/user.dart';
import 'package:test_wifi_app/domain/service/user_service.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';

class _ViewModel extends ChangeNotifier {
   final UserService _userService = UserService();
  
  final TextEditingController wifiNameController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();
  final TextEditingController bluetoothDeviceNameController =
      TextEditingController();

  _ViewModel() {
    _loadText();
  }

  Future<void> _loadText() async {
        await _userService.initialize();

        // Получаем объект User из UserService
        final user = _userService.user;

        // Устанавливаем значения в контроллеры TextEditingController
        wifiNameController.text = user.wifiName;
        wifiPasswordController.text = user.wifiPassword;
        bluetoothDeviceNameController.text = user.deviceName;
    }

  Future<void> onSaveButtonPressed() async {
        // Создаем объект User с данными из контроллеров
        final user = User(
            wifiNameController.text,
            wifiPasswordController.text,
            bluetoothDeviceNameController.text
        );

        // Сохраняем объект User с помощью UserService
        await _userService.saveUser(user);
    }
}

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const UserSettingsScreen(),
    );
  }

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
  bool _isWifiSettingsDataVisible = true;

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
    final model = context.watch<_ViewModel>();
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 1, 35, 63),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          TextField(
            controller: model.wifiNameController,
            decoration: const InputDecoration(
              labelText: 'Логин',
            ),
          ),
          TextField(
            controller: model.wifiPasswordController,
            decoration: const InputDecoration(
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
  bool _isBluetoothSettingsDataVisible = true;

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
        if (_isBluetoothSettingsDataVisible)
          const _BluetoothSettingsDataWidget(),
      ],
    );
  }
}

class _BluetoothSettingsDataWidget extends StatelessWidget {
  const _BluetoothSettingsDataWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<_ViewModel>();
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
          child: Column(
            children: [
              TextField(
                controller: model.bluetoothDeviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя устройства',
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
    final model = context.watch<_ViewModel>();
    return ElevatedButton(
      onPressed: model.onSaveButtonPressed,
      child: const Text('Сохранить'),
    );
  }
}
