import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

List<int> renderListMoney(
    {required int index,
    required DateTime dateTime,
    required List<Spending> list,
    required Function(List<String>) getList}) {
  List<String> listTitle = [];
  if (index == 0) {
    getList(listTitle);
    return List.generate(7, (index) {
      int weekDay = dateTime.weekday;
      DateTime firstDayOfWeek = dateTime.subtract(Duration(days: weekDay - 1));
      List<Spending> spendingList = list
          .where((element) => isSameDay(
              element.dateTime, firstDayOfWeek.add(Duration(days: index))))
          .toList();
      return spendingList.isEmpty
          ? 0
          : spendingList
              .map((e) => e.money)
              .reduce((value, element) => value + element);
    });
  } else if (index == 1) {
    List<int> listMoney = [];
    bool check = true;
    DateTime date = DateTime(dateTime.year, dateTime.month, 1);
    while (check) {
      int weekDay = date.weekday;
      DateTime lastWeek = date.add(Duration(days: 7 - weekDay));
      check = isSameMonth(date, lastWeek);

      if (!check) {
        lastWeek = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.month < 12
                ? DateTime(dateTime.year, dateTime.month + 1, 0).day
                : DateTime(dateTime.year + 1, 1, 0).day);
      }
      listTitle.add(
          "${DateFormat("dd/MM").format(date)} - ${DateFormat("dd/MM").format(lastWeek)}");
      List<Spending> spendingList = list
          .where((element) =>
              date.isBefore(element.dateTime) &&
                  lastWeek.isAfter(element.dateTime) ||
              isSameDay(element.dateTime, date) ||
              isSameDay(element.dateTime, date))
          .toList();
      listMoney.add(spendingList.isEmpty
          ? 0
          : spendingList
              .map((e) => e.money)
              .reduce((value, element) => value + element));
      if (check) {
        date = lastWeek.add(const Duration(days: 1));
      }
    }
    getList(listTitle);
    return listMoney;
  } else {
    getList(listTitle);
    return List.generate(12, (index) {
      List<Spending> spendingList = list
          .where((element) => isSameMonth(
              element.dateTime, DateTime(dateTime.year, (index + 1))))
          .toList();
      return spendingList.isEmpty
          ? 0
          : spendingList
              .map((e) => e.money)
              .reduce((value, element) => value + element);
    });
  }
}
