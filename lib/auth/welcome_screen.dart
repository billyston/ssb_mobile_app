import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/auth/login.dart';
import 'package:susubox/auth/register_screen.dart';
import 'package:susubox/utils/utils.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              CarouselSlider.builder(
                itemCount: 3,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height * 0.62,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  Color containerColor = buttonColor;
                  String text = 'Save money\nfor your\ndreams';
                  if (index == 1) {
                    containerColor = Colors.blue;
                    text = 'Get analysis\nof your\nexpenses';
                  } else if (index == 2) {
                    containerColor = Colors.purple;
                  }
                  return Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(right: 10.w),
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: containerColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: text,
                                  style: TextStyle(color: Colors.white, fontSize: 35.sp, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text('Description goes here',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {

                                  },
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {

                                  },
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h)
                        ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50)
                ),
                onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => const RegisterScreen());
                    Navigator.push(context, route);
                },
                child: Text('Get started for free',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50)
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => const LoginScreen());
                  Navigator.push(context, route);
                },
                child: Text('Login here',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      indicators.add(
        Container(
          width: 10.w,
          height: 10.h,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? buttonColor : Colors.white,
          ),
        ),
      );
    }
    return indicators;
  }
}
