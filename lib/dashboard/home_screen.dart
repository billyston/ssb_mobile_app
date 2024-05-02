import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
        title: Text('Hello, Kwame',
            style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w400)
        ),
        actions: [
          Row(
            children: [
              Container(
                width: 37.w,
                height: 37.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor
                ),
              ),
              SizedBox(width: 10.w)
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: blackFaded
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your balance',
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w400)
                          ),
                          const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.add_box_outlined,
                                color: buttonColor,
                              )
                          )
                        ],
                      ),
                      Text('GHS 10.00',
                          style: TextStyle(fontSize: 30.sp, color: Colors.white, fontWeight: FontWeight.w400)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Activity',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w700)
                    ),
                    TextButton(
                        onPressed: null,
                        child: Text('See all',
                            style: TextStyle(fontSize: 12.sp, color: buttonColor, fontWeight: FontWeight.w700)
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
}
