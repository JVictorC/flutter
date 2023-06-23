import '../../../../core/adapters/http/http_interface.dart';
import '../../../../core/constants/api_routes.dart';
import '../../domain/entities/user_validate_entity.dart';
import '../../infra/datasource/validate_datasource_interface.dart';
import '../models/user_validate_model.dart';

class ValidateDataSource implements IValidateDataSource {
  final IHttpClient _http;

  ValidateDataSource({required IHttpClient http}) : _http = http;

  @override
  Future<UserValidateEntity> openScreen({
    required String idTransaction,
    required String token,
  }) async {
    final response = await _http.get(
      ApiRoutes.openScreen,
      headers: {
        'Authorization': 'Bearer $token',
      },
      queryParameters: {
        'transactionId': idTransaction,
      },
    );

    if (response.statusCode == 200) {
      return UserValidateModel.fromMap(response.data);
    } else {
      throw Exception();
    }
  }
}
