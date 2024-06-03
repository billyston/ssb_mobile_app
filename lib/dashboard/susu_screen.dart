import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/components/error_container.dart';
import 'package:susubox/model/susu_accounts.dart'as susu_account;
import 'package:susubox/model/susu_schemes.dart';
import 'package:susubox/screens/account_details/flexy_susu_account_details.dart';
import 'package:susubox/screens/account_details/goal_getter_susu_details.dart';
import 'package:susubox/screens/account_details/personal_susu_account_details.dart';
import 'package:susubox/screens/create_susu/create_flexy_susu_screen.dart';
import 'package:susubox/screens/create_susu/create_goal_getter_susu_screen.dart';
import 'package:susubox/screens/create_susu/create_personal_susu_screen.dart';
import 'package:susubox/utils/utils.dart';

import '../ApiService/api_service.dart';
import '../components/arrow_pointer.dart';
import '../components/loading_dialog.dart';
import '../screens/account_details/biz_susu_account_details.dart';
import '../screens/create_susu/create_biz_susu_screen.dart';

class SchemesCardData{
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const SchemesCardData(this.name, this.description, this.icon, this.color);
}

class MyAccountCardData{
  final String name;
  final String scheme;
  final String amount;
  final int dueDays;

  const MyAccountCardData(this.name, this.scheme, this.amount, this.dueDays);
}

class SusuScreen extends StatefulWidget {
  const SusuScreen({super.key});

  @override
  State<SusuScreen> createState() => _SusuScreenState();
}

