import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/exam_evolutive_result_entity.dart';
import '../repositories/exam_repository_interface.dart';

class GetEvolutiveResultUseCase
    implements UseCase<ExamEvolutiveResultEntity, EvolutiveParam> {
  final IExamRepository _repository;

  GetEvolutiveResultUseCase(this._repository);
  @override
  Future<Result<Failure, ExamEvolutiveResultEntity>> call(
    EvolutiveParam params,
  ) async =>
      await _repository.getEvolutiveResult(params);
}

/// Quando for laudo de imagem, vem com número de Acesso No Exame (NumAcesso)
/// IdPassagem
/// IdExame
class EvolutiveParam extends Equatable {
  final String? chAuthentication;
  final String? idPassage;
  final String? codExam;
  final int? qtdPassages;
  final String? dtCut;

  const EvolutiveParam({
    this.chAuthentication,
    this.idPassage,
    this.codExam,
    this.qtdPassages,
    this.dtCut,
  });

  @override
  List<Object?> get props => [
        chAuthentication,
        idPassage,
        codExam,
        qtdPassages,
        dtCut,
      ];
}
