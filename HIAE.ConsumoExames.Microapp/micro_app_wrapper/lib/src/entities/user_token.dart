enum typeLogin { HIAIEinsteinMedico, password_v4 }

class UserToken {
  final typeLogin clientId;
  final String user;
  final String password;

  UserToken({
    required this.clientId,
    required this.user,
    required this.password,
  });
}
