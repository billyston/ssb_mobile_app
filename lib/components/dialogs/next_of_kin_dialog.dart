import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';

class NextOfKinDialog extends StatefulWidget {
  const NextOfKinDialog({super.key});

  @override
  State<NextOfKinDialog> createState() => _NextOfKinDialogState();
}

class _NextOfKinDialogState extends State<NextOfKinDialog> {
  final key = GlobalKey<FormState>();
  bool isEditing = false;
  bool enableButton = false;
  bool showErrorDialog = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ghanaCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showErrorDialog) {
        showOptionsDialog(context, 'Oops', 'You have not added any Next of Kin to your account.', 'Add Next of Kin', 'Not now', () {
          setState(() {
            showErrorDialog = false;
          });
          Navigator.pop(context);
        }, () {
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showErrorDialog ? Container() : SingleChildScrollView(
        child: AlertDialog(
            backgroundColor: blackFaded,
            insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.2),
            contentPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Text( 'ADD NEXT OF KIN',
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
            content:  editContent()
      ),
    );
  }

  Widget editContent(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Form(
        key: key,
        child: Column(
          children: [
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
                  enableButton = firstNameController.text.length > 1 &&
                      lastNameController.text.length > 1 &&
                      phoneNumberController.text.length == 10 &&
                      ghanaCardNumberController.text.length > 1;
                });
              },
              decoration: InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: firstNameController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.person_outline_rounded,
                    color: buttonColor,
                  )
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z-]'))
              ],
              controller: middleNameController,
              decoration: InputDecoration(
                  hintText: 'Middle Name(Optional)',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: middleNameController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.person_outline_rounded,
                    color: buttonColor,
                  )
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
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
                  enableButton = firstNameController.text.length > 1 &&
                      lastNameController.text.length > 1 &&
                      phoneNumberController.text.length == 10 &&
                      ghanaCardNumberController.text.length > 1;
                });
              },
              decoration: InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: lastNameController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.person_outline_rounded,
                    color: buttonColor,
                  )
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
              ],
              controller: phoneNumberController,
              validator: (value) {
                if (value == '') {
                  return 'Phone number cannot be empty';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(() {
                  enableButton = firstNameController.text.length > 1 &&
                      lastNameController.text.length > 1 &&
                      phoneNumberController.text.length == 10 &&
                      ghanaCardNumberController.text.length > 1;
                });
              },
              decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: phoneNumberController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.phone,
                    color: buttonColor,
                  )
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email address (Optional)',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: emailController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.mail,
                    color: buttonColor,
                  )
              ),
              onChanged: (value) {
                setState(() {
                  enableButton = firstNameController.text.length > 1 &&
                      lastNameController.text.length > 1 &&
                      phoneNumberController.text.length == 10 &&
                      ghanaCardNumberController.text.length > 1;
                });
              },
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: ghanaCardNumberController,
              decoration: InputDecoration(
                  hintText: 'Ghana card number',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  suffixIcon: ghanaCardNumberController.text.length > 1
                      ? null
                      :  const Icon(
                    Icons.credit_card_rounded,
                    color: buttonColor,
                  )
              ),
              onChanged: (value) {
                setState(() {
                  enableButton = firstNameController.text.length > 1 &&
                      lastNameController.text.length > 1 &&
                      phoneNumberController.text.length == 10 &&
                      ghanaCardNumberController.text.length > 1;
                });
              },
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            enableButton == false
            ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                disabledBackgroundColor: textFieldColor
              ),
              onPressed: null,
              child: Text('Add',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ) : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                if(key.currentState?.validate() ?? true){
                  showCongratulationMessage(context, 'Congratulations', 'Your next of kin has been added to your Susubox account successfully',
                      'Ok', () {
                        int count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                      });
                }
              },
              child: Text('Add',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
