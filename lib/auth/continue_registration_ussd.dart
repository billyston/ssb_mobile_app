import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'login.dart';

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
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w300),
                ),
               /* SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                ), */
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
                      showCongratulationMessage(context, 'Congratulations!',
                          'Welcome! You have successfully subscribed to SusuBox. Enjoy the full convenience and safety of your susu savings, loans, investment, insurance and pensions.',
                          'Login', () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false
                            );
                          });
                     // if (!isChecked) {
                       // showToastMessage('Please accept terms and conditions');
                     // }
                     // else{

                     // }
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
}
