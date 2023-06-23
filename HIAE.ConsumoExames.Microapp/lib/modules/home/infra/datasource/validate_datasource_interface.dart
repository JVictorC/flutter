import '../../domain/entities/user_validate_entity.dart';

abstract class IValidateDataSource {
  Future<UserValidateEntity> openScreen({
    required String idTransaction,
    required String token,
  });
}
