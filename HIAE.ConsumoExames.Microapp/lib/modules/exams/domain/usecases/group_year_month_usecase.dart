import '../entities/date_exam_entity.dart';

abstract class IGroupYearMonthUseCase {
  Map<int, List<int>> call({
    required List<DateExamEntity> listDate,
  });
}

class GroupYearMonthUseCase implements IGroupYearMonthUseCase {
  @override
  Map<int, List<int>> call({
    required List<DateExamEntity> listDate,
  }) {
    final Map<int, List<int>> groupMap = {};
    final List<int> listMonth = [];
    int year;

    while (listDate.isNotEmpty) {
      year = listDate.first.dtExecution.year;

      final listDatesOfTheYear = listDate
          .where(
            (element) => element.dtExecution.year == year,
          )
          .toList();

      if (listDatesOfTheYear.isNotEmpty) {
        listDatesOfTheYear
            .sort((a, b) => b.dtExecution.compareTo(a.dtExecution));

        if (listMonth.isNotEmpty) {
          listMonth.clear();
        }

        while (listDatesOfTheYear.isNotEmpty) {
          int month = listDatesOfTheYear.first.dtExecution.month;

          listMonth.add(month);

          listDatesOfTheYear
              .removeWhere((element) => element.dtExecution.month == month);
        }

        if (listMonth.isNotEmpty) {
          groupMap.addAll({
            year: listMonth.toSet().toList(),
          });
        }
      }

      listDate.removeWhere((element) => element.dtExecution.year == year);
    }

    return groupMap;
  }
}
