import 'package:expenditure_management/constants/function/on_will_pop.dart';
import 'package:expenditure_management/constants/function/route_function.dart';
import 'package:expenditure_management/page/add_spending/add_spending_page.dart';
import 'package:expenditure_management/page/main/analytic/analytic_page.dart';
import 'package:expenditure_management/page/main/calendar/calendar_page.dart';
import 'package:expenditure_management/page/main/home/home_page.dart';
import 'package:expenditure_management/page/main/profile/profile_page.dart';
import 'package:expenditure_management/page/main/widget/item_bottom_tab.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentTab = 0;
  List<Widget> screens = [
    const HomePage(),
    const CalendarPage(),
    const AnalyticPage(),
    const ProfilePage()
  ];

  DateTime? currentBackPressTime;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => onWillPop(
          action: (now) => currentBackPressTime = now,
          currentBackPressTime: currentBackPressTime,
        ),
        child: PageStorage(bucket: bucket, child: screens[currentTab]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            createRoute(screen: const AddSpendingPage()),
          );
          print(1);
          setState(() => currentTab = 1);
          print(2);
        },
        child: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('home'),
                    index: 0,
                    current: currentTab,
                    icon: FontAwesomeIcons.house,
                    action: () {
                      setState(() => currentTab = 0);
                    },
                  ),
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('calendar'),
                    index: 1,
                    current: currentTab,
                    size: 28,
                    icon: Icons.calendar_month_outlined,
                    action: () {
                      setState(() => currentTab = 1);
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('analytic'),
                    index: 2,
                    current: currentTab,
                    icon: FontAwesomeIcons.chartPie,
                    action: () {
                      setState(() => currentTab = 2);
                    },
                  ),
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('account'),
                    index: 3,
                    current: currentTab,
                    icon: currentTab == 3
                        ? FontAwesomeIcons.userLarge
                        : FontAwesomeIcons.user,
                    action: () {
                      setState(() => currentTab = 3);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
