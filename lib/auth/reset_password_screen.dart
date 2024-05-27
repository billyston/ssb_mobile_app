import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:telephony/telephony.dart';

import '../ApiService/api_service.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  Telephony telephony = Telephony.instance;

  bool passwordVisible = true;
  bool showFormOne = true;
  bool showFormTwo = false;
  bool showFormThree = false;
  bool enableFormOneButton = false;
  bool enableFormTwoButton = false;
  bool enableFormThreeButton = false;

  int resendTime = 60;
  Timer? countdownTimer;
  String strFormatting(n) => n.toString().padLeft(2, '0');

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  OtpFieldController otp = OtpFieldController();
  String otpCode = '';
  String resourceId = '';

  @override
  void initState() {
    super.initState();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address);
        print(message.body);

        String sms = message.body.toString();

        if (message.body!.contains('Your password reset verification token is:')) {
          String otpCode = sms.replaceAll(RegExp(r'\D'), '');
          otp.set(otpCode.split(""));

          setState(() {});
        } else {
          print("error");
        }
      },
      listenInBackground: false,
    );
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTime = resendTime - 1;
      });
      if (resendTime < 1) {
        countdownTimer!.cancel();
      }
    });
  }

  stopTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        setState(() {
          if (showFormTwo) {
            enableFormOneButton = false;
            showFormTwo = false;
            showFormThree = false;
            showFormOne = true;
          } else if (showFormThree) {
            showFormTwo = true;
            showFormThree = false;
            showFormOne = false;
          } else {
            Navigator.pop(context);
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (showFormTwo) {
                  stopTimer();
                  enableFormOneButton = false;
                  showFormTwo = false;
                  showFormThree = false;
                  showFormOne = true;
                } else if (showFormThree) {
                  showFormTwo = true;
                  showFormThree = false;
                  showFormOne = false;
                } else {
                  Navigator.pop(context);
                }
              });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showFormOne)
                    formOne()
                  else if (showFormTwo)
                    formTwo()
                  else
                    formThree()
                ],
              )),
        ),
      ),
    );
  }

  Widget formOne() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reset Password',
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          SizedBox(height: 15.h),
          Text('We will send you a code to reset your password.',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          PhoneFormField(
            initialValue: PhoneNumber.parse('+233'),
            countrySelectorNavigator: const CountrySelectorNavigator.page(),
            onChanged: (phoneNumber) {
              phoneController.text = '+${phoneNumber.countryCode}${phoneNumber.nsn}';
              setState(() {
                enableFormOneButton = phoneController.text.length == 13;
              });
            },
            enabled: true,
            isCountrySelectionEnabled: false,
            isCountryButtonPersistent: true,
            countryButtonStyle: CountryButtonStyle(
              showDropdownIcon: false,
              showDialCode: true,
              showIsoCode: false,
              showFlag: true,
              flagSize: 20.h,
              textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            decoration: const InputDecoration(
              hintText: 'Phone Number',
            ),
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(11),
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ],
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 30.h),
          enableFormOneButton == false
              ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0),
                  disabledBackgroundColor: textFieldColor),
              onPressed: null,
              child: Text('Confirm your phone number',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey)),
            )
              : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50.0)),
              onPressed: () {
                 verifyPhoneNumber();
              },
              child: Text('Confirm your phone number',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
            ),
        ],
    );
  }

  Widget formTwo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Enter Code',
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Text(
          'Please enter the code we sent to\nyour number +233 ${phoneController.text.substring(4, 13)}',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 20.h),
        OTPTextField(
          outlineBorderRadius: 10,
          otpFieldStyle: OtpFieldStyle(
              borderColor: textFieldColor,
              backgroundColor: blackFaded,
              focusBorderColor: blackFaded
          ),
          controller: otp,
          length: 6,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 50,
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
          textFieldAlignment: MainAxisAlignment.center,
          spaceBetween: 10,
          fieldStyle: FieldStyle.box,
          keyboardType: TextInputType.number,
          onChanged: (val){

          },
          onCompleted: (pin) {
            otpCode = pin;
            verifyOTP();
          },
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Send code again',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400)
            ),
            const SizedBox(width: 5),
            Text(
              '00:${strFormatting(resendTime)}',
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        resendTime == 0
            ? TextButton(
          onPressed: () {
            resendTime = 60;
            startTimer();
          },
          child: Text(
            'Resend',
            style: TextStyle(
                fontSize: 14.sp,
                color: buttonColor,
                fontWeight: FontWeight.w400),
          ),
        )
            : Text(
          'Resend',
          style: TextStyle(
              height: 3,
              fontSize: 14.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget formThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create a new\npassword',
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        TextFormField(
          controller: passwordController,
          onChanged: (value) {
            setState(() {
              enableFormThreeButton = passwordController.text.length > 2 && confirmPasswordController.text.length > 2;
            });
          },
          obscureText: passwordVisible,
          decoration: InputDecoration(
              hintText: 'Enter password',
              suffixIcon: passwordController.text.length > 2
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
              ) : null
          ),
          style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w300),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 20.h),
        TextFormField(
          controller: confirmPasswordController,
          onChanged: (value) {
            setState(() {
              enableFormThreeButton = passwordController.text.length > 2 && confirmPasswordController.text.length > 2;
            });
          },
          obscureText: passwordVisible,
          decoration: InputDecoration(
              hintText: 'Confirm Password',
              suffixIcon: confirmPasswordController.text.length > 2
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
              ) : null
          ),
          style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 40.h),
        enableFormThreeButton == false
            ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50.0),
                disabledBackgroundColor: textFieldColor
            ),
            onPressed: null,
            child: Text('Reset Password',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
          )
            : ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50.0),
            ),
            onPressed: () {
              if (passwordController.text == confirmPasswordController.text) {
                  createPassword();
              }
              else{
                showErrorMessage(context, 'Password Mismatch', 'The passwords you entered do not match. Please double-check the password you entered and try again.',
                        () {
                      Navigator.pop(context);
                    });
              }
            },
            child: Text('Reset Password',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
          ),
      ],
    );
  }

  void verifyPhoneNumber() async{
    showLoadingDialog(context);

    try {
      final response = await ApiService().verifyNumberPasswordReset(phoneController.text.replaceFirst('+233', '0'))
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if((response.statusCode == 200 && responseData['code'] == 202)){
          resourceId = responseData['data']['attributes']['resource_id'];
          setState(() {
            resendTime = 60;
            startTimer();
            showFormTwo = true;
            showFormThree = false;
            showFormOne = false;
          });
          dismissDialog(context);
        }
        else if((response.statusCode == 200 && responseData['code'] == 422)){
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'We couldn\'t find an account associated with the phone number you entered. Please check the number and try again.',
                  () {
                Navigator.pop(context);
              });
        }
        else{
          showToastMessage('Please try again');
          dismissDialog(context);
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

  void verifyOTP() async{
    showLoadingDialog(context);
    try {
      final response = await ApiService().verifyOTPPasswordReset(otpCode, resourceId)
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if(response.statusCode == 200 && responseData['code'] == 200){
          setState(() {
            showFormTwo = false;
            showFormThree = true;
            showFormOne = false;
          });
          dismissDialog(context);
        }
        else {
          showToastMessage(responseData['errors'].toString());
          dismissDialog(context);
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

  void createPassword() async{
    showLoadingDialog(context);
    try {
      final response = await ApiService().resetPassword(passwordController.text.trim(),
          confirmPasswordController.text.trim() , resourceId)
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if(response.statusCode == 200 && responseData['code'] == 200){
          showCongratulationMessage(context, 'Password Reset',
              'Your password has been successfully reset. You can now log in to your account using your new password.',
              'Login', () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false
                );
              });
        }
        else {
          dismissDialog(context);
          showErrorMessage(context, 'Oops', responseData['errors'].toString(),
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
