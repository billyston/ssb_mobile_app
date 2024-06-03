import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const buttonColor = Color(0xFFFF7955);
const customGreen = Color(0xFF57BF9C);
const customBrown = Color(0xFFECB265);
const customPurple = Color(0xFFC09FF8);
const textFieldColor = Color(0xFF565358);
const blackBackground = Color(0xFF1F1F1F);
const blackFaded = Color(0xFF303030);
const dialogColor = Color(0xFF575656);
const bottomAppBarColor = Color(0xFF1A1919);

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
  );
}

void showLoadingDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150.h,
              width: 150.w,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage('assets/loadingDialog.gif'),
                  fit: BoxFit.cover
                )
              ),
            ),
          ],
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
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1, horizontal: 20.w),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

void showOptionsDialog(BuildContext context, String title, String message, String button1, String button2, VoidCallback button1Tapped, VoidCallback button2Tapped) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1, horizontal: 20.w),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              Text(
                message,
                style: TextStyle(fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: button1Tapped,
                child: Text(
                  button1,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: button2Tapped,
                child: Text(
                  button2,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: buttonColor),
                ),
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
        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1, horizontal: 20.w),
        backgroundColor: blackFaded,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

void showSusuSchemeDetails(BuildContext context, String title, String content){
  showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.7),
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
            heightFactor: 0.8,
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
             Text(title,
               style: TextStyle(color: Colors.white, fontSize: 40.sp, fontWeight: FontWeight.w700, height: 1),
             ),
              SizedBox(height: 15.h),
              Text('About Scheme',
                style: TextStyle(color: buttonColor, fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1),
              ),
              SizedBox(height: 15.h),
              Text(content,
                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500, height: 1),
              ),
              SizedBox(height: 15.h),
              Text('Key Features',
                    style: TextStyle(color: buttonColor, fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Terms and Conditions',
                      style: TextStyle(color: buttonColor, fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF79552B),
                              border: Border.all(color: buttonColor)
                          ),
                          child: const Icon(
                            Icons.add,
                            color: buttonColor,
                          ),
                        ),
                      ),
                      Text('Add account',
                        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
            )
        );
      });
}
