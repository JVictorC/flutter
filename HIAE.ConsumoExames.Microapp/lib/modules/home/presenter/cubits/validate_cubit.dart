import 'package:bloc/bloc.dart';

import '../../../../core/utils/local_storage_utils.dart';
import '../../domain/usecases/open_screen_usecase.dart';
import 'validate_cubit_state.dart';

class ValidateCubit extends Cubit<ValidateState> {
  final IOpenScreenUseCase _openScreenUseCase;
  late final Map<String, dynamic> _dataMap;

  ValidateCubit({
    required IOpenScreenUseCase openScreenUseCase,
  })  : _openScreenUseCase = openScreenUseCase,
        super(ValidateInitialState());

  Future<void> _loadData() async {
    _dataMap = await getDataLoginParams();
  }

  Future<void> openScreen() async {
    emit(ValidateLoadingState());
    await _loadData();
    final idTransaction = _dataMap['transactionId'];
    final token = _dataMap['token'];
    final localization = _dataMap['localization'];
    final patientName = _dataMap['patientName'];
    final medicalRecord = _dataMap['medicalRecord'];
    final route = _dataMap['route'];

    final result = await _openScreenUseCase(
      idTransaction: idTransaction,
      token: token,
    );

    if (result.isSuccess) {
      emit(
        ValidateSuccessState(
          user: result.value!,
          token: token,
          localization: localization,
          medicalRecord: medicalRecord,
          patientName: patientName,
          route: route,
        ),
      );
    } else {
      emit(ValidateFailureState(failure: result.error!));
    }
  }
}
