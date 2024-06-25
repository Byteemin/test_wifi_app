// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:test_wifi_app/domain/entity/user.dart';
// import 'package:test_wifi_app/domain/service/user_service.dart';
// import 'package:test_wifi_app/views/network_settings_view.dart';

// void main() {
//   late UserService userService;
//   late User testUser;
//   setUp(() async {
//     userService = UserService();
//     testUser = User('testWifi', 'testPassword', 'testDevice');
//     await userService.initialize();
//     await userService.saveUser(testUser);
//   });
//   Widget createTestableWidget(Widget child) {
//     return ChangeNotifierProvider<ViewModel>(
//       create: (_) {
//         final viewModel = ViewModel();
//         viewModel.userService = userService;
//         return viewModel;
//       },
//       child: MaterialApp(
//         home: Scaffold(body: child),
//       ),
//     );
//   }
//   testWidgets('ViewModel is initialized and loads user data',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(const UserSettingsScreen()));
//     final viewModel = Provider.of<ViewModel>(
//         tester.element(find.byType(UserSettingsScreen)),
//         listen: false);
//     await tester.pumpAndSettle();
//     expect(viewModel.wifiNameController.text, testUser.wifiName);
//     expect(viewModel.wifiPasswordController.text, testUser.wifiPassword);
//     expect(viewModel.bluetoothDeviceNameController.text, testUser.deviceName);
//   });
//   testWidgets('Save button calls onSaveButtonPressed',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(const UserSettingsScreen()));
//     Provider.of<ViewModel>(tester.element(find.byType(UserSettingsScreen)),
//         listen: false);
//     await tester.pumpAndSettle();
//     var saveButton = find.byType(ElevatedButton);
//     expect(saveButton, findsOneWidget);
//     await tester.tap(saveButton);
//     await tester.pumpAndSettle();
//     final savedUser = await userService.loadUser();
//     expect(savedUser.wifiName, testUser.wifiName);
//     expect(savedUser.wifiPassword, testUser.wifiPassword);
//     expect(savedUser.deviceName, testUser.deviceName);
//   });
//   testWidgets('Bluetooth settings are visible',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(const UserSettingsScreen()));
//     await tester.pumpAndSettle();
//     expect(find.text('BT Settings'), findsOneWidget);
//     expect(find.byType(BluetoothSettingsDataWidget), findsOneWidget);
//   });
//   testWidgets('Toggling visibility of Wi-Fi and Bluetooth settings',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createTestableWidget(const UserSettingsScreen()));
//     await tester.pumpAndSettle();
//     var wifiToggleButton = find.widgetWithIcon(IconButton, Icons.star).first;
//     await tester.tap(wifiToggleButton);
//     await tester.pumpAndSettle();
//     var bluetoothToggleButton =
//         find.widgetWithIcon(IconButton, Icons.star).last;
//     await tester.tap(bluetoothToggleButton);
//     await tester.pumpAndSettle();
//     expect(find.byType(BluetoothSettingsDataWidget), findsNothing);
//     await tester.tap(bluetoothToggleButton);
//     await tester.pumpAndSettle();
//     expect(find.byType(BluetoothSettingsDataWidget), findsOneWidget);
//   });
// }