class _SusuScreenState extends State<SusuScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final List<SchemesCardData> cardDataList = [
    const SchemesCardData('Personal Susu', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.wallet, buttonColor),
    const SchemesCardData('Biz Susu', 'Save money towards your business needs.', FontAwesomeIcons.store, customGreen),
    const SchemesCardData('Goal Getter', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.trophy, customBrown),
    const SchemesCardData('Flexy Susu', 'Save money towards your personal needs such as education, home etc.', FontAwesomeIcons.briefcase, customPurple)
  ];
  
  final List<MyAccountCardData> accountCardData = [
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 5),
    const MyAccountCardData('Savings for bills', 'Personal susu', '800', 0),
    const MyAccountCardData('AJ Ventures', 'Biz susu', '2900', 15),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
  ];

  SusuSchemes? susuSchemes;
  List<Datum> schemesData = [];

  susu_account.SusuAccounts? susuAccounts;
  List<susu_account.Datum> susuAccountsData = [];

  bool showMyAccount = true;
  bool showAllAccounts = false;
  bool dataLoaded = false;
  bool errorOccurred = false;
  bool susuDataLoaded = false;
  bool susuErrorOccurred = false;

  String token = '';
  String resourceId = '';

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    resourceId = (prefs.getString('resourceId') ?? '');
    getAllSusuAccounts();
    getSusuSchemes();
  }

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

  Future<SusuSchemes?> getAllSusuAccounts() async{
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      susuAccounts = await ApiService().getSusuAccounts(token).timeout(const Duration(seconds: 90));
      susuAccountsData = susuAccounts!.data;
      print('Susu Data $susuAccountsData');
      setState(() {
        susuDataLoaded = true;
      });
    }
    catch(e){
      print('Error happened $e');
      setState(() {
        susuErrorOccurred = true;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Center(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    showAllAccounts = true;
                    showMyAccount = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: showAllAccounts ? buttonColor: textFieldColor
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            showMyAccount = true;
                            showAllAccounts = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: showMyAccount ? buttonColor : textFieldColor,
                          ),
                          child: Text('My susu',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: showMyAccount ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Susu schemes',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: showAllAccounts ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if(showAllAccounts)
              allSchemes()
            else if(showMyAccount)
              susuErrorOccurred ? Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  ErrorContainer(refreshPage: getAllSusuAccounts),
                ],
              )
              : susuDataLoaded ?
             susuAccountsData.isNotEmpty ? mySchemes() : noScheme()
                  : Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        const LoadingDialog(),
                      ],
                    ),
            SizedBox(height: 15.h)
          ],
        ),
      ),
    );
  }

  Widget allSchemes(){
    return errorOccurred ? Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        ErrorContainer(refreshPage: getSusuSchemes),
      ],
    )
      : dataLoaded ?
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text('Susu schemes',
            style: TextStyle(fontSize: 35.sp, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              mainAxisExtent: 170.h
            ),
            itemCount: schemesData.length < 2 ? schemesData.length : 4,
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
                                color: cardDataList[index].color
                            ),
                            child: Icon(
                              cardDataList[index].icon,
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
            },
          ),
        ],
      ),
    ) : Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const LoadingDialog(),
      ],
    );
  }

  Widget mySchemes(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: susuAccountsData.length,
        itemBuilder: (context, index) {

          bool activateButton = accountCardData[index].dueDays < 1;
          IconData personalSusuIcon = FontAwesomeIcons.wallet;
          IconData bizSusuIcon = FontAwesomeIcons.store;
          IconData goalGetterSusuIcon = FontAwesomeIcons.trophy;
          IconData flexySusuIcon = FontAwesomeIcons.briefcase;

          Color personalSusuColor = buttonColor;
          Color bizSusuColor = customGreen;
          Color goalGetterSusuColor = customBrown;
          Color flexySusuColor = customPurple;

          IconData susuIcon;
          Color susuColor;

          if(susuAccountsData[index].included.scheme.attributes.name == "Personal Susu Savings"){
            susuIcon = personalSusuIcon;
            susuColor = personalSusuColor;
          }
          else if(susuAccountsData[index].included.scheme.attributes.name == "Biz Susu Savings"){
            susuIcon = bizSusuIcon;
            susuColor = bizSusuColor;
          }
          else if(susuAccountsData[index].included.scheme.attributes.name == "Goal Getter Savings"){
            susuIcon = goalGetterSusuIcon;
            susuColor = goalGetterSusuColor;
          }
          else{
            susuIcon = flexySusuIcon;
            susuColor = flexySusuColor;
          }

          return GestureDetector(
            onTap: (){
              if(susuAccountsData[index].included.scheme.attributes.name == "Personal Susu Savings"){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PersonalSusuAccountDetails(resourceId: susuAccountsData[index].attributes.resourceId)),
                );
              }
              else if(susuAccountsData[index].included.scheme.attributes.name == "Biz Susu Savings"){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BizSusuAccountDetails(resourceId: susuAccountsData[index].attributes.resourceId)),
                );
              }
              else if(susuAccountsData[index].included.scheme.attributes.name == "Goal Getter Savings"){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoalGetterSusuAccountDetails(resourceId: susuAccountsData[index].attributes.resourceId)),
                );
              }
              else{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FlexySusuAccountDetails(resourceId: susuAccountsData[index].attributes.resourceId)),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: susuColor
                            ),
                            height: 35.h,
                            width: 35.h,
                            child: Icon(
                                susuIcon,
                               color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(susuAccountsData[index].included.scheme.attributes.name,
                                style: TextStyle(fontSize: 11.sp, color: buttonColor, fontWeight: FontWeight.w500),
                              ),
                              Text(susuAccountsData[index].attributes.accountName,
                                style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: textFieldColor
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Icon(
                                    Icons.notifications_none_outlined,
                                     color: activateButton ? buttonColor : Colors.grey, size: 22.h),
                                Positioned(
                                  top: 6.0,
                                  right: 5.5,
                                  child: Container(
                                    width: 7.w,
                                    height: 7.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: textFieldColor,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5.0,
                                  right: 5.5,
                                  child: Container(
                                    width: 7.w,
                                    height: 7.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border.all(color: activateButton ? buttonColor : Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(susuAccountsData[index].included.currency.attributes.currency,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w700, height: 0.1),
                  ),
                  Text(susuAccountsData[index].attributes.susuAmount,
                    style: TextStyle(fontSize: 35.sp, color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      activateButton ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 40)
                        ),
                        onPressed: () {

                        },
                        child: Text('Payment due',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                      ) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 40),
                          disabledBackgroundColor: Colors.black

                        ),
                        onPressed: null,
                        child: Text('Payment due in ${accountCardData[index].dueDays} days',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 15.h,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.h);
      },
      ),
    );
  }

  Widget noScheme(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 90.w),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
              child: CustomPaint(
                painter: ArrowPainter(),
              ),
              ),
            ),
            Text('You\'ve not started any',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white)
            ),
            Text('susu yet',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white)
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Go to ',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      showAllAccounts = true;
                      showMyAccount = false;
                    });
                  },
                  child: Text('Susu Schemes ',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: buttonColor)
                  ),
                ),
                Text('and create a new',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
                ),
              ],
            ),
            Text('susu account to start saving and ',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
            ),
            Text('manage your finances here',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
            ),
          ],
      ),
    );
  }
}

