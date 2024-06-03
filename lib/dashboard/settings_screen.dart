import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/screens/account_screen.dart';
import 'package:susubox/utils/utils.dart';

import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            SizedBox(width: 10.w),
            Icon(
                Icons.account_circle_sharp,
                size: 30.h,
              color: buttonColor,
              ),
          ],
        ),
        title:  Text('Settings',
          style: TextStyle(color: Colors.white, fontSize:27.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
          actions: [
            Row(
                children: [
                  Icon(Icons.notifications, color: Colors.white, size: 20.h),
                  SizedBox(width: 10.w)
                ])
          ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                title: Text('Account',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AccountScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                title: Text('Notifications',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.history_toggle_off_sharp,
                  color: Colors.white,
                ),
                title: Text('Activities',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                ),
                title: Text('Privacy Policy',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.document_scanner,
                  color: Colors.white,
                ),
                title: Text('Terms and Conditions',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                title: Text('About',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                title: Text('Logout',
                  style: TextStyle(color: Colors.white, fontSize:14.sp, fontWeight: FontWeight.w400),
                ),
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
