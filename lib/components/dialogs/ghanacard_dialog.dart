import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class GhanaCardDialog extends StatefulWidget {
  const GhanaCardDialog({super.key});

  @override
  State<GhanaCardDialog> createState() => _GhanaCardDialogState();
}

class _GhanaCardDialogState extends State<GhanaCardDialog> {
  final key = GlobalKey<FormState>();
  bool isEditing = false;
  bool enableButton = false;
  bool enableButton2 = false;
  bool showPinForm = false;
  bool showErrorDialog = true;
  bool passwordVisible = true;

  TextEditingController pinController = TextEditingController();
  TextEditingController ghanaCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showErrorDialog) {
        showOptionsDialog(context, 'Oops', 'You have not linked your Ghana Card to your Susubox account.', 'Link Ghana Card', 'Not now', () {
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
              Text( 'LINK GHANA CARD',
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
          content: showPinForm ? pinForm() : editContent()
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                  enableButton = ghanaCardNumberController.text.length > 10;
                });
              },
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            enableButton == false
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  disabledBackgroundColor: textFieldColor
              ),
              onPressed: null,
              child: Text('Verify',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ) : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                setState(() {
                  showPinForm = true;
                });
              },
              child: Text('Verify',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget pinForm(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Form(
          child: Column(
            children: [
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
                    enableButton2 = pinController.text.length == 4;
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
              enableButton2 == false
                  ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    disabledBackgroundColor: textFieldColor
                ),
                onPressed: null,
                child: Text('Approve',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ) : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  showCongratulationMessage(context, 'Congratulations', 'Link Ghana Card request is accepted. You will receive a notification to confirm status',
                      'Ok', () {
                        int count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                      });
                },
                child: Text('Approve',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
              SizedBox(height: 10.h),
            ],
          )
      ),
    );
  }
}

