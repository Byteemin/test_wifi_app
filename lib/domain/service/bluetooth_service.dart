import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  BluetoothDevice? _connectedDevice;
  BluetoothConnection? _connection;
  final List<BluetoothDevice> _devicesList = [];
  final StreamController<List<BluetoothDevice>> _deviceController =
      StreamController<List<BluetoothDevice>>.broadcast();

  Stream<List<BluetoothDevice>> get devicesStream => _deviceController.stream;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  Function(String)? onNewMessage;

  bool _isDisposed = false;
  int currentIndex = 0;
  bool _isSendingCommands = false;

  void initialize() {
    FlutterBluetoothSerial.instance.state.then((state) {
      if (_isDisposed) return;
      // Ваш код инициализации
    });
  }

  void startDiscovery() {
    if (_isDisposed) return;
    _discoveryStreamSubscription?.cancel();
    _discoveryStreamSubscription = null;

    _devicesList.clear();

    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (_isDisposed) return;
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
    if (_isDisposed) return;
    try {
      _discoveryStreamSubscription?.cancel();
      _discoveryStreamSubscription = null;

      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      if (_isDisposed) {
        connection.finish();
        return;
      }
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
    if (_isDisposed) return;

    List<int> buffer = [];
    List<int> completeMessageBuffer = [];

    // Запуск асинхронного метода отправки команд
    if (!_isSendingCommands) {
      _isSendingCommands = true;
      sendPeriodicCommand();
    }

    _connection!.input?.listen((Uint8List data) {
      if (_isDisposed) return;

      buffer.addAll(data);
      while (buffer.length >= 10) {
        List<int> bytes = buffer.sublist(0, 10);

        // Извлечение полезной информации из последних 4 байт
        List<int> usefulData = bytes.sublist(6, 10);
        // Добавляем данные к полному сообщению
        completeMessageBuffer.addAll(usefulData);

        if (completeMessageBuffer.length >= 20) {
          // Преобразуем каждый элемент в строку
          List<String> stringList = completeMessageBuffer
              .sublist(0, 20)
              .map((e) => e.toString())
              .toList();
          // Объединяем строки через пробел
          String message = stringList.join(' ');

          if (onNewMessage != null) {
            onNewMessage!(message);
          }
          if (kDebugMode) {
            print('Received complete message: $message');
          }
          // Удаляем первые 20 байт из полного буфера
          completeMessageBuffer = completeMessageBuffer.sublist(20);
        }

        buffer = buffer.sublist(10);
      }
    }).onDone(() {
      disconnect();
    });
  }

  // Метод для отправки команды, который будет вызываться асинхронно
  Future<void> sendPeriodicCommand() async {
    while (!_isDisposed && isConnected()) {
      List<int> command = [
        0xFE,
        0x08,
        0x00,
        0x00,
        0x00,
        currentIndex,
        0x00,
        0x00,
        0x00,
        0x00
      ];
      if (kDebugMode) {
        print(command);
      }
      sendMessage(command);
      currentIndex =
          (currentIndex + 1) % 20; // Увеличение значения и сброс после 19
      await Future.delayed(const Duration(seconds: 1));
    }
    _isSendingCommands = false;
  }

  void sendMessage(List<int> message) async {
    if (_isDisposed) return;
    if (_connection != null && _connection!.isConnected) {
      try {
        _connection!.output.add(Uint8List.fromList(message));
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

  bool isConnected() {
    return _connection != null && _connection!.isConnected;
  }

  void dispose() {
    _isDisposed = true;
    _deviceController.close();
    _discoveryStreamSubscription?.cancel();
    _connection?.finish();
  }
}
