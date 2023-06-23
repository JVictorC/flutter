import '../entities/user_token.dart';

class UserTokenModel extends UserToken {
  UserTokenModel({
    required typeLogin clientId,
    required String user,
    required String password,
  }) : super(
          clientId: clientId,
          user: user,
          password: password,
        );

  Map<String, dynamic> toMapDoctor() => {
        'client_Id': clientId.toString().split('.').last,
        'userEinsteinMedicos': user,
        'passEinsteinMedicos': password,
      };

  Map<String, dynamic> toMapPatient() => {
        'grantType': 'password_v4',
        'document': user,
        'password': password,
      };

  factory UserTokenModel.fromEntity({required UserToken entity}) =>
      UserTokenModel(
        clientId: entity.clientId,
        user: entity.user,
        password: entity.password,
      );
}
