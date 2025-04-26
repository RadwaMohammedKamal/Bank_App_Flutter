import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../constants/color.dart';
import 'addaccount_screen.dart';
import 'currency_api/currency_screen.dart';
import 'myaccounts_screen.dart';
import 'news_app/news_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  void changeTab(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MyAccounts(changeTab: changeTab),
      AddAccount(changeTab: changeTab),
      NewsScreen(changeTab: changeTab),
      CurrencyScreen(changeTab: changeTab),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: rbackgroundcolor,
        color: rmaincolor,
        index: currentTabIndex,
        onTap: changeTab,
        items: const [
          Icon(Icons.account_balance, color: rbackgroundcolor),
          Icon(Icons.person_add_alt_1, color: rbackgroundcolor),
          Icon(Icons.newspaper, color: rbackgroundcolor),
          Icon(Icons.currency_bitcoin, color: rbackgroundcolor),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
