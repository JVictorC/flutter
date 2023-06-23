import 'package:base_dependencies/dependencies.dart';
import 'package:micro_app_consumo_exame/core/adapters/http/http_client_adapter.dart';
import 'package:micro_app_consumo_exame/core/adapters/http/http_interface.dart';
import 'package:micro_app_consumo_exame/core/constants/api_routes.dart';
import 'package:micro_app_consumo_exame/core/data/modules/user_auth_info_model.dart';
import 'package:micro_app_consumo_exame/core/entities/user_auth_info.dart';
import 'package:micro_app_consumo_exame/core/exceptions/exceptions.dart';
import 'package:micro_app_consumo_exame/core/utils/result.dart';

import '../entities/user_token.dart';
import '../models/user_token_model.dart';
import '../models/validate_model.dart';

//const apiKey = 'f32fdf49-1528-4ae4-bcbd-296c27441297';

class AuthenticationRepository {
  final IHttpClient _http;
  final String apiKey = HiaeFlavors.instance.configs['apiKey'];
  late String? token;

  AuthenticationRepository({required HttpClient http}) : _http = http;

  Future<Result<Failure, String>> validateToken({
    required UserToken userToken,
  }) async {
    final data = userToken.clientId == typeLogin.HIAIEinsteinMedico
        ? UserTokenModel.fromEntity(entity: userToken).toMapDoctor()
        : UserTokenModel.fromEntity(entity: userToken).toMapPatient();

    final String route = userToken.clientId == typeLogin.HIAIEinsteinMedico
        ? ApiRoutes.tokenDoctor
        : ApiRoutes.tokenPatient;

    try {
      final response = await _http.post(
        route,
        body: data,
      );

      token = response.data['access_token'];

      return token != null
          ? Result.success(token)
          : Result.failure(
              HttpFailure(
                message: 'Usuário ou senha inválidos(s)',
              ),
            );
    } catch (error) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
        ),
      );
    }
  }

  Future<Result<Failure, String>> validateAuth({
    required ValidateModel validateModel,
  }) async {
    try {
      final response = await _http.get(
        ApiRoutes.validateApp,
        queryParameters: validateModel.toMap(),
        headers: {
          'apiKey': apiKey,
          'Authorization': 'Bearer $token',
        },
      );

      final String transaction = response.data['id'];
      return Result.success(transaction);
    } catch (error) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
        ),
      );
    }
  }

  Future<Result<Failure, UserAuthInfoEntity>> openScreen(
    final String transactionId,
  ) async {
    try {
      final response = await _http.get(
        ApiRoutes.openScreen,
        headers: {
          'Authorization': 'Bearer $token',
        },
        queryParameters: {
          'transactionId': transactionId,
        },
      );

      return response.statusCode == 200
          ? Result.success(
              UserAuthInfoModel.fromMap(
                response.data,
              ),
            )
          : Result.failure(
              HttpFailure(
                message: response.data,
              ),
            );
    } catch (error) {
      return Result.failure(
        HttpFailure(
          message: error.toString(),
        ),
      );
    }
  }
}
