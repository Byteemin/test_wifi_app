class User {
  final String wifiName;
  final String wifiPassword;
  final String deviceName;

  User(this.wifiName, this.wifiPassword, this.deviceName);

  User copyWith({
    String? wifiName,
    String? wifiPassword,
    String? deviceName,
  }) {
    return User(
      wifiName ?? this.wifiName,
      wifiPassword ?? this.wifiPassword,
      deviceName ?? this.deviceName,
    );
  }
}
