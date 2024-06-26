import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/entity/user.dart';
import 'package:test_wifi_app/domain/service/user_service.dart';

class _ViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final TextEditingController wifiNameController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();
  final TextEditingController bluetoothDeviceNameController =
      TextEditingController();

  _ViewModel() {
    _loaViewModel();
  }

  Future<void> _loaViewModel() async {
    await _userService.initialize();

    final user = _userService.user;

    wifiNameController.text = user.wifiName;
    wifiPasswordController.text = user.wifiPassword;
    bluetoothDeviceNameController.text = user.deviceName;
  }

  Future<void> onSaveButtonPressed() async {
    final user = User(wifiNameController.text, wifiPasswordController.text,
        bluetoothDeviceNameController.text);

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
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BluetoothSettingsWidget(),
          _SaveButtonWidget(),
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
