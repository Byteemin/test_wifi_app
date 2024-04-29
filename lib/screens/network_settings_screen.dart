// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_wifi_app/domain/service/user_service.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';

class ViewModelState {
  final String wifiName;
  final String wifiPassword;
  final String deviceName;

  ViewModelState({
    required this.wifiName,
    required this.wifiPassword,
    required this.deviceName,
  });

  ViewModelState copyWith({
    String? wifiName,
    String? wifiPassword,
    String? deviceName,
  }) {
    return ViewModelState(
      wifiName: wifiName ?? this.wifiName,
      wifiPassword: wifiPassword ?? this.wifiPassword,
      deviceName: deviceName ?? this.deviceName,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final _userService = UserService();
  var _state = ViewModelState(
    wifiName: '',
    wifiPassword: '',
    deviceName: '',
  );
  ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initilalize();
    _updateState();
  }

  _ViewModel() {
    loadValue();
  }

  void _updateState() {
    final user = _userService.user;
    _state = ViewModelState(
      wifiName: user.wifiName.toString(),
      wifiPassword: user.wifiPassword.toString(),
      deviceName: user.deviceName.toString(),
    );
    notifyListeners();
  }

  Future<void> onSaveButtonPressed() async {
    try {
      // Сохраняем текущие настройки пользователя с помощью сервиса пользователя (_userService)
      _userService.pushUserData(
        wifiName: _state.wifiName,
        wifiPassword: _state.wifiPassword,
        deviceName: _state.deviceName,
      );

      _updateState();
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при сохранении настроек: $e');
      // Вы можете добавить дополнительную обработку ошибок, например, уведомление пользователя об ошибке
    }
  }

  void changeDeviceName(String value) {
    if (_state.deviceName == value) return;
    _state = _state.copyWith(deviceName: value);
    notifyListeners();
  }

  void changeWifiName(String value) {
    if (_state.wifiName == value) return;
    _state = _state.copyWith(wifiName: value);
    notifyListeners();
  }

  void changeWifiPassword(String value) {
    if (_state.wifiPassword == value) return;
    _state = _state.copyWith(wifiPassword: value);
    notifyListeners();
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
    final model = context.read<_ViewModel>();
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
            decoration: const InputDecoration(
              labelText: 'Логин',
            ),
            onChanged: model.changeWifiName,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Пароль',
            ),
            onChanged: model.changeWifiPassword,
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
    final model = context.read<_ViewModel>();
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
                decoration: const InputDecoration(
                  labelText: 'Имя устройства',
                ),
                onChanged: model.changeDeviceName,
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
    final model = context.read<_ViewModel>();
    return ElevatedButton(
      onPressed: model.onSaveButtonPressed,
      child: const Text('Сохранить'),
    );
  }
}
