import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/auth/login_screen.dart';
import 'package:susubox/components/ghanacard_dialog.dart';
import 'package:susubox/components/next_of_kin_dialog.dart';
import 'package:susubox/components/personal_info_dialog.dart';
import 'package:susubox/utils/utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.055),
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 20.h),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    color: buttonColor,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                        Text('Account',
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.09,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.05,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: const AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                ),
              ],
            ),
                  Text('Michael Kabutey Katey',
                   style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 5.h),
                  Text('+233241234514',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  SizedBox(height: 5.h),
                  ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blackBackground,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                    ),
                    icon: Icon(Icons.logout_rounded, color: Colors.white, size: 10.h),
                    label: Text('LOGOUT',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                       Column(
                         children: [
                           GestureDetector(
                             onTap: () {
                               showDialog(
                                 context: context,
                                 builder: (context) => const PersonalInfoDialog(),
                               );
                             },
                             child: Container(
                               alignment: Alignment.center,
                               height: 35.h,
                               width: 45.w,
                               decoration: BoxDecoration(
                                 border: Border.all(color: Colors.white),
                                 borderRadius: BorderRadius.circular(10)
                               ),
                               child: Text('i',
                                 style: TextStyle(color: Colors.white, fontSize: 30.sp),
                               ),
                             ),
                           ),
                           SizedBox(height: 5.h),
                           Text(' Personal',
                             style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                           ),
                           Text('Information',
                             style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                           ),
                         ],
                       ),
                       SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const NextOfKinDialog(),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Next of',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Kin',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const GhanaCardDialog(),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Link Ghana',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Card',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text('Linked Wallets',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('View Linked',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Wallets',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Link New',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Wallet',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Unlink',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Wallet',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text('Password/PIN management',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Change',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Password',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Change',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                          Text('Pin',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text('Help and Support',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('Contact Us',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
        
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text('i',
                                style: TextStyle(color: Colors.white, fontSize: 30.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text('FAQ',
                            style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w400, height: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
