import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const buttonColor = Color(0xFFFF7955);
const textFieldColor = Color(0xFF565358);
const blackBackground = Color(0xFF1F1F1F);
const blackFaded = Color(0xFF303030);

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

void showMessageDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.32),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text('Congratulations !',
                  style:
                  TextStyle(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.w600)),
              SizedBox(height: 10.h),
              Text(message,
                  style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w400)
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Done',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}