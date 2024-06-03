import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/components/dialogs/pin_dialog.dart';
import 'package:susubox/model/personal_susu_account.dart';
import 'package:susubox/utils/utils.dart';

import '../../ApiService/api_service.dart';
import '../../components/error_container.dart';
import '../../components/loading_dialog.dart';
import '../transactions/transaction_history_screen.dart';

class PersonalSusuAccountDetails extends StatefulWidget {
  final String resourceId;
  const PersonalSusuAccountDetails({required this.resourceId, super.key});

  @override
  State<PersonalSusuAccountDetails> createState() =>
      _PersonalSusuAccountDetailsState();
}

class _PersonalSusuAccountDetailsState extends State<PersonalSusuAccountDetails> {
  bool isSwitched = false;
  var currentBalance = 'GHS ***';
  var label = 'Show balance';
  var availableBalance = '';

  String token = '';
  bool dataLoaded = false;
  bool errorOccurred = false;
  bool statusActive = false;
  bool pinVerified = false;

  void showBalance() {
    setState(() {
    isSwitched = true;
    currentBalance = availableBalance;
       label = 'Hide balance';
    });
  }

  void showPinDialog(){
    showDialog(
      context: context,
      builder: (context) =>  PinDialog(approveRequest: (balance) {
        setState(() {
          pinVerified = true;
          availableBalance = balance;
         showBalance();
        });
      },
        resourceId: accountData!.attributes.resourceId,
      ),
    );
  }

void toggleSwitch(bool value) {
  if (value) {
    if(pinVerified){
      showBalance();
    }
    else {
      showPinDialog();
    }
  } else {
    setState(() {
      isSwitched = false;
      currentBalance = 'GHS ***';
      label = 'Show balance';
    });
  }
}

  PersonalSusuAccount? susuAccount;
  Data? accountData;

  Future<PersonalSusuAccount?> getAccountDetails() async{
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      susuAccount = await ApiService().getPersonalSusuAccount(token, widget.resourceId).timeout(const Duration(seconds: 90));
      accountData = susuAccount!.data;
      if(accountData!.attributes.status == 'active'){
        statusActive = true;
      }
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
    getAccountDetails();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: errorOccurred ? ErrorContainer(refreshPage: getAccountDetails)
          : dataLoaded ?
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account details',
                    style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Text('${accountData!.attributes.status[0].toUpperCase()}${accountData!.attributes.status.substring(1).toLowerCase()}',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: statusActive ? customGreen : Colors.red,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: buttonColor,
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Available balance',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                             IconButton(
                                onPressed: (){
                                    infoDialog();
                                },
                                icon: GestureDetector(
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ))
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentBalance,
                                  style: TextStyle(
                                      fontSize: 27.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Text('${accountData!.type} (${accountData!.attributes.frequency[0].toUpperCase()}${accountData!.attributes.frequency.substring(1).toLowerCase()})',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  Text(label,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400)),
                                  Switch(
                                    onChanged: toggleSwitch,
                                    value: isSwitched,
                                    activeColor: buttonColor,
                                    activeTrackColor: Colors.black,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blackFaded),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Name',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      accountData!.attributes.accountName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Account Number',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      accountData!.attributes.accountNumber,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blackFaded),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Susu amount',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${accountData!.included.currency.attributes.currency} ${accountData!.attributes.susuAmount}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blackFaded),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linked Wallet (Mobile Money)',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      accountData!.attributes.linkedWallet,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                              border: Border.all(color: buttonColor)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Add money',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            height: 1),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                              border: Border.all(color: buttonColor)),
                          child: const Icon(
                            FontAwesomeIcons.wallet,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Settlement',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            height: 1),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          optionsDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                              border: Border.all(color: buttonColor)),
                          child: const Icon(
                            CupertinoIcons.list_bullet,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'More',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            height: 1),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction history',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TransactionHistoryScreen(resourceId: widget.resourceId)),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'View all',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: buttonColor),
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
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: blackFaded,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: buttonColor
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.wallet,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Debit',
                                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700),
                                    ),
                                    Text('Susu payment to account',
                                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text('GHS 540',
                              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 20.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: blackFaded
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text('01:20 PM',
                                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Text('Success',
                              style: TextStyle(color: customGreen, fontSize: 15.sp, fontWeight: FontWeight.w300),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.h);
                },
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ): const LoadingDialog()
    );
  }

  void infoDialog(){
    showMenu<String>(
      context: context,
      color: dialogColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      position: RelativeRect.fromLTRB(90.w, 100.h, 60.h, 0.0),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Purpose',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 5.h),
              Text(accountData?.attributes.purpose ?? 'No data',
                style: TextStyle(fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: '1',
          child: ListTile(
            leading: const Icon(
              Icons.edit,
              color: buttonColor,
            ),
            title: Text('Edit account',
              style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  void optionsDialog(){
    showMenu<String>(
      context: context,
      color: dialogColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      position: RelativeRect.fromLTRB(90.w, MediaQuery.of(context).size.height * 0.6, 60.h, 0.0),
      items: [
        PopupMenuItem<String>(
          value: '1',
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: buttonColor)
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: buttonColor,
                  ),
                ),
                title: Text('Pause account',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w300),
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: buttonColor)
                  ),
                  child: const Icon(
                    CupertinoIcons.refresh,
                    color: buttonColor,
                  ),
                ),
                title: Text('Rollover debit',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w300),
                ),
                trailing: const Switch(
                  onChanged: null,
                  value: true,
                  activeColor: customGreen,
                  activeTrackColor: customGreen,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.black,
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: buttonColor)
              ),
              child: const Icon(
                Icons.close_rounded,
                color: buttonColor,
              ),
            ),
            title: Text('Close account',
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
