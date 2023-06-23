import '../../domain/entities/exam_image_result_entity.dart';
import '../../domain/usecases/get_image_result_usecase.dart';

class ExamImageResultModel extends ExamImageResultEntity {
  const ExamImageResultModel({
    required String? getUserTokenResult,
  }) : super(getUserTokenResult: getUserTokenResult ?? '');

  Map<String, dynamic> toMap() => <String, dynamic>{
        'getUserTokenResult': getUserTokenResult,
      };

  factory ExamImageResultModel.fromMap(Map<String, dynamic> map) =>
      ExamImageResultModel(
        getUserTokenResult: map['getUserTokenResult'] as String,
      );

  static Map<String, dynamic> toRequest(ExamImageParam param) =>
      <String, dynamic>{
        'patientId': param.patientId ?? '',
        'issuer': param.issuer ?? '',
        'studyInstanceUID': param.studyInstanceUID ?? '',
        'accessionNumber': param.accessionNumber ?? '',
      };
}
