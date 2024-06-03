import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../ApiService/api_service.dart';
import '../../utils/utils.dart';

class PinDialog extends StatefulWidget {
  final Function(String) approveRequest;
  final String resourceId;
  const PinDialog({required this.approveRequest, required this.resourceId, super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {

  bool passwordVisible = true;
  bool enableButton = false;

  TextEditingController pinController = TextEditingController();
  String token = '';

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: SingleChildScrollView(
        child: AlertDialog(
            backgroundColor: blackFaded,
            insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.3),
            contentPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Text( 'ENTER PIN',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Form(
                  child: Column(
                    children: [
                      Text('This action requires pin approval. Enter your Susubox PIN to proceed',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.grey)
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                        ],
                        controller: pinController,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter your pin';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            enableButton = pinController.text.length == 4;
                          });
                        },
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            hintText: 'Enter Susubox pin',
                            hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                            suffixIcon: pinController.text.length > 1
                                ? IconButton(
                                icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                                color: buttonColor,
                                onPressed: () {
                                  setState(
                                        () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                }
                            ) : const Icon(Icons.lock, color: buttonColor)
                        ),
                        style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      enableButton == false
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            disabledBackgroundColor: textFieldColor
                        ),
                        onPressed: null,
                        child: Text('Continue',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                      ) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          viewBalance();
                        },
                        child: Text('Continue',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  )
              ),
            )
        ),
      ),
    );
  }

  void viewBalance() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().getBalance(widget.resourceId,
          pinController.text, token)
          .timeout(const Duration(seconds: 60));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          String currentBalance = '${responseData['data']['included']['currency']['attributes']['currency']} ${responseData['data']['attributes']['current_balance']}';
          dismissDialog(context);
          widget.approveRequest(currentBalance);
          dismissDialog(context);
        }
        else if(response.statusCode == 200 && responseData['code'] == 422){
          dismissDialog(context);
          showErrorMessage(context, 'Oops', responseData['errors'].toString(),
                  () {
                Navigator.pop(context);
              });
        }
        else{
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'Something went wrong',
                  () {
                Navigator.pop(context);
              });
        }
      }
    } catch (e) {
      if(mounted){
        print('Connection Error $e');
        dismissDialog(context);
        showErrorMessage(context, 'Oops', 'An unexpected error occurred',
                () {
              Navigator.pop(context);
            });
      }
    }
  }
}

