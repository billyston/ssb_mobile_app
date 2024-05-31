// To parse this JSON data, do
//
//     final susuAccounts = susuAccountsFromJson(jsonString);

import 'dart:convert';

SusuAccounts susuAccountsFromJson(String str) => SusuAccounts.fromJson(json.decode(str));

String susuAccountsToJson(SusuAccounts data) => json.encode(data.toJson());

class SusuAccounts {
  bool status;
  int code;
  String message;
  dynamic description;
  Meta meta;
  List<Datum> data;

  SusuAccounts({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
  });

  factory SusuAccounts.fromJson(Map<String, dynamic> json) => SusuAccounts(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    description: json["description"],
    meta: Meta.fromJson(json["meta"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "description": description,
    "meta": meta.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String type;
  Attributes attributes;

  Datum({
    required this.type,
    required this.attributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"],
    attributes: Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "attributes": attributes.toJson(),
  };
}

class Attributes {
  String resourceId;
  String accountName;
  String accountNumber;
  String frequency;
  String scheme;
  String schemeCode;
  String status;
  DateTime createdAt;

  Attributes({
    required this.resourceId,
    required this.accountName,
    required this.accountNumber,
    required this.frequency,
    required this.scheme,
    required this.schemeCode,
    required this.status,
    required this.createdAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resourceId: json["resource_id"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    frequency: json["frequency"],
    scheme: json["scheme"],
    schemeCode: json["scheme_code"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "account_name": accountName,
    "account_number": accountNumber,
    "frequency": frequency,
    "scheme": scheme,
    "scheme_code": schemeCode,
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}

class Meta {
  String version;

  Meta({
    required this.version,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "version": version,
  };
}
