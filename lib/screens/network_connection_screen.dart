import 'package:flutter/material.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

class _ViewModel extends ChangeNotifier {
  // Экземпляр FlutterBlue для работы с Bluetooth
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  // Список обнаруженных Bluetooth-устройств
  List<String> _bluetoothDevices = [];
  List<String> get bluetoothDevices => _bluetoothDevices;

  // Флаг загрузки
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> onScanButtonPressed() async {}
}

class NetworkConectionSreen extends StatelessWidget {
  const NetworkConectionSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WifiConnectionsWidget(),
              _BluetoothConnectionsWidget(),
              ScanButtonWidget(),
            ],
          ),
        ),
        bottomNavigationBar: BoottomNavigationWidget(),
      ),
    );
  }
}

class _WifiConnectionsWidget extends StatelessWidget {
  const _WifiConnectionsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('WI-FI'),
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
        ),
      ],
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
          child: const BTDeviceWidget(),
        ),
      ],
    );
  }
}

class ScanButtonWidget extends StatelessWidget {
  const ScanButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<_ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.isLoading ? null : viewModel.onScanButtonPressed,
      child: viewModel.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Scan'),
    );
  }
}

class BTDeviceWidget extends StatelessWidget {
  const BTDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<_ViewModel>();
    final bluetoothDevices = viewModel.bluetoothDevices;

    if (bluetoothDevices.isEmpty) {
      return Center(
        child: Image.asset(
          'assets/images/noScann.png',
          height: 150,
          width: 150,
        ),
      );
    }

    return ListView.builder(
      itemCount: bluetoothDevices.length,
      itemBuilder: (context, index) {
        final device = bluetoothDevices[index];
        return ListTile(
          title: Text(device),
          onTap: () {
            final addressParts = device.split(', ');
            if (addressParts.isNotEmpty) {
              final address = addressParts.last; // Используем последний элемент
              print(address);
            } else {
              print('Address not found in device string');
            }
          },
        );
      },
    );
  }
}
