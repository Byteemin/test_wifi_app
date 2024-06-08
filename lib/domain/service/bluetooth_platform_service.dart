import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BleController {
  BluetoothDevice? _connectedDevice;
  BluetoothConnection? _connection;
  final List<BluetoothDevice> _devicesList = [];
  final StreamController<List<BluetoothDevice>> _deviceController =
      StreamController<List<BluetoothDevice>>.broadcast();

  Stream<List<BluetoothDevice>> get devicesStream => _deviceController.stream;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  Function(String)? onNewMessage;

  void initialize() {
    FlutterBluetoothSerial.instance.state.then((state) {});
  }

  void startDiscovery() {
    _discoveryStreamSubscription?.cancel();
    _discoveryStreamSubscription = null;

    _devicesList.clear();

    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      BluetoothDevice device = r.device;
      if (!_devicesList.contains(device)) {
        if (device.name == null || device.name!.isEmpty) {
          device = BluetoothDevice(
            address: device.address,
            name: "Unknown",
            type: device.type,
            bondState: device.bondState,
            isConnected: device.isConnected,
          );
        }
        _devicesList.add(device);
        _deviceController.add(_devicesList);
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _discoveryStreamSubscription?.cancel();
      _discoveryStreamSubscription = null;

      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      _connectedDevice = device;
      _connection = connection;
      _listenForData();
      if (kDebugMode) {
        print('Successfully connected to device: ${device.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to device: $e');
      }
    }
  }

  void disconnect() {
    if (_connection != null) {
      _connection!.finish();
      _connectedDevice = null;
      _connection = null;
    }
  }



void _listenForData() {
  List<int> buffer = []; // Буфер для хранения принятых байтов

  _connection!.input?.listen((Uint8List data) {
    // Добавляем принятые байты в буфер
    buffer.addAll(data);

    // Обрабатываем буфер, если накопилось достаточно данных
    while (buffer.length >= 10) {
      // Извлекаем первые 10 байтов из буфера
      List<int> bytes = buffer.sublist(0, 10);

      // Преобразуем байты в строку ASCII
      String message = ascii.decode(bytes, allowInvalid: true);

      // Вызываем коллбек onNewMessage
      if (onNewMessage != null) {
        onNewMessage!(message);
      }

      // Выводим полученное сообщение
      if (kDebugMode) {
        print('Received message: $message');
      }

      // Удаляем обработанные байты из буфера
      buffer = buffer.sublist(10);
    }
  }).onDone(() {
    disconnect();
  });
}

void sendMessage(String message) async {
  if (_connection != null && _connection!.isConnected) {
    try {
      // Отправляем сообщение как ASCII байты
      _connection!.output.add(Uint8List.fromList(ascii.encode(message)));
      await _connection!.output.allSent;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
    }
  } else {
    if (kDebugMode) {
      print('No connection to send message');
    }
  }
}


  void dispose() {
    _deviceController.close();
    _discoveryStreamSubscription?.cancel();
  }
}
