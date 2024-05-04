import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/service/bluetooth_controller.dart';

class _ViewModel extends ChangeNotifier {
  BleController bleController;
  List<String> messages = [];
  BluetoothDevice? connectedDevice;

  _ViewModel(this.bleController) {
    bleController.onDataReceived.listen((data) {
      messages.add(data);
      notifyListeners();
    });
  }

  void setConnectedDevice(BluetoothDevice device) {
    connectedDevice = device;
  }

  void sendMessage(String message) {
    if (message.isNotEmpty && connectedDevice != null) {
      // Отправляем сообщение через BleController на подключенное устройство
      bleController.sendData(connectedDevice!, message);
      // Добавляем сообщение в список для отображения
      messages.add(message);
      notifyListeners(); // Сообщаем слушателям об изменении состояния
    }
  }
}

class NetworkData extends StatelessWidget {
  const NetworkData({super.key});

  static Widget create(BleController bleController) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(bleController),
      child: const NetworkData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<_ViewModel>();
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(viewModel.messages[index]),
                );
              },
            ),
          ),
          // Поле для ввода сообщения
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = textController.text;
                    viewModel.sendMessage(message);
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
