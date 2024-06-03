import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/dashboard/dashboard_screen.dart';
import 'package:susubox/dashboard/susu_screen.dart';
import 'package:susubox/utils/utils.dart';

import '../ApiService/api_service.dart';
import '../components/dialogs/link_account_dialog.dart';
import '../components/error_container.dart';
import '../components/loading_dialog.dart';
import '../model/susu_schemes.dart';
import '../screens/create_susu/create_biz_susu_screen.dart';
import '../screens/create_susu/create_flexy_susu_screen.dart';
import '../screens/create_susu/create_goal_getter_susu_screen.dart';
import '../screens/create_susu/create_personal_susu_screen.dart';

class SchemesCardData{
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const SchemesCardData(this.name, this.description, this.icon, this.color);
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

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  ImageProvider coinsBg = const AssetImage("assets/images/advert.jpg");
  ImageProvider personalSusu = const AssetImage("assets/images/personal_susu_bg.jpg");
  ImageProvider bizSusu = const AssetImage("assets/images/biz_susu_bg.jpg");

  final List<SchemesCardData> groupDataList = [
    const SchemesCardData('Personal Susu', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.wallet, buttonColor),
    const SchemesCardData('Biz Susu', 'Save money towards your business needs.', FontAwesomeIcons.store, customGreen),
    const SchemesCardData('Goal Getter', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.trophy, customBrown),
    const SchemesCardData('Flexy Susu', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.briefcase, customPurple)

  ];

  final List<CardData> cardDataList = [
    const CardData('About', 'Learn more about Susubox', Icons.people_alt_rounded),
    const CardData('Products', 'Diverse susu products', CupertinoIcons.layers_alt_fill),
    const CardData('Terms & Conditions', 'View our T&Cs', FontAwesomeIcons.listCheck),
    const CardData('Help & Support', '24/7 help/support service', CupertinoIcons.chat_bubble_2_fill)
  ];

  int _currentPage = 0;
  String token = '';
  String resourceId = '';
  bool dataLoaded = false;
  bool errorOccurred = false;

  SusuSchemes? susuSchemes;
  List<Datum> schemesData = [];

  Future<SusuSchemes?> getSusuSchemes() async{
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      susuSchemes = await ApiService().getSusuSchemes(token).timeout(const Duration(seconds: 90));
      schemesData = susuSchemes!.data;
      print('Schemes $schemesData');
      setState(() {
        dataLoaded = true;
      });
    }
    catch(e){
      print('Error happened $e');
      setState(() {
        errorOccurred = true;
      });
    }
    return null;
  }

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    resourceId = (prefs.getString('resourceId') ?? '');
    getSusuSchemes();
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  errorOccurred ? ErrorContainer(refreshPage: getSusuSchemes)
        : dataLoaded ?
    Scaffold(
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
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
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
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: schemesData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              switch(index){
                                case 0:
                                  showSusuSchemeDetails(context, 'Personal\nSusu', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Convallis aenean et tortor at risus viverra adipiscing at in. Donec et odio pellentesque diam. Feugiat in fermentum posuere urna nec.\n\nMattis rhoncus urna neque viverra justo nec ultrices dui. Ipsum faucibus vitae aliquet nec ullamcorper. Mauris augue neque gravida in fermentum et sollicitudin. Feugiat nisl pretium fusce id velit ut. Dignissim enim sit amet venenatis.\n\nUt faucibus pulvinar elementum integer. Mattis pellentesque id nibh tortor. Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.\n\nEuismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.');
                                case 1:
                                  showSusuSchemeDetails(context, 'Biz\nSusu', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Convallis aenean et tortor at risus viverra adipiscing at in. Donec et odio pellentesque diam. Feugiat in fermentum posuere urna nec.\n\nMattis rhoncus urna neque viverra justo nec ultrices dui. Ipsum faucibus vitae aliquet nec ullamcorper. Mauris augue neque gravida in fermentum et sollicitudin. Feugiat nisl pretium fusce id velit ut. Dignissim enim sit amet venenatis.\n\nUt faucibus pulvinar elementum integer. Mattis pellentesque id nibh tortor. Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.\n\nEuismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.');
                                case 2:
                                  showSusuSchemeDetails(context, 'Goal Getter\nSusu', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Convallis aenean et tortor at risus viverra adipiscing at in. Donec et odio pellentesque diam. Feugiat in fermentum posuere urna nec.\n\nMattis rhoncus urna neque viverra justo nec ultrices dui. Ipsum faucibus vitae aliquet nec ullamcorper. Mauris augue neque gravida in fermentum et sollicitudin. Feugiat nisl pretium fusce id velit ut. Dignissim enim sit amet venenatis.\n\nUt faucibus pulvinar elementum integer. Mattis pellentesque id nibh tortor. Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.\n\nEuismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.');
                                case 3:
                                  showSusuSchemeDetails(context, 'Flexy\nSusu', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Convallis aenean et tortor at risus viverra adipiscing at in. Donec et odio pellentesque diam. Feugiat in fermentum posuere urna nec.\n\nMattis rhoncus urna neque viverra justo nec ultrices dui. Ipsum faucibus vitae aliquet nec ullamcorper. Mauris augue neque gravida in fermentum et sollicitudin. Feugiat nisl pretium fusce id velit ut. Dignissim enim sit amet venenatis.\n\nUt faucibus pulvinar elementum integer. Mattis pellentesque id nibh tortor. Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.\n\nEuismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.Euismod lacinia at quis risus sed vulputate. Neque egestas congue quisque egestas diam.');
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: blackFaded
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: groupDataList[index].color
                                    ),
                                    child: Icon(
                                      groupDataList[index].icon,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(schemesData[index].attributes.alias,
                                    style: TextStyle(fontSize: 19.sp, color: buttonColor, fontWeight: FontWeight.w500),
                                  ),
                                  Text(schemesData[index].attributes.description,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w300),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('View details',
                                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: buttonColor)
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          switch(index){
                                            case 0:
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const CreatePersonalSusuScreen()),
                                              );
                                            case 1:
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const CreateBizSusuScreen()),
                                              );
                                            case 2:
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const CreateGoalGetterSusuScreen()),
                                              );
                                            case 3:
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const CreateFlexySusuScreen()),
                                              );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF79552B),
                                              border: Border.all(color: buttonColor)
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: buttonColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 15.w);
                    },
                    ),
                  ),
                ),
                SizedBox(height: 10.h)
              ],
            ),
      )
    ) : const LoadingDialog();
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
