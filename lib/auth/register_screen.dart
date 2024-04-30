import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:susubox/utils/utils.dart';
import 'package:telephony/telephony.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Telephony telephony = Telephony.instance;

  final key = GlobalKey<FormState>();
  final key1 = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();

  bool isResendEnabled = true;
  bool passwordVisible = true;
  bool pinVisible = true;
  bool isChecked = false;
  bool showFormOne = true;
  bool showFormTwo = false;
  bool showFormThree = false;
  bool showFormFour = false;
  bool enableFormOneButton = false;
  bool enableFormThreeButton = false;
  bool enableFormFourButton = false;

  int resendTime = 60;
  Timer? countdownTimer;
  String strFormatting(n) => n.toString().padLeft(2, '0');

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController pinConfirmController = TextEditingController();
  OtpFieldController otp = OtpFieldController();

  @override
  void initState() {
    super.initState();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address);
        print(message.body);

        String sms = message.body.toString();

        if (message.body!.contains('Your Susubox verification code is')) {
          String otpCode = sms.replaceAll(RegExp(r'[^0-9]'), '');
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
            showFormFour = false;
            showFormOne = true;
          } else if (showFormThree) {
            showFormTwo = true;
            showFormThree = false;
            showFormFour = false;
            showFormOne = false;
          } else if (showFormFour) {
            showFormTwo = false;
            showFormThree = true;
            showFormFour = false;
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
                  showFormFour = false;
                  showFormOne = true;
                } else if (showFormThree) {
                  showFormTwo = true;
                  showFormThree = false;
                  showFormFour = false;
                  showFormOne = false;
                } else if (showFormFour) {
                  showFormTwo = false;
                  showFormThree = true;
                  showFormFour = false;
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
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showFormOne)
                    formOne()
                  else if (showFormTwo)
                    formTwo()
                  else if (showFormThree)
                    formThree()
                  else
                    formFour()
                ],
              )),
        ),
      ),
    );
  }

  Widget formOne() {
    return Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phone Number',
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          SizedBox(height: 15.h),
          Text('Please enter your phone number to continue',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          PhoneFormField(
            initialValue: PhoneNumber.parse('+233'),
            countrySelectorNavigator: const CountrySelectorNavigator.page(),
            onChanged: (phoneNumber) {
              print('changed into $phoneNumber');
              phoneController.text = '+${phoneNumber.countryCode}${phoneNumber.nsn}';
              print('Phone number $phoneController');
              setState(() {
                enableFormOneButton = phoneController.text.length == 13;
              });
            },
            enabled: true,
            isCountrySelectionEnabled: false,
            isCountryButtonPersistent: true,
            countryButtonStyle: CountryButtonStyle(
              showDialCode: true,
              showIsoCode: false,
              showFlag: true,
              flagSize: 20.h,
              textStyle: TextStyle(
                  fontSize: 18.sp,
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
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 30.h),
          enableFormOneButton == false
              ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.71, 50),
                        disabledBackgroundColor: textFieldColor),
                    onPressed: null,
                    child: Text('Confirm your phone number',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50)),
                    onPressed: () {
                      if (key.currentState?.validate() ?? true) {
                        setState(() {
                          resendTime = 60;
                          startTimer();
                          showFormTwo = true;
                          showFormThree = false;
                          showFormFour = false;
                          showFormOne = false;
                        });
                      }
                    },
                    child: Text('Confirm your phone number',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ),
        ],
      ),
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
          'We sent a code to your number ',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+233 ${phoneController.text.substring(4, 13)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: (){
                enableFormOneButton = false;
                showFormTwo = false;
                showFormThree = false;
                showFormFour = false;
                showFormOne = true;
              },
              child: Text('Change',
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    decorationColor: buttonColor
                  )
              ),
            )
          ],
        ),
        SizedBox(height: 20.h),
        OTPTextField(
          outlineBorderRadius: 10,
          otpFieldStyle: OtpFieldStyle(
              borderColor: textFieldColor,
              backgroundColor: const Color(0xFF303030),
              focusBorderColor: const Color(0xFF303030)
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
          onCompleted: (pin) {
            pin = otp.toString();
            showFormTwo = false;
            showFormThree = true;
            showFormFour = false;
            showFormOne = false;
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
    return Form(
      key: key2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sign Up',
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          SizedBox(height: 15.h),
          Text('Complete your new account',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z-]'))
            ],
            controller: firstNameController,
            validator: (value) {
              if (value == '') {
                return 'First Name cannot be empty';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                enableFormThreeButton = firstNameController.text.length > 1 && lastNameController.text.length > 1 && passwordController.text.length > 5;
              });
            },
            decoration: InputDecoration(
              hintText: 'First Name',
              suffixIcon: firstNameController.text.length > 1
                  ? null
                  :  const Icon(
                Icons.person_outline_rounded,
                color: buttonColor,
              )
            ),
            style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z-]'))
            ],
            controller: lastNameController,
            validator: (value) {
              if (value == '') {
                return 'Last Name cannot be empty';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                enableFormThreeButton = firstNameController.text.length > 1 && lastNameController.text.length > 1 && passwordController.text.length > 5;
              });
            },
            decoration: InputDecoration(
              hintText: 'Last Name',
                suffixIcon: lastNameController.text.length > 1
                    ? null
                    :  const Icon(
                  Icons.person_outline_rounded,
                  color: buttonColor,
                )
            ),
            style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email address (optional)',
                suffixIcon: emailController.text.contains('@')
                    ? null
                    :  const Icon(
                  Icons.mail_outline,
                  color: buttonColor,
                )
            ),
            style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value == '') {
                return 'Password cannot be empty';
              } else {
                return null;
              }
            },
            obscureText: passwordVisible,
            onChanged: (value) {
              setState(() {
                enableFormThreeButton = firstNameController.text.length > 1 && lastNameController.text.length > 1 && passwordController.text.length > 5;
              });
            },
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: passwordController.text.length > 5
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
                  ) :
              const Icon(Icons.lock, color: buttonColor)
            ),
            style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                activeColor: buttonColor,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Text(
                'By checking the box you agree to our',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  ' Terms ',
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                'and',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                ' Conditions',
                style: TextStyle(
                    color: buttonColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          enableFormThreeButton == false
              ? Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.55, 50),
                  disabledBackgroundColor: textFieldColor
              ),
              onPressed: null,
              child: Text('Create Account',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
            ),
          )
              : Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.55, 50)
              ),
              onPressed: () {
                if (key2.currentState?.validate() ?? true) {
                  if (!isChecked) {
                    showToastMessage('Please accept terms and conditions');
                  } else {
                    setState(() {
                      showFormTwo = false;
                      showFormThree = false;
                      showFormFour = true;
                      showFormOne = false;
                    });
                  }
                }
              },
              child: Text('Create Account',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget formFour() {
    return Column(
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
                color: Colors.white)
        ),
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
              enableFormFourButton = pinController.text.length == 4 && pinConfirmController.text.length == 4;
            });
          },
          obscureText: pinVisible,
          obscuringCharacter: '●',
          decoration: InputDecoration(
              hintText: 'Enter Pin',
              suffixIcon: pinController.text.length == 4
                  ? IconButton(
                  icon: Icon(pinVisible ? Icons.visibility : Icons.visibility_off),
                  color: buttonColor,
                  onPressed: () {
                    setState(
                          () {
                        pinVisible = !pinVisible;
                      },
                    );
                  }
              ) : null
          ),
          style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
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
              enableFormFourButton = pinController.text.length == 4 && pinConfirmController.text.length == 4;
            });
          },
          obscureText: pinVisible,
          obscuringCharacter: '●',
          decoration: InputDecoration(
              hintText: 'Confirm Pin',
              suffixIcon: pinConfirmController.text.length == 4
                  ? IconButton(
                  icon: Icon(pinVisible ? Icons.visibility : Icons.visibility_off),
                  color: buttonColor,
                  onPressed: () {
                    setState(
                          () {
                        pinVisible = !pinVisible;
                      },
                    );
                  }
              ) : null
          ),
          style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w300),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 30.h),
        enableFormFourButton == false
            ? Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.45, 50),
                disabledBackgroundColor: textFieldColor
            ),
            onPressed: null,
            child: Text('Create Account',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
          ),
        )
            : Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.45, 50)
            ),
            onPressed: () {
              if (pinController.text == pinConfirmController.text) {
                  showToastMessage('Pin match');
              }
              else{
                showToastMessage('Pin does not match');
              }
            },
            child: Text('Create PIN',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
