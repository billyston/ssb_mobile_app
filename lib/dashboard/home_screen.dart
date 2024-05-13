import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/utils/utils.dart';

class GroupData {
  String title;
  String subTitle;
  String image;

  GroupData(this.title, this.subTitle, this.image);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ImageProvider coinsBg = const AssetImage("assets/images/coins_bg.png");
  ImageProvider personalSusu = const AssetImage("assets/images/personal_susu_bg.jpg");
  ImageProvider bizSusu = const AssetImage("assets/images/biz_susu_bg.jpg");

  final List<GroupData> groupDataList = [
    GroupData('Personal Susu', 'Short Personal Susu description goes here', 'assets/images/personal_susu_bg.jpg'),
    GroupData('Biz Susu', 'Short Biz Susu description goes here', 'assets/images/biz_susu_bg.jpg'),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.31,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    String text = 'Save money\nfor your\ndreams';
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: coinsBg,
                            fit: BoxFit.cover,
                            opacity: 0.4
                        ),
                    gradient: const LinearGradient(
                    colors: [
                        Color(0xFF994933),
                        Color(0xFF994933),
                        Color(0xFFFF7955),
                        Color(0xFFFF7955),
                        Color(0xFFFF7955),
                        Color(0xFFFF7955)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                      ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(text,
                            style: TextStyle(color: Colors.white, fontSize:27.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.h),
                          Text('Some description goes here',
                            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _buildPageIndicator(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                             Container(
                               padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: textFieldColor
                                ),
                                 child: Icon(Icons.home_filled, size: 15.h, color: buttonColor),
                             ),
                                 SizedBox(width: 5.w),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('About SusuBox',
                                       style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                    Text('Learn more about SusuBox',
                                      style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textFieldColor
                                ),
                                child: Icon(Icons.dashboard, size: 15.h, color: buttonColor),
                              ),
                              SizedBox(width: 5.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Products',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                  Text('Diverse susu products',
                                    style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textFieldColor
                                ),
                                child: Icon(Icons.document_scanner, size: 15.h, color: buttonColor),
                              ),
                              SizedBox(width: 5.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Terms & Conditions',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                  Text('SusuBox terms & conditions',
                                    style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textFieldColor
                                ),
                                child: Icon(Icons.support_agent, size: 15.h, color: buttonColor),
                              ),
                              SizedBox(width: 5.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Help & Support',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                  Text('24/7 Help/Support    ',
                                    style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Text('QUICK ACCOUNT',
                          style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500)
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.31,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                            width: MediaQuery.of(context).size.width * 0.65,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(groupDataList[index].image),
                                    fit: BoxFit.cover,
                                  opacity: 0.5
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                      ),
                                      padding: const EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.call_made,
                                        color: Colors.black,
                                        size: 15.h,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                                Text(groupDataList[index].title,
                                  style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                                Text(groupDataList[index].subTitle,
                                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      indicators.add(
        Container(
          width: _currentPage == i ? 10.w : 7.w,
          height: _currentPage == i ? 10.h : 7.h,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? Colors.white : Colors.white,
          ),
        ),
      );
    }
    return indicators;
  }
}
