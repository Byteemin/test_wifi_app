// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:test_wifi_app/main_wrapper.dart';
// import 'package:test_wifi_app/views/network_connection_view.dart';
// import 'package:test_wifi_app/views/network_data_view.dart';
// import 'package:test_wifi_app/views/network_settings_view.dart';

// void main() {
//   testWidgets('BluetoothController is initialized', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: MainWrapper(),
//       ),
//     );
//     final state = tester.state<MainWrapperState>(find.byType(MainWrapper));
//     expect(state.bleController, isNotNull);
//   });

//   testWidgets('Navigation works correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: MainWrapper(),
//       ),
//     );
//     expect(find.byType(NetworkData), findsOneWidget);
//     await tester.tap(find.text('Settings'));
//     await tester.pumpAndSettle();
//     expect(find.byType(UserSettingsScreen), findsOneWidget);
//     await tester.tap(find.text('Device'));
//     await tester.pumpAndSettle();
//     expect(find.byType(NetworkData), findsOneWidget);
//     await tester.tap(find.byType(FloatingActionButton));
//     await tester.pumpAndSettle();
//     expect(find.byType(NetworkConectionSreen), findsOneWidget);
//   });
// }
