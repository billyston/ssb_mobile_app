import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class CreateSusuBoxPin extends StatefulWidget {
  const CreateSusuBoxPin({super.key});

  @override
  State<CreateSusuBoxPin> createState() => _CreateSusuBoxPinState();
}

class _CreateSusuBoxPinState extends State<CreateSusuBoxPin> {
  String resourceId = '';

  bool enableFormFourButton = false;
  bool pinVisible = true;

  final TextEditingController pinController = TextEditingController();
  final TextEditingController pinConfirmController = TextEditingController();

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    resourceId = (prefs.getString('resourceId') ?? '0');
  }

  @override
  void initState() {
    getData();
    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create SusuBox PIN',
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              SizedBox(height: 15.h),
              Text('The PIN will enable you authorize transactions.',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                controller: pinController,
                validator: (value) {
                  if (value == '') {
                    return 'Pin cannot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    enableFormFourButton = pinController.text.length == 4 &&
                        pinConfirmController.text.length == 4;
                  });
                },
                obscureText: pinVisible,
                obscuringCharacter: '●',
                decoration: InputDecoration(
                    hintText: 'Enter Pin',
                    suffixIcon: pinController.text.length == 4
                        ? IconButton(
                            icon: Icon(pinVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: buttonColor,
                            onPressed: () {
                              setState(
                                () {
                                  pinVisible = !pinVisible;
                                },
                              );
                            })
                        : null),
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                controller: pinConfirmController,
                validator: (value) {
                  if (value == '') {
                    return 'Pin cannot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    enableFormFourButton = pinController.text.length == 4 &&
                        pinConfirmController.text.length == 4;
                  });
                },
                obscureText: pinVisible,
                obscuringCharacter: '\u{25CF}',
                decoration: InputDecoration(
                    hintText: 'Confirm Pin',
                    suffixIcon: pinConfirmController.text.length == 4
                        ? IconButton(
                            icon: Icon(pinVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: buttonColor,
                            onPressed: () {
                              setState(
                                () {
                                  pinVisible = !pinVisible;
                                },
                              );
                            })
                        : null),
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30.h),
              enableFormFourButton == false
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50.0),
                          disabledBackgroundColor: textFieldColor),
                      onPressed: null,
                      child: Text('Create PIN',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50.0)),
                      onPressed: () {
                        if (pinController.text == pinConfirmController.text) {
                           createPin();
                        } else {
                          showErrorMessage(context, 'Pin Mismatch',
                              'The PIN you entered do not match. Please double-check the PIN you entered and try again.',
                              () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text('Create PIN',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void createPin() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().createPin(
          pinController.text.trim(),
          pinConfirmController.text.trim(),
          resourceId)
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      print('Resource Id $resourceId');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          dismissDialog(context);
          showCongratulationMessage(context, 'Congratulations!',
              'Welcome! You have successfully subscribed to SusuBox. Enjoy the full convenience and safety of your susu savings, loans, investment, insurance and pensions.',
              'Login', () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false
                );
              });
        }
        else {
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'Unable to create pin at this moment, Please try again.',
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
