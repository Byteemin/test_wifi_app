import 'package:test_wifi_app/domain/data_providers/user_settings_data.dart';
import 'package:test_wifi_app/domain/entity/user.dart';

class UserService {
  final _userDataProvider = UserSettingsData();
  var _user = User('', '', '');
  User get user => _user;

  Future<void> initilalize() async {
    _user = await _userDataProvider.loadValue();
  }

  void pushUserData({
    String? wifiName,
    String? wifiPassword,
    String? deviceName,
  }) {
    _user = user.copyWith(
      wifiName: wifiName ?? user.wifiName,
      wifiPassword: wifiPassword ?? user.wifiPassword,
      deviceName: deviceName ?? user.deviceName,
    );
    _userDataProvider.saveValue(_user);
  }
}
