import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorContainer extends StatefulWidget {

  final VoidCallback refreshPage;

  const ErrorContainer({required this.refreshPage, super.key});

  @override
  State<ErrorContainer> createState() => _ErrorContainerState();
}

class _ErrorContainerState extends State<ErrorContainer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 100.h,
            color: Colors.white,
          ),
          SizedBox(height: 10.h),
          Text('Something went wrong!',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
              onPressed: (){
                widget.refreshPage();
              },
              child: Text('Retry',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
              )
          )
        ],
      ),
    );
  }
}
