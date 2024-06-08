import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/service/bluetooth_platform_service.dart';
import 'package:test_wifi_app/domain/service/user_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class _ViewModel extends ChangeNotifier {
  final BleController bleController;
  final UserService _userService = UserService();

  List<BluetoothDevice> allDevices = [];
  List<BluetoothDevice> filteredDevices = [];
  String bluetoothfilterMask = '';
  BluetoothDevice? _connectedDevice;
  StreamSubscription<List<BluetoothDevice>>? _deviceStreamSubscription;

  _ViewModel(this.bleController) {
    _loadViewModel();
    _subscribeToDeviceStream();
  }

  Future<void> _loadViewModel() async {
    await _userService.initialize();
    final user = _userService.user;
    bluetoothfilterMask = user.deviceName;
    _applyFilter();
  }

  void _subscribeToDeviceStream() {
    _deviceStreamSubscription = bleController.devicesStream.listen((devices) {
      allDevices = devices;
      _applyFilter();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _deviceStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> scanDevices() async {
    allDevices.clear();
    filteredDevices.clear();
    bleController.startDiscovery();
    notifyListeners();
  }

  Future<void> toggleConnectionToDevice(BluetoothDevice bluetoothDevice) async {
    if (isConnected(bluetoothDevice)) {
      bleController.disconnect();
      _connectedDevice = null;
    } else {
      await bleController.connectToDevice(bluetoothDevice);
      _connectedDevice = bluetoothDevice;
    }
    notifyListeners();
  }

  void _applyFilter() {
    if (bluetoothfilterMask.isEmpty) {
      filteredDevices = allDevices;
    } else {
      RegExp regex = RegExp(bluetoothfilterMask, caseSensitive: false);
      filteredDevices = allDevices.where((device) {
        return regex.hasMatch(device.name ?? 'Unknown');
      }).toList();
    }
    notifyListeners();
  }

  bool isConnected(BluetoothDevice bluetoothDevice) {
    return _connectedDevice?.address == bluetoothDevice.address;
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
          _BluetoothConnectionsWidget(),
          SizedBox(height: 10),
          _ScanButton(),
        ],
      ),
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
        if (viewModel.filteredDevices.isEmpty) {
          return Center(
            child: Image.asset(
              'assets/images/noScann.png',
              height: 150,
              width: 150,
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: viewModel.filteredDevices.length,
            itemBuilder: (context, index) {
              final bluetoothDevice = viewModel.filteredDevices[index];
              final isConnected = viewModel.isConnected(bluetoothDevice);
              return Card(
                color: isConnected
                    ? const Color.fromARGB(255, 176, 245, 178)
                    : null,
                child: ListTile(
                  title: Text(bluetoothDevice.name ?? 'Unknown'),
                  subtitle: Text(bluetoothDevice.address),
                  onTap: () {
                    viewModel.toggleConnectionToDevice(bluetoothDevice);
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
