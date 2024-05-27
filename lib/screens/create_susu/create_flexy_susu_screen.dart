import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/components/loading_dialog.dart';

import '../../ApiService/api_service.dart';
import '../../components/error_container.dart';
import '../../components/link_account_dialog.dart';
import '../../model/linked_accounts.dart';
import '../../utils/utils.dart';

class CreateFlexySusuScreen extends StatefulWidget {
  const CreateFlexySusuScreen({super.key});

  @override
  State<CreateFlexySusuScreen> createState() => _CreateFlexySusuScreenState();
}

class _CreateFlexySusuScreenState extends State<CreateFlexySusuScreen> {
  bool enableFormOneButton = false;
  bool enableFormTwoButton = false;
  bool isChecked = false;
  bool isTermsChecked = false;
  bool showPinForm = false;
  bool passwordVisible = true;
  bool dataLoaded = false;
  bool errorOccurred = false;

  TextEditingController accountNameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController linkedAccountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  String token = '';
  String selectedAccountResourceId = '';

  LinkedAccounts? accountsModel;
  List<Map<String, String>> linkedAccounts = [];

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    getLinkedAccounts();
  }

  Future<LinkedAccounts?> getLinkedAccounts() async{
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      accountsModel = await ApiService().getLinkedAccounts(token).timeout(const Duration(seconds: 60));
      linkedAccounts = accountsModel!.data.map((datum){
        return {
          'account_number': datum.attributes.accountNumber,
          'resourceId': datum.attributes.resourceId,
        };
      }).toList();
      if(linkedAccounts.isEmpty){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLinkAccountDialog();
        });
      }
      setState(() {
        dataLoaded = true;
      });
    }
    catch(e){
      print('Error happened $e');
      setState(() {
        errorOccurred = true;
      });
    }
    return null;
  }

  void showLinkAccountDialog(){
    showDialog(
      context: context,
      builder: (context) => const LinkAccountDialog(),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (showPinForm) {
          setState(() {
            showPinForm = false;
          });
        }
        else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                if (showPinForm) {
                  setState(() {
                    showPinForm = false;
                  });
                }
                else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: errorOccurred ? ErrorContainer(refreshPage: getLinkedAccounts)
              : dataLoaded
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Flexy',
                    style: TextStyle(fontSize: 32.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.0),
                  ),
                  Text('Susu',
                    style: TextStyle(fontSize: 32.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04),
                  if(showPinForm)
                    pinForm()
                  else
                    detailsForm()
                ],
              ),
            ),
          ) : const LoadingDialog()
      ),
    );
  }

  Widget detailsForm() {
    return Column(
      children: [
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: TextStyle(fontSize: 15.sp,
              color: Colors.white,
              fontWeight: FontWeight.w300),
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.04),
        TextFormField(
          controller: accountNameController,
          validator: (value) {
            if (value == '') {
              return 'Account Name cannot be empty';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              checkValidity();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Business or Account Name',
          ),
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 15.h),
        TextFormField(
          controller: purposeController,
          validator: (value) {
            if (value == '') {
              return 'Purpose cannot be empty';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              checkValidity();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Purpose',
          ),
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 15.h),
        TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
          ],
          controller: amountController,
          validator: (value) {
            if (value == '') {
              return 'Amount cannot be empty';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              checkValidity();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Susu amount',
          ),
          style: TextStyle(fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w300),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 15.h),
        DropdownButtonFormField<String>(
          dropdownColor: blackFaded,
          validator: (value) =>
          value == null ? 'Please select debit frequency' : null,
          iconEnabledColor: Colors.grey,
          isExpanded: true,
          value: frequencyController.text.isEmpty
              ? null
              : frequencyController.text,
          items: <String>['Daily','Weekly','Monthly']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
              hintText: 'Select debit frequency',
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10.0)
          ),
          onChanged: (String? value) {
            setState(() {
              frequencyController.text = value!;
              checkValidity();
            });
          },
        ),
        SizedBox(height: 15.h),
        DropdownButtonFormField<String>(
          dropdownColor: blackFaded,
          validator: (value) =>
          value == null ? 'Please select linked account' : null,
          iconEnabledColor: Colors.grey,
          isExpanded: true,
          value: linkedAccountController.text.isEmpty
              ? null
              : linkedAccountController.text,
          items: linkedAccounts.map<DropdownMenuItem<String>>((accounts) {
            return DropdownMenuItem<String>(
              value: accounts['account_number'],
              child: Text(
                accounts['account_number']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
              hintText: 'Select Linked Account',
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10.0)
          ),
          onChanged: (String? value) {
            setState(() {
              linkedAccountController.text = value!;
              checkValidity();

              final selectedAccount = linkedAccounts.firstWhere((network) => network['account_number'] == value);
              selectedAccountResourceId = selectedAccount['resourceId']!;
            });
          },
        ),
        SizedBox(height: 10.h),
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
              'Rollover unsuccessful debits,',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                ' What is this? ',
                style: TextStyle(
                    color: buttonColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: isTermsChecked,
              activeColor: buttonColor,
              onChanged: (bool? value) {
                setState(() {
                  isTermsChecked = value!;
                });
              },
            ),
            Text(
              'By checking the box you agree to our',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                ' Terms ',
                style: TextStyle(
                    color: buttonColor,
                    fontSize: 11.sp,
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
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.04),
        enableFormOneButton == false
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50.0),
              disabledBackgroundColor: textFieldColor
          ),
          onPressed: null,
          child: Text('Create Account',
              style: TextStyle(fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey)),
        ) : ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50.0),
          ),
          onPressed: () {
            if (!isChecked) {
              showToastMessage('Please accept terms and conditions');
            } else if (!isTermsChecked) {
              showToastMessage('Please accept terms and conditions');
            } else {
              setState(() {
                showPinForm = true;
              });
            }
          },
          child: Text('Create Account',
              style: TextStyle(fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
        ),
      ],
    );
  }

  Widget pinForm() {
    return Column(
      children: [
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.01),
        Text(
            'This action requires pin approval. Enter your Susubox PIN to approve',
            style: TextStyle(fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey)
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.04),
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
              enableFormTwoButton = pinController.text.length == 4;
            });
          },
          obscureText: passwordVisible,
          decoration: InputDecoration(
              hintText: 'Enter Susubox pin',
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              suffixIcon: pinController.text.length > 1
                  ? IconButton(
                  icon: Icon(passwordVisible ? Icons.visibility : Icons
                      .visibility_off),
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
          style: TextStyle(fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w300),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.05),
        enableFormTwoButton == false
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              disabledBackgroundColor: textFieldColor
          ),
          onPressed: null,
          child: Text('Approve',
              style: TextStyle(fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
        ) : ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () {
            showCongratulationMessage(context, 'Congratulations',
                'Your biz susu has been created. You will be debited GHS5.00 daily. We advise you always maintain such balance in your ${linkedAccountController
                    .text} mobile money wallet for successful debit.',
                'Ok', () {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                });
          },
          child: Text('Approve',
              style: TextStyle(fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  void checkValidity(){
    enableFormOneButton = accountNameController.text.length > 1 &&
        amountController.text.isNotEmpty &&
        linkedAccountController.text.isNotEmpty &&
        purposeController.text.length > 1 &&
        frequencyController.text.isNotEmpty;
  }

}
