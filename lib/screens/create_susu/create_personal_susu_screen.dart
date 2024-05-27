import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/components/error_container.dart';
import 'package:susubox/components/loading_dialog.dart';
import 'package:susubox/model/linked_accounts.dart';

import '../../ApiService/api_service.dart';
import '../../components/link_account_dialog.dart';
import '../../utils/utils.dart';

class CreatePersonalSusuScreen extends StatefulWidget {

   const CreatePersonalSusuScreen({ super.key});

  @override
  State<CreatePersonalSusuScreen> createState() => _CreatePersonalSusuScreenState();
}

class _CreatePersonalSusuScreenState extends State<CreatePersonalSusuScreen> {

  bool enableFormOneButton = false;
  bool enableFormTwoButton = false;
  bool isChecked = false;
  bool isTermsChecked = false;
  bool showPinForm = false;
  bool passwordVisible = true;
  bool dataLoaded = false;
  bool errorOccurred = false;
  bool showAccountDialog = false;

  TextEditingController accountNameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController linkedAccountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  String token = '';
  String selectedAccountResourceId = '';
  String linkedAccountResource = '';

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
        if(showPinForm){
          setState(() {
            showPinForm = false;
          });
        }
        else{
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
              if(showPinForm){
                setState(() {
                  showPinForm = false;
                });
              }
              else{
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
                Text('Create',
                  style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w700, height: 1.0),
                ),
                Text('Personal Susu',
                  style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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

  Widget detailsForm(){
    return Column(
      children: [
        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
            hintText: 'Account Name',
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
          style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w300),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
          ),
          onChanged: (String? value) {
            setState(() {
              linkedAccountController.text = value!;
              checkValidity();

              final selectedAccount = linkedAccounts.firstWhere((network) => network['account_number'] == value);
              selectedAccountResourceId = selectedAccount['resourceId']!;
              print('Resource Id $selectedAccountResourceId');
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        enableFormOneButton == false
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50.0),
              disabledBackgroundColor: textFieldColor
          ),
          onPressed: null,
          child: Text('Create Account',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
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
              createSusu();
            }
          },
          child: Text('Create Account',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
        ),
      ],
    );
  }

  Widget pinForm(){
    return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text('This action requires pin approval. Enter your Susubox PIN to approve',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.grey)
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w300),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              enableFormTwoButton == false
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
                  approveSusuCreation();
                },
                child: Text('Approve',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
              ),
              SizedBox(height: 10.h),
            ],
          );
  }

  void checkValidity(){
    enableFormOneButton = accountNameController.text.length > 1
        && amountController.text.isNotEmpty &&
        purposeController.text.length > 1 &&
        linkedAccountController.text.isNotEmpty;
  }

  void createSusu() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().createPersonalSusu(
          accountNameController.text,
          purposeController.text,
          amountController.text,
          selectedAccountResourceId,
           token)
          .timeout(const Duration(seconds: 60));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          dismissDialog(context);
          linkedAccountResource = responseData['data']['attributes']['resource_id'];
          print('Resource Id $linkedAccountResource');
          setState(() {
            showPinForm = true;
          });
        }
        else if(response.statusCode == 200 && responseData['code'] == 422){
          dismissDialog(context);
          showErrorMessage(context, 'Oops', responseData['errors'].toString(),
                  () {
                Navigator.pop(context);
              });
        }
        else{
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'Something went wrong',
                  () {
                Navigator.pop(context);
              });
        }
      }
    } catch (e) {
      if(mounted){
        print('Connection Error $e');
        dismissDialog(context);
        showErrorMessage(context, 'Oops', 'An unexpected error occurred',
                () {
              Navigator.pop(context);
            });
      }
    }
  }

  void approveSusuCreation() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().approvePersonalSusu(linkedAccountResource,
          pinController.text, token)
          .timeout(const Duration(seconds: 60));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          dismissDialog(context);
          showCongratulationMessage(context, 'Congratulations',
              'Your personal susu has been created. You will be debited GHS ${amountController.text} daily. We advise you always maintain such balance in your ${linkedAccountController.text} mobile money wallet for successful debit.',
              'Ok', () {
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
              });
        }
        else if(response.statusCode == 200 && responseData['code'] == 422){
          dismissDialog(context);
          showErrorMessage(context, 'Oops', responseData['errors'].toString(),
                  () {
                Navigator.pop(context);
              });
        }
        else{
          dismissDialog(context);
          showErrorMessage(context, 'Oops', 'Something went wrong',
                  () {
                Navigator.pop(context);
              });
        }
      }
    } catch (e) {
      if(mounted){
        print('Connection Error $e');
        dismissDialog(context);
        showErrorMessage(context, 'Oops', 'An unexpected error occurred',
                () {
              Navigator.pop(context);
            });
      }
    }
  }

}
