import 'package:flutter/material.dart';
import 'package:susubox/dashboard/home_screen.dart';
import 'package:susubox/utils/Utils.dart';

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
        ],
      ),
      bottomNavigationBar:
         BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
           backgroundColor: const Color(0xFFD9D9D9),
          currentIndex: selectedIndex,
          selectedItemColor: buttonColor,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              pageController.jumpToPage(index);
            });
          },
          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                size: 25,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
    );
  }
}
