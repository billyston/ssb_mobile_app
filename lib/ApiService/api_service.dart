import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:susubox/model/linked_accounts.dart';
import 'package:susubox/model/network_schemes.dart';
import 'package:susubox/model/susu_schemes.dart';

import '../constants/ApiConstants.dart';

class ApiService {

  Future<http.Response> verifyPhoneNumber(String phoneNumber) async {
    final requestBody = {
        "data": {
          "type": "Customer",
          "attributes":
          {
            "phone_number":	phoneNumber
          }
        }
    };

    return await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.numberVerification),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> sendOTP(String phoneNumber) async {
    final requestBody = {
        "data": {
          "type": "Customer",
          "attributes":
          {
            "phone_number":	phoneNumber
          }
      }
    };

    return await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTP),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> verifyOTP(String otp, String resourceId) async {
    final requestBody = {
      "data":
      {
        "type": "Token",
        "attributes":
        {
          "token": otp
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.verifyOTP}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> createUserInfo(String firstName, String lastName, String email, String password, String resourceId) async {
    final attributes = {
      "first_name": firstName,
      "last_name": lastName,
      "password":	password,
      "accepted_terms": true
    };
    if(email.isNotEmpty){
      attributes["email"] = email;
    }
    final requestBody = {
      "data": {
        "type": "Customer",
        "attributes": attributes
      }
    };

    print('Request Body $requestBody');

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.createPersonalInfo}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> createPin(String pin, String confirmPin, String resourceId) async {
    final requestBody = {
      "data":
      {
        "type": "Pin",
        "attributes":
        {
          "pin": pin,
          "pin_confirmation":	confirmPin
        }
      }
    };

    print('Request body $requestBody');
    print('Url ${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.createPin}');

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.createPin}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> createEmailAndPassword(String email, String password, String resourceId) async {
    final attributes = {
      "password": password
    };
    if(email.isNotEmpty){
      attributes["email"] = email;
    }
    final requestBody = {
      "data":
      {
        "type": "Customer",
        "attributes": attributes
      }
    };

    print('Request Body $requestBody');

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.createEmailAndPassword}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> customerLogin(String phoneNumber, String password) async {
    final requestBody = {
      "data":
      {
        "type": "Customers",
        "attributes":
        {
          "phone_number":	phoneNumber,
          "password":	password
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginCustomer}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> verifyNumberPasswordReset(String phoneNumber) async {
    final requestBody = {
      "data":
      {
        "type": "Customer",
        "attributes":
        {
          "phone_number":	phoneNumber
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetPasswordVerifyNumber}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> verifyOTPPasswordReset(String otp, String resourceId) async {
    final requestBody = {
      "data":
      {
        "type": "Token",
        "attributes":
        {
          "token": otp
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.resetPasswordVerifyOTP}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> resetPassword(String password, String passwordConfirm, String resourceId) async {
    final requestBody = {
      "data":
      {
        "type": "Password",
        "attributes":
        {
          "password":	password,
          "password_confirmation": passwordConfirm
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}$resourceId${ApiConstants.resetPassword}'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<NetworkSchemes> getNetwork(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getNetworkSchemes),
      headers: {
        "Authorization" : "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return networkSchemesFromJson(response.body);
    } else {
      throw Exception('Failed to load zones');
    }
  }

  Future<LinkedAccounts> getLinkedAccounts(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getLinkedAccounts}'),
      headers: {
        "Authorization" : "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {

      final decodedData = json.decode(response.body);
      print(decodedData);

      LinkedAccounts linkedAccounts = linkedAccountsFromJson(json.encode(decodedData));

      return linkedAccounts;
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  Future<http.Response> linkAccount(String accountNumber, String resourceId, String token) async {
    final requestBody = {
      "data":
      {
        "type": "LinkedAccount",
        "attributes":
        {
          "account_number": accountNumber
        },
        "relationships":
        {
          "scheme":
          {
            "type": "Scheme",
            "attributes":
            {
              "resource_id": resourceId
            }
          }
        }
      }
    };

    print('Request body $requestBody');
    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.linkAccount}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> linkAccountApproval(String linkedAccount, String pin, String token) async {
    final requestBody = {
      "data":
      {
        "type": "Pin",
        "attributes":
        {
          "pin": pin
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.linkAccount}$linkedAccount${ApiConstants.approvals}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<SusuSchemes> getSusuSchemes(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.susuSchemes}'),
      headers: {
        "Authorization" : "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {

      final decodedData = json.decode(response.body);
      print(decodedData);

      SusuSchemes susuSchemes = susuSchemesFromJson(json.encode(decodedData));

      return susuSchemes;
    } else {
      throw Exception('Failed to load schemes');
    }
  }

  Future<http.Response> createPersonalSusu(String accountName, String purpose, String amount, String accountResourceId, String token) async {
    final requestBody = {
      "data":
      {
        "type": "PersonalSusu",
        "attributes":
        {
          "account_name": accountName,
          "purpose": purpose,
          "susu_amount": amount,
          "rollover_debit": true
        },

        "relationships":
        {
          "linked_account":
          {
            "type" : "LinkedAccount",
            "attributes":
            {
              "resource_id": accountResourceId
            }
          }
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createPersonalSusu}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> approvePersonalSusu(String linkedAccount, String pin, String token) async {
    final requestBody = {
      "data":
      {
        "type": "Pin",
        "attributes":
        {
          "pin": pin
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.approvePersonalSusu}$linkedAccount${ApiConstants.approvals}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> createBizSusu(String accountName, String purpose, String amount, String frequency, String accountResourceId, String token) async {
    final requestBody = {
      "data":
      {
        "type": "BizSusu",
        "attributes":
        {
          "account_name": accountName,
          "purpose": purpose,
          "susu_amount": amount,
          "frequency": frequency,
          "rollover_debit": true
        },

        "relationships":
        {
          "linked_account":
          {
            "type" : "LinkedAccount",
            "attributes":
            {
              "resource_id": accountResourceId
            }
          }
        }
      }
    };

    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createBizSusu}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

  Future<http.Response> approveBizSusu(String linkedAccount, String pin, String token) async {
    final requestBody = {
      "data":
      {
        "type": "Pin",
        "attributes":
        {
          "pin": pin
        }
      }
    };

    print('Url ${ApiConstants.baseUrl}${ApiConstants.approveBizSusu}$linkedAccount${ApiConstants.approvals}');
    return await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.approveBizSusu}$linkedAccount${ApiConstants.approvals}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestBody),
    );
  }

}