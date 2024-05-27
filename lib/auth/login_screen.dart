import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/auth/continue_registration_ussd.dart';
import 'package:susubox/auth/create_susu_pin.dart';
import 'package:susubox/auth/register_screen.dart';
import 'package:susubox/auth/reset_password_screen.dart';
import 'package:susubox/dashboard/dashboard_screen.dart';
import 'package:susubox/dashboard/home_screen.dart';
import 'package:susubox/utils/utils.dart';

import '../ApiService/api_service.dart';
import '../model/linked_accounts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final key = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  bool enableButton = false;

  LinkedAccounts? linkedAccounts;

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
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Log In',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w500, color: Colors.white)
                ),
                Text('Please enter your phone number and password',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Colors.white)
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                PhoneFormField(
                  initialValue: PhoneNumber.parse('+233'),
                  countrySelectorNavigator: const CountrySelectorNavigator.page(),
                  onChanged: (phoneNumber) {
                    phoneController.text = '+${phoneNumber.countryCode}${phoneNumber.nsn}';
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
                    textInputAction: TextInputAction.next
                ),
                SizedBox(height: 30.h),
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
                      enableButton = phoneController.text.length == 13 && passwordController.text.length > 2;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: passwordController.text.length > 2
                        ? IconButton(
                      icon: Icon(
                        passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )
                        : null,
                  ),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                          );
                        },
                        child: Text('Forgot password?',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: buttonColor)))
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                enableButton == false
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                        minimumSize: const Size.fromHeight(50.0),
                      disabledBackgroundColor: textFieldColor
                    ),
                    onPressed: null,
                    child: Text('Login',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
                )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0),
                        //fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50)
                    ),
                    onPressed: () {
                       if (key.currentState?.validate() ?? true) {
                          login();
                       }
                    },
                    child: Text('Login',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                  ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().customerLogin(
          phoneController.text.replaceFirst('+233', '0'),
          passwordController.text.trim())
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          dismissDialog(context);
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', responseData['token']['access_token']);
          prefs.setString('resourceId', responseData['data']['attributes']['resource_id']);
          prefs.setString('firstName', responseData['data']['attributes']['first_name']);
          prefs.setString('lastName', responseData['data']['attributes']['last_name']);
        }
        else if (response.statusCode == 200 && responseData['code'] == 401) {
          dismissDialog(context);
          showOptionsDialog(context, 'Oops', 'The phone number or password you entered is incorrect. Please try again.',
              'Forgot Password', 'Try again',
                  () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                );
              }, () {
                Navigator.pop(context);
              });
        }
        else if(response.statusCode == 200 && responseData['code'] == 422) {
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'The phone number you entered is not registered with us, Please enter a phone number registered with us.',
                  () {
                Navigator.pop(context);
              });
        }
        else if(response.statusCode == 200 && responseData['code'] == 206 && responseData['data']['attributes']['pin_setup'] == false){
          dismissDialog(context);
          showCongratulationMessage(context, 'Incomplete Registration', 'You have not created your Susubox pin.',
              'Complete Registration',
                  () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateSusuBoxPin()),
                );
              });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('resourceId', responseData['data']['attributes']['resource_id']);
        }
        else if(response.statusCode == 200 && responseData['code'] == 206){
          dismissDialog(context);
          showCongratulationMessage(context, 'Incomplete Registration', 'You have not created an email/password for this account.',
                  'Complete Registration',
                  () {
                    Navigator.pop(context);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegisterUserUssd()),
                    );
              });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('resourceId', responseData['data']['attributes']['resource_id']);
        }
        else{
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

}
