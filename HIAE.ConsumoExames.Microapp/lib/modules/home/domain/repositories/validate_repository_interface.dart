import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_validate_entity.dart';

abstract class IValidateRepository {
  Future<Result<Failure, UserValidateEntity>> openScreen({
    required String idTransaction,
    required String token,
  });
}
