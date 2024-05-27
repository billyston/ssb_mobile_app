import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/auth/continue_registration_ussd.dart';
import 'package:susubox/auth/login_screen.dart';
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
    return Scaffold(
      backgroundColor: buttonColor,
        body: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              CarouselSlider.builder(
                itemCount: 3,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height * 0.6,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  Color containerColor = buttonColor;
                  String text = 'Save money\n   for your\n    dreams';
                  if (index == 1) {
                    containerColor = Colors.blue;
                    text = 'Get analysis\n   of your\n   expenses';
                  } else if (index == 2) {
                    containerColor = Colors.purple;
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                          Text('Description goes here',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w300),
                          ),
                        ],
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
                    backgroundColor: blackFaded,
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50)
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: Text('CREATE ACCOUNT',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
              SizedBox(height: 15.h),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text('LOGIN NOW',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.white)),
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
          width: _currentPage == i ? 13.w : 7.w,
          height: _currentPage == i ? 13.h : 7.h,
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
