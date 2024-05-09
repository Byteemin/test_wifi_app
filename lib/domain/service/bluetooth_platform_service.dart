// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/services.dart';
import 'package:test_wifi_app/domain/entity/bluetooth.dart';

class BleController {
  static const _bluetoothChannel = MethodChannel('bluetooth_classic_channel');

  Future<bool> getPromision() async {
    print('Начало запроса разрешений');
    bool checkPromision = false;
    try {
      checkPromision = await _bluetoothChannel.invokeMethod('getPermission');
    } on PlatformException catch (e) {
      print('Ошибка при запросе разрешений: ${e.message}.');
      return false;
    }
    print(checkPromision);
    return checkPromision;
  }

  Future<List<BluetoothDevice>> scanDevices() async {
    bool hasPermission = await getPromision();
    if (!hasPermission) {
      // Обработка отсутствия разрешений
      return [];
    }

    try {
      // Вызываем метод `scanDevices` у кода Kotlin
      final List<dynamic> devices =
          await _bluetoothChannel.invokeMethod('scanDevices');

      // Преобразование результата в список объектов `BluetoothDevice`
        final List<BluetoothDevice> result = devices.map((device) {
            // Приведение типа к `Map<String, String>`
            final Map<String, String> deviceMap = Map<String, String>.from(device);

            // Создание экземпляра `BluetoothDevice` с данными из карты
            return BluetoothDevice(
                name: deviceMap['name']!,
                address: deviceMap['address']!,
            );
        }).toList();

      print('Найденные устройства: $devices');

      return result;
    } catch (e) {
      // Обработка ошибок
      print('Ошибка при сканировании Bluetooth устройств: $e');
      return [];
    }
  }
}
