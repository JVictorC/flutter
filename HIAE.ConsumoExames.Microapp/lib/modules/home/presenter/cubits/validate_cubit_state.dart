import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/user_validate_entity.dart';

abstract class ValidateState extends Equatable {}

class ValidateInitialState implements ValidateState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ValidateLoadingState implements ValidateState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class InvalidState implements ValidateState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class ValidateFailureState implements ValidateState {
  final Failure failure;

  ValidateFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];

  @override
  bool? get stringify => true;
}

class ValidateSuccessState implements ValidateState {
  final UserValidateEntity user;
  final String localization;
  final String token;
  final String? patientName;
  final String? medicalRecord;
  final String? route;

  ValidateSuccessState({
    required this.user,
    required this.localization,
    required this.token,
    required this.patientName,
    required this.medicalRecord,
    required this.route,
  });
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
