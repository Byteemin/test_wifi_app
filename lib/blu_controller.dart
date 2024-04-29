import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';  // Импортируйте асинхронную библиотеку

class BleController extends ChangeNotifier {
  FlutterBlue ble = FlutterBlue.instance;
  final StreamController<List<ScanResult>> _scanResultsController = StreamController<List<ScanResult>>.broadcast();
  final Map<BluetoothDevice, bool> _connectedDevices = {};
  Stream<List<ScanResult>> get scanResults => _scanResultsController.stream;

  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        ble.startScan(timeout: const Duration(seconds: 15));
        ble.scanResults.listen((results) {
          _scanResultsController.add(results);
        });
        await Future.delayed(const Duration(seconds: 15));
        ble.stopScan();
      }
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_connectedDevices[device] ?? false) {
      await device.disconnect();
      _connectedDevices[device] = false;
      notifyListeners();
    } else {
      await device.connect(timeout: const Duration(seconds: 15));
      _connectedDevices[device] = true;
      notifyListeners();

      device.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          _connectedDevices[device] = true;
        } else {
          _connectedDevices[device] = false;
        }
        notifyListeners();
      });
    }
  }


  @override
  void dispose() {
    _scanResultsController.close();
    super.dispose();
  }

  // Реализуйте метод isConnected
  bool isConnected(BluetoothDevice device) {
    return _connectedDevices[device] ?? false;
  }
}
