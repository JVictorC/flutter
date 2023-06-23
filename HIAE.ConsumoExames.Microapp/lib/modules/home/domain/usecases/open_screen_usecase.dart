import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_validate_entity.dart';
import '../repositories/validate_repository_interface.dart';

abstract class IOpenScreenUseCase {
  Future<Result<Failure, UserValidateEntity>> call({
    required String idTransaction,
    required String token,
  });
}

class OpenScreenUseCase implements IOpenScreenUseCase {
  late final IValidateRepository _repository;

  OpenScreenUseCase({required IValidateRepository repository})
      : _repository = repository;

  @override
  Future<Result<Failure, UserValidateEntity>> call({
    required String idTransaction,
    required String token,
  }) async =>
      await _repository.openScreen(
        idTransaction: idTransaction,
        token: token,
      );
}
