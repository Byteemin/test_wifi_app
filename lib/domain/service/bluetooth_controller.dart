// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert'; // Для кодирования/декодирования данных в строковом формате

import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';



// TestBlue BleController
class TestBlue {
  FlutterBlue ble = FlutterBlue.instance;
  final StreamController<List<ScanResult>> _scanResultsController =
      StreamController<List<ScanResult>>.broadcast();
  final StreamController<String> _onDataReceivedController =
      StreamController<String>.broadcast();
  final Map<BluetoothDevice, bool> _connectedDevices = {};

  Stream<List<ScanResult>> get scanResults => _scanResultsController.stream;
  Stream<String> get onDataReceived => _onDataReceivedController.stream;

  Future<void> requestPermissions() async {
    List<Permission> permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ];

    await Future.forEach(permissions, (Permission permission) async {
      var status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    });
  }

  // Сканирование Bluetooth устройств
  Future<List<ScanResult>> scanDevices() async {
    Set<BluetoothDevice> uniqueDevices = {};
    List<ScanResult> foundDevices = [];

    await requestPermissions();

    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.location.isGranted) {
      ble.startScan(timeout: const Duration(seconds: 25));

      ble.scanResults.listen((results) {
        for (var result in results) {
          if (uniqueDevices.add(result.device)) {
            foundDevices.add(result);
          }
        }
        _scanResultsController.add(foundDevices);
      });

      await Future.delayed(const Duration(seconds: 25));
      ble.stopScan();
    }

    return foundDevices;
  }

  // Подключение к устройству
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_connectedDevices[device] ?? false) {
      await device.disconnect();
      _connectedDevices[device] = false;
    } else {
      await device.connect(timeout: const Duration(seconds: 15));
      _connectedDevices[device] = true;

      // Подписываемся на состояние устройства
      device.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          _connectedDevices[device] = true;
          // Подписываемся на данные, получаемые от устройства
          _subscribeToData(device);
        } else {
          _connectedDevices[device] = false;
        }
      });
    }
  }

  // Подписка на получение данных от устройства
  void _subscribeToData(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify ||
            characteristic.properties.indicate) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((data) {
            final message = utf8.decode(data);
            _onDataReceivedController.add(message);
          });
        }
      }
    }
  }

  // Отправка данных устройству
  Future<void> sendData(BluetoothDevice device, String data) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write ||
            characteristic.properties.writeWithoutResponse) {
          await characteristic.write(utf8.encode(data));
          break;
        }
      }
    }
  }

  // Проверка, подключено ли устройство
  bool isConnected(BluetoothDevice device) {
    return _connectedDevices[device] ?? false;
  }

  // Очистка ресурсов
  void dispose() {
    _scanResultsController.close();
    _onDataReceivedController.close();
  }
}
