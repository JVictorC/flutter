import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:micro_app_consumo_exame/core/di/initInjector.dart';
import 'package:micro_app_consumo_exame/core/infra/datasource/local_storage_datasource_interface.dart';
import 'package:micro_app_consumo_exame/core/utils/local_storage_utils.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/entities/download_exam_entity.dart';
import 'package:micro_app_consumo_exame/modules/exams/domain/repositories/exam_repository_interface.dart';
import 'package:micro_app_consumo_exame/modules/exams/infra/datasources/exam_datasource_interface.dart';
import 'package:micro_app_consumo_exame/modules/exams/infra/repositories/exam_repository.dart';
import 'exam_repository_test.mocks.dart';

@GenerateMocks([IExamDataSource, ILocalStorageDataSource])
void main() {
  late MockIExamDataSource mockExamDataSource;
  late MockILocalStorageDataSource mockLocalStorageDataSource;
  late IExamRepository examRepository;
  String authentication = '2231869';

  setUpAll(() {
    initInjector();
    mockExamDataSource = MockIExamDataSource();
    mockLocalStorageDataSource = MockILocalStorageDataSource();
    examRepository = ExamRepository(
      examDataSource: mockExamDataSource,
      localStorageDataSource: mockLocalStorageDataSource,
    );
  });

  group('downloadExamsPdf', () {
    test('success', () async {
      String returnValue = 'success';
      final DownloadExamEntity downloadExamEntity = DownloadExamEntity(
        examBreak: true,
        userType: 0,
        examCode: null,
        itensIdList: const ['62f40faf66226523b0590ddf'],
        passage: null,
        medicalAppointment: authentication,
        executionDateBegin: DateTime.now().add(
          const Duration(
            days: 1,
          ),
        ),
        executionDateEnd: DateTime.now().add(
          const Duration(
            days: 1,
          ),
        ),
      );

      when(getIdPatient()).thenAnswer((_) => '2322323');

      when(
        mockExamDataSource.downloadExamsPdf(
          downloadExamEntity: downloadExamEntity,
        ),
      ).thenAnswer((_) async => returnValue);

      final result = await examRepository.downloadExamsPdf(
        downloadExamEntity: downloadExamEntity,
      );
      expect(result.value, returnValue);
    });
  });
}
