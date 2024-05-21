import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/utils/utils.dart';

import '../components/arrow_pointer.dart';

class SchemesCardData{
  final String name;
  final String description;

  const SchemesCardData(this.name, this.description);
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

class _SusuScreenState extends State<SusuScreen> {

  final List<SchemesCardData> cardDataList = [
    const SchemesCardData('Personal Susu', 'Save money towards your personal needs such as education, home etc.'),
    const SchemesCardData('Biz Susu', 'Save money towards your business needs.'),
    const SchemesCardData('Goal Getter', 'Save money towards your personal needs such as education, home etc.'),
    const SchemesCardData('Flexy Susu', 'Save money towards your personal needs such as education, home etc.')
  ];
  
  final List<MyAccountCardData> accountCardData = [
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 5),
    const MyAccountCardData('Savings for bills', 'Personal susu', '800', 0),
    const MyAccountCardData('AJ Ventures', 'Biz susu', '2900', 15),
    const MyAccountCardData('Mom Savings', 'Personal susu', '2900', 3),
  ];
  
  bool showMyAccount = true;
  bool showAllAccounts = false;

  @override
  Widget build(BuildContext context) {
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
                          child: Text('My Account',
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
                        child: Text('All Accounts',
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
              allAccounts()
            else if(showMyAccount)
              myAccount()
          ],
        ),
      ),
    );
  }

  Widget allAccounts(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text('Our',
            style: TextStyle(fontSize: 35.sp, color: Colors.white, fontWeight: FontWeight.w600, height: 1.0),
          ),
          Text('susu schemes',
            style: TextStyle(fontSize: 35.sp, color: Colors.white, fontWeight: FontWeight.w600, height: 1.0),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 20.0,
              mainAxisExtent: 178.h
            ),
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: blackFaded
                    ),
                    child: Column(
                      children: [
                        Text(cardDataList[index].name,
                          style: TextStyle(fontSize: 20.sp, color: buttonColor, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 3.h),
                        Text(cardDataList[index].description,
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(50,30)
                          ),
                          onPressed: () {
                            switch(index){
                              case 0:

                              case 1:

                              case 2:

                              case 3:

                        }
                          },
                          child: Text('View details',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                        ),
                        SizedBox(height: 5.h),
                        GestureDetector(
                          onTap: (){

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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget myAccount(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: accountCardData.length,
        itemBuilder: (context, index) {

          bool activateButton = accountCardData[index].dueDays < 1;

          return Container(
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: buttonColor
                          ),
                          height: 35.h,
                          width: 35.h,
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(accountCardData[index].scheme,
                              style: TextStyle(fontSize: 11.sp, color: buttonColor, fontWeight: FontWeight.w500),
                            ),
                            Text(accountCardData[index].name,
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
                        color: textFieldColor // Replace textFieldColor with Colors.grey for this example
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
                Text('GHS',
                  style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w700, height: 0.1),
                ),
                Text(accountCardData[index].amount,
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
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.h);
      },
      ),
    );
  }

  Widget noAccount(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
            child: CustomPaint(
              painter: ArrowPainter(),
            ),
            ),
            Text('You\'ve not added any',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white)
            ),
            Text('account yet',
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
                  child: Text('All Accounts ',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: buttonColor)
                  ),
                ),
                Text('and add an account',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
                ),
              ],
            ),
            Text('to manage your finances here',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.grey)
            ),
          ],
      ),
    );
  }
}

