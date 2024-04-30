import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:susubox/dashboard/home_screen.dart';
import 'package:susubox/utils/utils.dart';

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
                /*TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                  ],
                  controller: phoneController,
                  validator: (value) {
                    if (value == null) {
                      return 'Phone Number cannot be empty';
                    } else if (value.length != 10) {
                      return 'Phone Number is invalid';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      enableButton = phoneController.text.length == 10 && passwordController.text.length > 5;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w300),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),*/
                PhoneFormField(
                  initialValue: PhoneNumber.parse('+233'),
                  countrySelectorNavigator: const CountrySelectorNavigator.page(),
                  onChanged: (phoneNumber) {
                    print('changed into $phoneNumber');
                    phoneController.text = '+${phoneNumber.countryCode}${phoneNumber.nsn}';
                    print('Phone number $phoneController');
                  },
                  enabled: true,
                  isCountrySelectionEnabled: false,
                  isCountryButtonPersistent: true,
                  countryButtonStyle: CountryButtonStyle(
                    showDialCode: true,
                    showIsoCode: false,
                    showFlag: true,
                    flagSize: 18.h,
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey)
                  ),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                  ],
                  style: TextStyle(
                      fontSize: 18.sp,
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
                      enableButton = phoneController.text.length == 13 && passwordController.text.length > 5;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: passwordController.text.length > 5
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
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text('Forgot password?',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: buttonColor)))
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                enableButton == false
                ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                      disabledBackgroundColor: textFieldColor
                    ),
                    onPressed: null,
                    child: Text('Login',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
                  ),
                )
                : Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50)
                    ),
                    onPressed: () {
                       if (key.currentState?.validate() ?? true) {
                         Route route = MaterialPageRoute(builder: (c) => const HomeScreen());
                         Navigator.push(context, route);
                       }
                    },
                    child: Text('Login',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
