import '../entities/date_exam_entity.dart';

abstract class IGroupDateUseCase {
  void call({
    required List<DateExamEntity> listDate,
    required List<DateTime> externalDate,
  });
}

class GroupDateUseCase implements IGroupDateUseCase {
  @override
  void call({
    required List<DateExamEntity> listDate,
    required List<DateTime> externalDate,
  }) {
    final List<DateExamEntity> auxList = listDate;
    final List<DateExamEntity> newList = [];

    for (var element in listDate) {
      final isGroupDate =
          (auxList.where((e) => e.dtExecution == element.dtExecution).length >
              1);

      if (!isGroupDate ||
          !newList.any(
            (newElement) => newElement.dtExecution == element.dtExecution,
          )) {
        element.grouped = isGroupDate;

        newList.add(element);
      }
    }

    if (externalDate.isNotEmpty) {
      final newExternalDate = externalDate.toSet().toList();

      int position = newList.length;

      for (var date in newExternalDate) {
        if (!newList.any(
          (element) =>
              element.dtExecution.day == date.day &&
              element.dtExecution.month == date.month &&
              element.dtExecution.year == date.year,
        )) {
          position++;

          newList.add(
            DateExamEntity(
              passageId: '',
              dtExecution: date,
              position: position,
              passagePlace: '',
              passageType: '',
              externalExam: true,
            ),
          );
        }
      }
    }

    listDate.clear();
    listDate.addAll(newList);
    listDate.sort((a, b) => b.dtExecution.compareTo(a.dtExecution));
  }
}
