import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/service/bluetooth_platform_service.dart';
import 'package:test_wifi_app/domain/service/esp_commands.dart';

class _ViewModel extends ChangeNotifier {
  final BleController _bleController;
  EspCommands espCommands = EspCommands();
  List<String> messages = [];

  _ViewModel(this._bleController) {
    _bleController.initialize();
    _subscribeToMessageStream();
  }

  void sendMessage(String s) {
    _bleController.sendMessage(s);
    // addMessage(s);
  }

  void sendCommand(int index) {
    if (index >= 0 && index < espCommands.commands.length) {
      sendMessage(espCommands.commands[index]);
    }
  }

  void addMessage(String message) {
    messages.add(message);
    notifyListeners(); // Уведомляем об изменении списка сообщений
  }

  void _subscribeToMessageStream() {
    _bleController.onNewMessage = (message) {
      addMessage(message);
    };
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
    return const Row(
      children: [
        Expanded(
          child: Column(
            children: [
              // Пространство между верхними и нижними кнопками
              _ComandListWidget(),
              // Нижняя строка кнопок
              _ButtonHelpWidget(),
            ],
          ),
        ),
        // Столбик кнопок F1 - F8 справа
        _ButtonFWidget(),
      ],
    );
  }
}

class _ComandListWidget extends StatelessWidget {
  const _ComandListWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: 200.0,
        margin: const EdgeInsets.only(left: 5.0, right: 16.0, top: 30.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 1, 35, 63),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const _BlueTerminalWidget(),
      ),
    );
  }
}

class _ButtonHelpWidget extends StatelessWidget {
  const _ButtonHelpWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<_ViewModel>(context,
        listen: false); // Получение экземпляра _ViewModel

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Wrap(
        children: [
          _buildBottomButton('Меню', () {
            viewModel.sendCommand(8); // Использование команды "Меню"
          }),
          _buildBottomButton('Режим', () {
            viewModel.sendCommand(9); // Использование команды "Режим"
          }),
          _buildBottomButton('Ввод', () {
            viewModel.sendCommand(10); // Использование команды "Ввод"
          }),
          _buildBottomButton('Отмена', () {
            viewModel.sendCommand(11); // Использование команды "Отмена"
          }),
          _buildBottomButton('Архив', () {
            viewModel.sendCommand(12); // Использование команды "Архив"
          }),
          _buildBottomButton('F', () {
            viewModel.sendCommand(13); // Использование команды "F"
          }),
          _buildBottomButton('↑', () {
            viewModel.sendCommand(15); // Использование команды "Вверх"
          }),
          _buildBottomButton('↓', () {
            viewModel.sendCommand(14); // Использование команды "Вниз"
          }),
        ],
      ),
    );
  }

  // Функция для создания кнопки нижней строки
  Widget _buildBottomButton(String text, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed, // Обработчик нажатия кнопки
      child: Container(
        margin: const EdgeInsets.all(1.0),
        constraints: const BoxConstraints(
          maxWidth: 60.0, // Максимальная ширина кнопки
          maxHeight: 40.0, // Максимальная высота кнопки
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class _ButtonFWidget extends StatelessWidget {
  const _ButtonFWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<_ViewModel>(context,
        listen: false); // Получение экземпляра _ViewModel
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSideButton(
          'F1',
          () {
            // viewModel.sendMessage('1234');
            viewModel.sendCommand(0);
          },
        ),
        _buildSideButton(
          'F2',
          () {
            viewModel.sendCommand(1);
          },
        ),
        _buildSideButton(
          'F3',
          () {
            viewModel.sendCommand(2);
          },
        ),
        _buildSideButton(
          'F4',
          () {
            viewModel.sendCommand(3);
          },
        ),
        _buildSideButton(
          'F5',
          () {
            viewModel.sendCommand(4);
          },
        ),
        _buildSideButton(
          'F6',
          () {
            viewModel.sendCommand(5);
          },
        ),
        _buildSideButton(
          'F7',
          () {
            viewModel.sendCommand(6);
          },
        ),
        _buildSideButton(
          'F8',
          () {
            viewModel.sendCommand(7);
          },
        ),
      ],
    );
  }

  // Функция для создания кнопки бокового столбика
  Widget _buildSideButton(String text, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      color: Colors.grey,
      width: 60, // Установка ширины кнопки
      height: 50, // Установка высоты кнопки
      child: TextButton(
        onPressed: onPressed, // Обработчик нажатия кнопки
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _BlueTerminalWidget extends StatelessWidget {
  const _BlueTerminalWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<_ViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.messages.isEmpty) {
          // Исправляем обращение к списку сообщений
          return Center(
            child: Image.asset(
              'assets/images/noScann.png',
              height: 150,
              width: 150,
            ),
          );
        } else {
          // Если найдены устройства, выводим список сообщений
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: viewModel.messages.length,
            itemBuilder: (context, index) {
              final message =
                  viewModel.messages[index]; // Получаем сообщение из списка
              return Card(
                child: ListTile(
                  title: Text(message), // Отображаем сообщение
                ),
              );
            },
          );
        }
      },
    );
  }
}
