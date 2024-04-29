import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_wifi_app/domain/entity/user.dart';

class UserSettingsData {
  final sharedPreferences = SharedPreferences.getInstance();

  Future<User> loadValue() async {
    final wifiName = (await sharedPreferences).getString('wifiName') ?? '';
    final wifiPassword =
        (await sharedPreferences).getString('wifiPassword') ?? '';
    final deviceName = (await sharedPreferences).getString('deviceName') ?? '';
    return User(wifiName, wifiPassword, deviceName);
  }

  Future<void> saveValue(User user) async {
    (await sharedPreferences).setString('wifiName', user.wifiName);
    (await sharedPreferences).setString('wifiPassword', user.wifiPassword);
    (await sharedPreferences).setString('deviceName', user.deviceName);
  }
}
