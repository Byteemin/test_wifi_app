import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController {
  FlutterBlue ble = FlutterBlue.instance;
  final StreamController<List<ScanResult>> _scanResultsController =
      StreamController<List<ScanResult>>.broadcast();
  final Map<BluetoothDevice, bool> _connectedDevices = {};
  Stream<List<ScanResult>> get scanResults => _scanResultsController.stream;

  Future<List<ScanResult>> scanDevices() async {
    Set<BluetoothDevice> uniqueDevices = {};
    List<ScanResult> foundDevices = [];

    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
        ble.startScan(timeout: const Duration(seconds: 15));

        ble.scanResults.listen((results) {
            for (var result in results) {
                if (uniqueDevices.add(result.device)) {
                    foundDevices.add(result);
                }
            }
            _scanResultsController.add(foundDevices);
        });

        await Future.delayed(const Duration(seconds: 15));
        ble.stopScan();
    }
    return foundDevices;
} 


  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_connectedDevices[device] ?? false) {
      await device.disconnect();
      _connectedDevices[device] = false;
    } else {
      await device.connect(timeout: const Duration(seconds: 15));
      _connectedDevices[device] = true;

      device.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          _connectedDevices[device] = true;
        } else {
          _connectedDevices[device] = false;
        }
      });
    }
  }

  bool isConnected(BluetoothDevice device) {
    return _connectedDevices[device] ?? false;
  }

}