import '../entities/validate_entity.dart';

class ValidateModel extends ValidateEntity {
  ValidateModel({
    required String accessType,
    required String identifier,
  }) : super(
          accessType: accessType,
          identifier: identifier,
        );

  Map<String, dynamic> toMap() => {
        'accesType': accessType,
        'identifier': identifier,
      };
}
