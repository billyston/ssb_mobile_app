import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:susubox/utils/utils.dart';

class PersonalInfoDialog extends StatefulWidget {
  const PersonalInfoDialog({super.key});

  @override
  State<PersonalInfoDialog> createState() => _PersonalInfoDialogState();
}

class _PersonalInfoDialogState extends State<PersonalInfoDialog> {

  final key = GlobalKey<FormState>();
  bool isEditing = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: blackFaded,
          insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.2),
          contentPadding: EdgeInsets.zero,
          title: Column(
            children: [
              Text(isEditing ? 'UPDATE PERSONAL INFORMATION' : 'PERSONAL INFORMATION',
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
          content: isEditing ? editContent() : viewContent()
        ),
    );
  }

  Widget viewContent(){
   return Container(
     width: MediaQuery.of(context).size.width * 0.85,
     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(height: 10.h),
         Row(
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('First Name',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('Michael',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             ),
             SizedBox(width: MediaQuery.of(context).size.width * 0.05),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Last Name',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('Katey',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             )
           ],
         ),
         SizedBox(height: 20.h),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Middle Name',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('N/A',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             ),
             SizedBox(width: MediaQuery.of(context).size.width * 0.05),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Date of Birth',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('N/A',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             )
           ],
         ),
         SizedBox(height: 20.h),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Date Registered',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('25/04/2024',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             ),
             SizedBox(width: MediaQuery.of(context).size.width * 0.05),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Status',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('Active',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             )
           ],
         ),
         SizedBox(height: 20.h),
         Text('Contacts',
           style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
         ),
         SizedBox(height: 5.h),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Phone Number',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('+233241784159',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             ),
             SizedBox(width: MediaQuery.of(context).size.width * 0.05),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Email',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                   Text('billyston@gmail.com',
                     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
                   ),
                 ],
               ),
             )
           ],
         ),
         SizedBox(height: MediaQuery.of(context).size.height * 0.1),
         ElevatedButton(
           style: ElevatedButton.styleFrom(
               minimumSize: const Size.fromHeight(50),
               backgroundColor: textFieldColor
           ),
           onPressed: () {
              setState(() {
                isEditing = true;
              });
           },
           child: Text('Update',
               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
         ),
         SizedBox(height: 15.h),
       ],
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
              decoration: InputDecoration(
                  hintText: 'First Name',
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)
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
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)
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
              decoration: InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: dateOfBirthController,
              validator: (value) {
                if (value == '') {
                  return 'Date of Birth cannot be empty';
                } else {
                  return null;
                }
              },
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1960),
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    dateOfBirthController.text = formattedDate;
                  });
                } else {

                }
              },
              decoration: InputDecoration(
                  hintText: 'Date of Birth',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey)
              ),
              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                if(key.currentState?.validate() ?? true){
                    showCongratulationMessage(context, 'Congratulations', 'Your personal information has been updated successfully',
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
