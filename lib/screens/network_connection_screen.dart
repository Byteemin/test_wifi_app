import 'package:flutter/material.dart';
import 'package:test_wifi_app/blu_controller.dart';
import 'package:test_wifi_app/widgets/boottom_navigation_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WifiConnectionsWidget(),
            _BluetoothConnectionsWidget(),
            SizedBox(height: 10),
            _ScanButton(),
          ],
        ),
      ),
      bottomNavigationBar: BoottomNavigationWidget(),
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
                    color: isConnected ? const Color.fromARGB(255, 176, 245, 178) : null, // Цвет для подключенного устройства
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
