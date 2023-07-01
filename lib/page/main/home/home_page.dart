import 'dart:developer';

import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/function/extension.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_widget.dart';
import 'package:expenditure_management/page/main/home/widget/summary_spending.dart';
import 'package:expenditure_management/repository/spending_repository.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _monthController;
  List<DateTime> months = [];
  List<Spending>? spendings;
  bool isLoading = true;
  int idUser = 0;

  @override
  void initState() {
    _monthController = TabController(length: 19, vsync: this);
    _monthController.index = 17;
    _monthController.addListener(() async {
      setState(() {
        isLoading = true;
      });

      await getAllSpendings(18 - _monthController.index);

      setState(() {
        isLoading = false;
      });
    });
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month);
    months = [DateTime(now.year, now.month + 1), now];
    for (int i = 1; i < 19; i++) {
      now = DateTime(now.year, now.month - 1);
      months.add(now);
    }
    getAllSpendings(18 - _monthController.index);
    super.initState();
  }

  Future<void> getAllSpendings(int index) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt('userID') ?? -1;

    spendings = await SpendingRepository().getAllSpendingsByMonth(
      userID,
      months[index].month,
      months[index].year,
    );

    setState(() {
      isLoading = false;
      idUser = userID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading == true ? loading() : body(spendingList: spendings),
      ),
    );
  }

  Widget body({List<Spending>? spendingList}) {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: TabBar(
            controller: _monthController,
            isScrollable: true,
            labelColor: Colors.black87,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelColor: const Color.fromRGBO(45, 216, 198, 1),
            unselectedLabelStyle: AppStyles.p,
            indicatorColor: Colors.green,
            tabs: List.generate(19, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Tab(
                  text: index == 17
                      ? AppLocalizations.of(context)
                          .translate('this_month')
                          .capitalize()
                      : (index == 18
                          ? AppLocalizations.of(context)
                              .translate('next_month')
                              .capitalize()
                          : (index == 16
                              ? AppLocalizations.of(context)
                                  .translate('last_month')
                                  .capitalize()
                              : DateFormat("MM/yyyy")
                                  .format(months[18 - index]))),
                ),
              );
            }),
          ),
        ),
        SummarySpending(
          userID: idUser,
          walletId: 5,
          month: months[18 - _monthController.index].month,
          year: months[18 - _monthController.index].year,
        ),
        const SizedBox(height: 10),
        Text(
          "${AppLocalizations.of(context).translate('spending_list')} ${_monthController.index == 17 ? AppLocalizations.of(context).translate('this_month') : DateFormat("MM/yyyy").format(months[18 - _monthController.index])}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        spendingList!.isNotEmpty
            ? Expanded(child: ItemSpendingWidget(spendingList: spendingList))
            : Expanded(
                child: Center(
                  child: Text(
                    "${AppLocalizations.of(context).translate('no_data')} ${_monthController.index == 17 ? AppLocalizations.of(context).translate('this_month') : DateFormat("MM/yyyy").format(months[18 - _monthController.index])}!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget loading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate('this_month').capitalize(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          //const SummarySpending(),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate('this_month_spending_list'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const ItemSpendingWidget(),
        ],
      ),
    );
  }
}
