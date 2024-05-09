// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/entity/bluetooth.dart';

import 'package:test_wifi_app/domain/service/bluetooth_platform_service.dart';
import 'package:test_wifi_app/domain/service/user_service.dart';


class _ViewModel extends ChangeNotifier {
  final BleController bleController;
  final UserService _userService = UserService();

  List<BluetoothDevice> allDevices = [];
  List<BluetoothDevice> filteredDevices = [];

  bool _isScanning = false;
  bool _hasScanned = false;

  // Геттер для проверки, идет ли сканирование
  bool get isScanning => _isScanning;

  // Геттер для проверки, происходило ли сканирование
  bool get hasScanned => _hasScanned;

  String bluetoothfilterMask = '';

  _ViewModel(this.bleController) {
    _loaViewModel();
  }

  Future<void> _loaViewModel() async {
    await _userService.initialize();

    final user = _userService.user;

    bluetoothfilterMask = user.deviceName;
  }

  bool get hasDevices => allDevices.isNotEmpty;

  Future<void> scanDevices() async {
    _isScanning = true;
    notifyListeners();

    allDevices.clear();
    filteredDevices.clear();

    allDevices = (await bleController.scanDevices()).cast<BluetoothDevice>();
    _applyFilter();

    _hasScanned = true;
    _isScanning = false;

    notifyListeners();
  }

  // Future<void> connectToDevice() async {
  //   await bleController.connectToDevice(device);
  //   notifyListeners();
  // }

  // bool isConnected() {

  //   // return bleController.isConnected(device);
  // }

  void _applyFilter() {
    if (bluetoothfilterMask.isEmpty) {
      filteredDevices = allDevices;
    } else {
      RegExp regex = RegExp(bluetoothfilterMask, caseSensitive: false);

      filteredDevices = allDevices.where((device) {
        return regex.hasMatch(device.name);
      }).toList();
    }

    notifyListeners();
  }
}

class NetworkConectionSreen extends StatelessWidget {
  const NetworkConectionSreen({super.key});

  static Widget create(BleController bleController) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(bleController),
      child: const NetworkConectionSreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _WifiConnectionsWidget(),
          _BluetoothConnectionsWidget(),
          SizedBox(height: 10),
          _ScanButton(),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _WifiConnectionsWidget extends StatelessWidget {
  const _WifiConnectionsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('WI-FI'),
        Container(
          height: 250.0,
          margin: const EdgeInsets.only(left: 5.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 1, 35, 63),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }
}

class _BluetoothConnectionsWidget extends StatelessWidget {
  const _BluetoothConnectionsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Bluetooth'),
        Container(
          height: 250.0,
          margin: const EdgeInsets.only(left: 5.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 1, 35, 63),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const _BlueDeviceWidget(),
        ),
      ],
    );
  }
}

class _BlueDeviceWidget extends StatelessWidget {
  const _BlueDeviceWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<_ViewModel>(
      builder: (context, viewModel, child) {
        // Проверка состояния сканирования
        if (viewModel.isScanning) {
          // Если идет сканирование, выводим текст "Идет сканирование"
          return const Center(
            child: Text(
              'Идет сканирование...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        } else if (viewModel.hasScanned && viewModel.filteredDevices.isEmpty) {
          // Если сканирование произошло, но не найдено ни одного устройства
          return const Center(
            child: Text(
              'Устройств с данной маской не найдено',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        } else if (!viewModel.hasScanned) {
          // Если сканирование не произошло ни разу, выводим изображение
          return Center(
            child: Image.asset(
              'assets/images/noScann.png',
              height: 150,
              width: 150,
            ),
          );
        } else {
          // Если найдены устройства, выводим список карточек устройств
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: viewModel.filteredDevices.length,
            itemBuilder: (context, index) {
              final bluetoothDevice  =
                  viewModel.filteredDevices[index]; // Получаем ScanResult
              const isConnected = false;
              // viewModel.isConnected(device);
              return Card(
                color: isConnected
                    ? const Color.fromARGB(255, 176, 245, 178)
                    : null,
                child: ListTile(
                  title: Text(bluetoothDevice.name),
                  subtitle: Text(bluetoothDevice.address),
                  onTap: () {
                    // viewModel.connectToDevice(device);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<_ViewModel>(context, listen: false);
    return ElevatedButton(
      onPressed: () => viewModel.scanDevices(),
      child: const Text("SCAN"),
    );
  }
}
