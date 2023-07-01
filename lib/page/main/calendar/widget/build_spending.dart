import 'package:expenditure_management/constants/function/route_function.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/main.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_widget.dart';
import 'package:expenditure_management/page/view_spending/view_spending_page.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildSpending extends StatefulWidget {
  const BuildSpending({
    Key? key,
    this.spendingList,
    this.date,
    this.change,
    this.onDeleted,
  }) : super(key: key);
  final List<Spending>? spendingList;
  final DateTime? date;
  final Function(Spending spending)? change;
  final Function(int id)? onDeleted;

  @override
  State<BuildSpending> createState() => _BuildSpendingState();
}

class _BuildSpendingState extends State<BuildSpending> {
  @override
  Widget build(BuildContext context) {
    return widget.spendingList != null
        ? (widget.spendingList!.isEmpty
            ? Center(
                child: Text(
                  "${AppLocalizations.of(context).translate('you_have_spending_the_day')} ${DateFormat("dd/MM/yyyy").format(widget.date!)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : showListSpending(widget.spendingList!))
        : loadingItemSpending();
  }

  Widget showListSpending(List<Spending> spendingList) {
    var numberFormat = NumberFormat.currency(locale: "vi_VI");

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: spendingList.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(context).push(createRoute(
              screen: ViewSpendingPage(
                spending: spendingList[index],
                change: (spending) {
                  if (widget.change != null) widget.change!(spending);
                },
                delete: (id) {
                  setState(() {
                    widget.onDeleted!(id);
                  });
                },
              ),
              begin: const Offset(1, 0),
            ));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Image.network(
                    spendingList[index].imageType!,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate(spendingList[index].type!),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      numberFormat.format(spendingList[index].moneySpend),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
