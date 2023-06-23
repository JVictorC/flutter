import 'package:equatable/equatable.dart';

class ExamImageResultEntity extends Equatable {
  final String getUserTokenResult;

  const ExamImageResultEntity({
    required this.getUserTokenResult,
  });

  @override
  List<Object> get props => [getUserTokenResult];
}
