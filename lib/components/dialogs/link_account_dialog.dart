import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/components/error_container.dart';
import 'package:susubox/components/loading_dialog.dart';
import 'package:susubox/model/network_schemes.dart';

import '../../ApiService/api_service.dart';
import '../../utils/utils.dart';

class LinkAccountDialog extends StatefulWidget {
  const LinkAccountDialog({super.key});

  @override
  State<LinkAccountDialog> createState() => _LinkAccountDialogState();
}

class _LinkAccountDialogState extends State<LinkAccountDialog> {
  final key = GlobalKey<FormState>();
  bool isEditing = false;
  bool enableButton = false;
  bool enableButton2 = false;
  bool showPinForm = false;
  bool showErrorDialog = true;
  bool passwordVisible = true;
  bool errorOccurred = false;
  bool dataLoaded = false;

  TextEditingController accountIssuerController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String token = '';
  String linkedAccountResource = '';

  NetworkSchemes? networkSchemes;
  List<Map<String, String>> networks = [];

  String selectedNetworkResourceId = '';

  Future<NetworkSchemes?> getNetworkResourceId() async {
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      networkSchemes = await ApiService().getNetwork(token).timeout(const Duration(seconds: 90));
      networks = networkSchemes!.data.map((datum) {
        return {
          'name': datum.attributes.name,
          'resourceId': datum.attributes.resourceId,
        };
      }).toList();
      print('Schemes $networks');
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

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    getNetworkResourceId();
  }

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showErrorDialog) {
        showMessage(context, 'Oops', 'You have not linked any mobile money wallet to your Susubox account.', 'Link Mobile Money',
          () {
            setState(() {
              showErrorDialog = false;
            });
            Navigator.pop(context);
        },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return errorOccurred ? ErrorContainer(refreshPage: refreshPage)
    : dataLoaded ?
      showErrorDialog ? Container() : PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        },
      child: SingleChildScrollView(
        child: AlertDialog(
            backgroundColor: blackFaded,
            insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.2),
            contentPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Text( 'LINK MOBILE MONEY',
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
      ),
    ) : const LoadingDialog();
  }

  Widget editContent(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Form(
        key: key,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text('Linking your mobile money account to Susubox automates transactions for seamless financial processes.',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.grey)
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            DropdownButtonFormField<String>(
              dropdownColor: blackFaded,
              validator: (value) =>
              value == null ? 'Please select network type' : null,
              iconEnabledColor: Colors.grey,
              isExpanded: true,
              value: accountIssuerController.text.isEmpty
                  ? null
                  : accountIssuerController.text,
              items: networks.map<DropdownMenuItem<String>>((network) {
                return DropdownMenuItem<String>(
                  value: network['name'],
                  child: Text(
                    network['name']!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                  hintText: 'Select Network',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
              ),
              onChanged: (String? value) {
                setState(() {
                  accountIssuerController.text = value!;
                  enableButton = phoneController.text.length == 13 && accountIssuerController.text.isNotEmpty;

                  final selectedNetwork = networks.firstWhere((network) => network['name'] == value);
                  selectedNetworkResourceId = selectedNetwork['resourceId']!;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            PhoneFormField(
                initialValue: PhoneNumber.parse('+233'),
                countrySelectorNavigator: const CountrySelectorNavigator.page(),
                onChanged: (phoneNumber) {
                  phoneController.text = '+${phoneNumber.countryCode}${phoneNumber.nsn}';
                  enableButton = phoneController.text.length == 13 && accountIssuerController.text.isNotEmpty;
                },
                enabled: true,
                isCountrySelectionEnabled: false,
                isCountryButtonPersistent: true,
                countryButtonStyle: CountryButtonStyle(
                  showDropdownIcon: false,
                  showDialCode: true,
                  showIsoCode: false,
                  showFlag: true,
                  flagSize: 20.h,
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                ],
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            enableButton == false
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  disabledBackgroundColor: textFieldColor
              ),
              onPressed: null,
              child: Text('Link Account',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white)),
            ) : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                linkAccount();
              },
              child: Text('Link Account',
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
              Text('This action requires pin approval. Enter your Susubox PIN to approve',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.grey)
              ),
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
                  approveLinkedAccount();
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

  void showMessage(BuildContext context, String title, String message, String buttonLabel, VoidCallback buttonTapped) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 3;
            });
          },
          child: AlertDialog(
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
          ),
        );
      },
    );
  }

  void linkAccount() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().linkAccount(phoneController.text.replaceFirst('+233', '0'), selectedNetworkResourceId, token)
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

  void approveLinkedAccount() async {
    showLoadingDialog(context);
    try {
      final response = await ApiService().linkAccountApproval(linkedAccountResource,
          pinController.text, token)
          .timeout(const Duration(seconds: 60));
      final responseData = jsonDecode(response.body);

      print('Response Body $responseData');
      if(mounted){
        if (response.statusCode == 200 && responseData['code'] == 200) {
          dismissDialog(context);
          showCongratulationMessage(context, 'Congratulations', 'Link mobile money wallet request is accepted. You will receive a notification to confirm status.',
              'Ok', () {
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 3;
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

  void refreshPage(){
    setState(() {

    });
  }
}


