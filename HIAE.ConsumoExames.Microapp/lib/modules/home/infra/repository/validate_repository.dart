import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_validate_entity.dart';
import '../../domain/repositories/validate_repository_interface.dart';
import '../datasource/validate_datasource_interface.dart';

class ValidateRepository implements IValidateRepository {
  final IValidateDataSource _validateDatasource;

  ValidateRepository({required IValidateDataSource validateDatasource})
      : _validateDatasource = validateDatasource;

  @override
  Future<Result<Failure, UserValidateEntity>> openScreen({
    required String idTransaction,
    required String token,
  }) async {
    try {
      final result = await _validateDatasource.openScreen(
        idTransaction: idTransaction,
        token: token,
      );
      return Result.success(result);
    } on NoInternetConnectionFailure catch (error, stackTrace) {
      return Result.failure(
        NoInternetConnectionFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    } on HttpNoContent catch (error, stackTrace) {
      return Result.failure(
        HttpNoContent(
          message: error.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
