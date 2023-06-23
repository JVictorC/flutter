import '../../domain/entities/user_validate_entity.dart';

class UserValidateModel extends UserValidateEntity {
  UserValidateModel({
    required final String id,
    required final String accessType,
    required final String identifier,
  }) : super(
          id: id,
          accessType: accessType,
          identifier: identifier,
        );

  factory UserValidateModel.fromMap(Map<String, dynamic> map) =>
      UserValidateModel(
        id: map['id'],
        accessType: map['accessType'],
        identifier: map['identifier'],
      );
}
