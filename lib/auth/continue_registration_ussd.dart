import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/Utils.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                      hintText: 'Email address',
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
                      enableButton = emailController.text.contains('@') && passwordController.text.length > 5;});
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                enableButton == false
                    ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                        disabledBackgroundColor: textFieldColor
                    ),
                    onPressed: null,
                    child: Text('Finish',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
                  ),
                )
                    : Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50)
                    ),
                    onPressed: () {
                      if (!isChecked) {
                        showToastMessage('Please accept terms and conditions');
                      }
                      else{

                      }
                    },
                    child: Text('Finish',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
