import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/analytic/widget/filter_page.dart';
import 'package:expenditure_management/page/main/analytic/widget/my_search_delegate.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_day.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? query;
  List<int> chooseIndex = [0, 0, 0, 0];
  int money = 0;
  DateTime? dateTime;
  String note = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool checkResult(Spending spending) {
    if (!listType[spending.type]["title"]!
        .toUpperCase()
        .contains(query!.toUpperCase())) return false;

    if (chooseIndex[0] == 1 && spending.money < money) {
      return false;
    } else if (chooseIndex[0] == 2 && spending.money > money) {
      return false;
    } else if (chooseIndex[0] == 4 && spending.money == money) {
      return false;
    }

    if (chooseIndex[2] == 1 && dateTime!.isAfter(spending.dateTime)) {
      return false;
    } else if (chooseIndex[2] == 2 && dateTime!.isBefore(spending.dateTime)) {
      return false;
    } else if (chooseIndex[2] == 4 && isSameDay(spending.dateTime, dateTime)) {
      return false;
    }

    if (spending.note != null && !spending.note!.contains(note)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context).translate('search'),
          ),
          onTap: () async {
            query = await showSearch(
              context: context,
              delegate: MySearchDelegate(
                text: AppLocalizations.of(context).translate('search'),
                q: _searchController.text,
              ),
            );
            setState(() {
              _searchController.text = query!;
            });
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterPage(
                    action: (list, money, dateTime, note) {
                      setState(() {
                        this.dateTime = dateTime;
                        this.money = money;
                        this.note = note;
                        chooseIndex = list;
                      });
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.tune_rounded),
          )
        ],
      ),
      body: query == null
          ? Container()
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("data")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data =
                      snapshot.requireData.data() as Map<String, dynamic>;
                  List<String> list = [];
                  for (var element in data.entries) {
                    list.addAll((element.value as List<dynamic>)
                        .map((e) => e.toString())
                        .toList());
                  }
                  return FutureBuilder(
                      future: SpendingFirebase.getSpendingList(list),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var spendingList = snapshot.data;
                          var list = spendingList!.where(checkResult).toList();
                          if (list.isEmpty) {
                            return const Center(
                              child: Text(
                                "Không có gì ở đây!",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }
                          return ItemSpendingDay(spendingList: list);
                        }
                        return const Center(child: CircularProgressIndicator());
                      });
                }
                return const Center(child: CircularProgressIndicator());
              }),
    );
  }
}
