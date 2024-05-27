import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class RegisterUserUssd extends StatefulWidget {
  const RegisterUserUssd({super.key});

  @override
  State<RegisterUserUssd> createState() => _RegisterUserUssdState();
}

class _RegisterUserUssdState extends State<RegisterUserUssd> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isChecked = false;
  bool enableButton = false;
  bool passwordVisible = true;

  String resourceId = '';

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      resourceId = (prefs.getString('resourceId') ?? '0');
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete your\nregistration',
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email address (Optional)',
                      suffixIcon: emailController.text.contains('@')
                          ? null
                          :  const Icon(
                        Icons.mail_outline,
                        color: buttonColor,
                      )
                  ),
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
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
                      enableButton = passwordController.text.length > 2;});
                  },
                  decoration: InputDecoration(
                      hintText: 'Password',
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
                      ) :
                      const Icon(Icons.lock, color: buttonColor)
                  ),
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                enableButton == false
                    ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        disabledBackgroundColor: textFieldColor
                    ),
                    onPressed: null,
                    child: Text('Finish',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
                )
                    : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)
                    ),
                    onPressed: () {
                      register();
                    },
                    child: Text('Finish',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async{
    showLoadingDialog(context);

    try {
      final response = await ApiService().createEmailAndPassword(emailController.text.trim(), passwordController.text.trim(), resourceId)
          .timeout(const Duration(seconds: 40));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if(response.statusCode == 200 && responseData['code'] == 200){
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
