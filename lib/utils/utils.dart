import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const buttonColor = Color(0xFFFF7955);
const textFieldColor = Color(0xFF565358);
const blackBackground = Color(0xFF1F1F1F);

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