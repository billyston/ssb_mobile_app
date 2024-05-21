import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/dashboard/home_screen.dart';
import 'package:susubox/dashboard/settings_screen.dart';
import 'package:susubox/dashboard/susu_screen.dart';
import 'package:susubox/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final PageController pageController = PageController(initialPage: 0);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          HomeScreen(),
          SusuScreen(),
          SettingsScreen()
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                 backgroundColor: bottomAppBarColor,
                currentIndex: selectedIndex,
                selectedItemColor: buttonColor,
                unselectedItemColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    pageController.jumpToPage(index);
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled, size: 15.h,),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet, size: 15.h),
                    label: 'Susu',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings, size: 15.h),
                    label: 'Settings',
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
