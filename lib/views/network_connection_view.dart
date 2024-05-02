import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleController extends ChangeNotifier {
  FlutterBlue ble = FlutterBlue.instance;
  final StreamController<List<ScanResult>> _scanResultsController =
      StreamController<List<ScanResult>>.broadcast();
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

  bool isConnected(BluetoothDevice device) {
    return _connectedDevices[device] ?? false;
  }
}

class NetworkConectionSreen extends StatelessWidget {
  const NetworkConectionSreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => BleController(),
      child: const NetworkConectionSreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WifiConnectionsWidget(),
          _BluetoothConnectionsWidget(),
          SizedBox(height: 10),
          _ScanButton(),
        ],
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
          child: const _BlueDeviceWidget(),
        ),
      ],
    );
  }
}

class _BlueDeviceWidget extends StatelessWidget {
  const _BlueDeviceWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<BleController>(
      builder: (context, controller, child) {
        return StreamBuilder<List<ScanResult>>(
          stream: controller.scanResults,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  final isConnected = controller.isConnected(data.device);
                  return Card(
                    color: isConnected
                        ? const Color.fromARGB(255, 176, 245, 178)
                        : null, // Цвет для подключенного устройства
                    elevation: 2,
                    child: ListTile(
                      title: Text(data.device.name),
                      subtitle: Text(data.device.id.id),
                      trailing: Text(data.rssi.toString()),
                      onTap: () {
                        controller.connectToDevice(data.device);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Image.asset(
                  'assets/images/noScann.png',
                  height: 150,
                  width: 150,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          Provider.of<BleController>(context, listen: false).scanDevices(),
      child: const Text("SCAN"),
    );
  }
}
