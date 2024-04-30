import 'package:test_wifi_app/domain/data_providers/user_settings_data.dart';
import 'package:test_wifi_app/domain/entity/user.dart';

class UserService {
  final _userDataProvider = UserSettingsData();
  var _user = User('', '', '');

  User get user => _user;

  Future<void> initialize() async {
    _user = await _userDataProvider.loadValue();
  }

  Future<void> saveUser(User user) async {
    await _userDataProvider.saveValue(user);
    _user = user;
  }
}
