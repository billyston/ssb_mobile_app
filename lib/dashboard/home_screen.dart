import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:susubox/dashboard/dashboard_screen.dart';
import 'package:susubox/dashboard/susu_screen.dart';
import 'package:susubox/utils/utils.dart';

import '../components/dialogs/link_account_dialog.dart';

class GroupData {
  String title;
  String subTitle;
  String image;

  GroupData(this.title, this.subTitle, this.image);
}

class CardData{
  final String name;
  final String description;
  final IconData icon;

  const CardData(this.name, this.description, this.icon);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ImageProvider coinsBg = const AssetImage("assets/images/advert.jpg");
  ImageProvider personalSusu = const AssetImage("assets/images/personal_susu_bg.jpg");
  ImageProvider bizSusu = const AssetImage("assets/images/biz_susu_bg.jpg");

  final List<GroupData> groupDataList = [
    GroupData('Personal Susu', 'Short Personal Susu description goes here', 'assets/images/personal_susu_bg.jpg'),
    GroupData('Biz Susu', 'Short Biz Susu description goes here', 'assets/images/biz_susu_bg.jpg'),
  ];

  final List<CardData> cardDataList = [
    const CardData('About', 'Learn more about Susubox', Icons.people_alt_rounded),
    const CardData('Products', 'Diverse susu products', Icons.add),
    const CardData('Terms & Conditions', 'View our T&Cs', CupertinoIcons.plus_rectangle_on_rectangle),
    const CardData('Help & Support', '24/7 help/support service', CupertinoIcons.chat_bubble_2_fill)
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
                    height: MediaQuery.of(context).size.height * 0.35,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 45.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)
                        ),
                        image: DecorationImage(
                            image: coinsBg,
                            fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildPageIndicator(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child:  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        mainAxisExtent: 60.h
                    ),
                    itemCount: cardDataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: blackFaded
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: buttonColor
                                ),
                                child: Icon(cardDataList[index].icon, size: 22.h, color: Colors.white),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cardDataList[index].name,
                                      style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                    Text(cardDataList[index].description,
                                      style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quick Account',
                         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: (){

                        },
                        child: Row(
                          children: [
                            Text('View all',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: buttonColor
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 8.h,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 20.h),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: buttonColor
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
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
          width: 95.w,
          height: 2.h,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: i <= _currentPage ? Colors.white : Colors.transparent,
              border: Border.all(color: Colors.white.withOpacity(0.5))
          ),
        ),
      );
    }
    return indicators;
  }

}
