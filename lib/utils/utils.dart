import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const buttonColor = Color(0xFFFF7955);
const textFieldColor = Color(0xFF565358);
const blackBackground = Color(0xFF1F1F1F);
const blackFaded = Color(0xFF303030);
const bottomAppBarColor = Color(0xFF1A1919);

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void showLoadingDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            image: const DecorationImage(
                image: AssetImage('assets/loadingDialog.gif'),
              fit: BoxFit.scaleDown
            )
          ),
        );
    });
}

void dismissDialog(BuildContext context){
  Navigator.pop(context);
}

void showErrorMessage(BuildContext context, String title, String message, VoidCallback buttonTapped) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.33, horizontal: 20.w),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.w600)
              ),
              SizedBox(height: 10.h),
              Text(message,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w400)
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)
                ),
                onPressed: () {
                 buttonTapped();
                },
                child: Text('Try again',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showCongratulationMessage(BuildContext context, String title, String message, String buttonLabel, VoidCallback buttonTapped) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.32, horizontal: 20.w),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.w600)
              ),
              SizedBox(height: 10.h),
              Text(message,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w400)
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)
                ),
                onPressed: () {
                  buttonTapped();
                },
                child: Text(buttonLabel,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}