// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test_wifi_app/domain/service/bluetooth_service.dart';
// import 'package:test_wifi_app/views/network_connection_view.dart';

// void main() {
//   late BluetoothController bluetoothController;
//   late _ViewModel viewModel;

//   setUp(() async {
//     SharedPreferences.setMockInitialValues({});
//     bluetoothController = BluetoothController();
//     viewModel = _ViewModel(bluetoothController);
//   });
//   Widget createTestableWidget(Widget child) {
//     return ChangeNotifierProvider<_ViewModel>(
//       create: (_) => viewModel,
//       child: MaterialApp(
//         home: Scaffold(body: child),
//       ),
//     );
//   }
//   test('Initialization ViewModel', () {
//     expect(viewModel, isNotNull);
//     expect(viewModel.bluetoothController, bluetoothController);
//   });
//   testWidgets('Scan button trighers device scan', (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(NetworkConectionSreen.create(bluetoothController)));
//     var scanButton = find.byType(ElevatedButton);
//     expect(scanButton, findsOneWidget);
//     await tester.tap(scanButton);
//     await tester.pump();
//     expect(viewModel.isScanning, true);
//   });
//   testWidgets('Display devices when list is not empty', (WidgetTester tester) async {
//     expect(viewModel.devices, isEmpty);
//     await tester.pumpWidget(createTestableWidget(NetworkConectionSreen.create(bluetoothController)));
//     await tester.pump();
//     var noDevicesImage = find.byType(Image);
//     expect(noDevicesImage, findsOneWidget);
//   });
//   testWidgets('Search for devices', (WidgetTester tester) async {
//     final device = BluetoothDevice(name: "Device1", address: "00:11:22:33:44:55");
//     viewModel.addDevice(device);
//     await tester.pumpWidget(createTestableWidget(NetworkConectionSreen.create(bluetoothController)));
//     await tester.pump();
//     var deviceTile = find.text("Device1");
//     expect(deviceTile, findsOneWidget);
//   });
//   testWidgets('Connecting and disconnection fron a device', (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(NetworkConectionSreen.create(bluetoothController)));
//     var scanButton = find.byType(ElevatedButton);
//     expect(scanButton, findsOneWidget);
//     await tester.tap(scanButton);
//     await tester.pump();
//     expect(viewModel.isScanning, true);
//   });
// }
