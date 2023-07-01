import 'dart:math';

import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/models/summary.dart';
import 'package:expenditure_management/repository/spending_repository.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class SummarySpending extends StatefulWidget {
  final int walletId;
  final int userID;
  final int month;
  final int year;
  const SummarySpending({
    Key? key,
    required this.walletId,
    required this.userID,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<SummarySpending> createState() => _SummarySpendingState();
}

class _SummarySpendingState extends State<SummarySpending> {
  Summary? summary;

  @override
  void initState() {
    super.initState();
    getSummary();
  }

  void getSummary() async {
    summary = await SpendingRepository().getSummary(
      widget.userID,
      widget.month,
      widget.year,
      widget.walletId,
    );
    if (mounted) {
      setState(() {});
    }
  }

  final numberFormat = NumberFormat.currency(locale: "vi_VI");

  @override
  Widget build(BuildContext context) {
    return summary == null ? loadingSummary() : body();
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate('first_balance'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    numberFormat.format(summary!.firstBalance),
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate('final_balance'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    numberFormat.format(summary!.lastBalance),
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    numberFormat.format(summary!.spended),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingSummary() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate('first_balance'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  textLoading()
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate('final_balance'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  textLoading()
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Row(
                children: [const Spacer(), textLoading()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 25,
        width: Random().nextInt(50) + 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
