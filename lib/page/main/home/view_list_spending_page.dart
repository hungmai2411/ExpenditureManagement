import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_day.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class ViewListSpendingPage extends StatelessWidget {
  const ViewListSpendingPage({Key? key, required this.spendingList})
      : super(key: key);
  final List<Spending> spendingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ItemSpendingDay(spendingList: spendingList),
    );
  }
}
