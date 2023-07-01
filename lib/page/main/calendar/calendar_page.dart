import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/build_spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:expenditure_management/page/main/calendar/widget/total_spending.dart';
import 'package:expenditure_management/repository/spending_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Spending>? _currentSpendingList;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  int userID = 6;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpendings();
  }

  void getSpendings() async {
    _currentSpendingList = await SpendingRepository().getAllSpendingsByDate(
      userID,
      _focusedDay.day,
      _focusedDay.month,
      _focusedDay.year,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loadingData(),
      ),
    );
  }

  Widget loadingData() {
    return Column(
      children: [
        CustomTableCalendar(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onPageChanged: (focusedDay) =>
                setState(() => _focusedDay = focusedDay),
            onDaySelected: (selectedDay, focusedDay) async {
              _currentSpendingList =
                  await SpendingRepository().getAllSpendingsByDate(
                userID,
                focusedDay.day,
                focusedDay.month,
                focusedDay.year,
              );
              if (mounted) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });
              }
            }),
        TotalSpending(
          list: _currentSpendingList,
        ),
        Expanded(
          child: BuildSpending(
            spendingList: _currentSpendingList,
            date: _focusedDay,
            onDeleted: (id) {
              _currentSpendingList!
                  .removeWhere((spending) => spending.id == id);

              setState(() {});
            },
          ),
        )
      ],
    );
  }
}
