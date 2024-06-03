import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:susubox/dashboard/home_screen.dart';
import 'package:susubox/dashboard/settings_screen.dart';
import 'package:susubox/dashboard/susu_screen.dart';
import 'package:susubox/model/linked_accounts.dart';
import 'package:susubox/utils/utils.dart';

import '../components/dialogs/link_account_dialog.dart';

class DashboardScreen extends StatefulWidget {
  int selectedBottomIndex;
  int initialPage;

   DashboardScreen({required this.selectedBottomIndex, required this.initialPage, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late PageController pageController = PageController(initialPage: widget.initialPage);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if(widget.selectedBottomIndex != 0){
          setState(() {
            widget.selectedBottomIndex = 0;
            pageController.jumpToPage(0);
          });
        }
        else{
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                    currentIndex: widget.selectedBottomIndex,
                    selectedItemColor: buttonColor,
                    unselectedItemColor: Colors.white,
                    onTap: (index) {
                      setState(() {
                        widget.selectedBottomIndex = index;
                        pageController.jumpToPage(index);
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_filled, size: 15.h,),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.wallet, size: 15.h),
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
      ),
    );
  }
}
