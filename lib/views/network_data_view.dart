import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_wifi_app/domain/service/bluetooth_platform_service.dart';

class _ViewModel extends ChangeNotifier {}

class NetworkData extends StatelessWidget {
  const NetworkData({super.key});

  static Widget create(BleController bleController) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const NetworkData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<_ViewModel>();
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text("viewModel.messages[index]"),
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
