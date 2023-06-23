import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_consumo_exame/core/adapters/http/http_client_adapter.dart';
import 'package:micro_app_consumo_exame/core/di/initInjector.dart';

import '../entities/user_token.dart';
import '../models/validate_model.dart';
import '../repositories/authentication_repository.dart';
import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitialState());

  late final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository(
    http: HttpClient(
      I.getDependency(),
    ),
  );

  Future<void> validateToken({required UserToken userToken}) async {
    final result =
        await _authenticationRepository.validateToken(userToken: userToken);

    if (result.isSuccess) {
      emit(AuthenticationValidateTokenState(token: result.value!));
    } else {
      emit(
        AuthenticationFailureState(
          failure: result.error!,
        ),
      );
    }
  }

  Future<void> authentication({
    required String accessType,
    required String identifier,
  }) async {
    emit(AuthenticationLoadState());

    final resultValidation = await _authenticationRepository.validateAuth(
      validateModel: ValidateModel(
        accessType: accessType,
        identifier: identifier,
      ),
    );

    if (resultValidation.isSuccess) {
      emit(AuthenticationSuccessState(id: resultValidation.value!));
    } else {
      emit(
        AuthenticationFailureState(
          failure: resultValidation.error!,
        ),
      );
    }
  }
}
