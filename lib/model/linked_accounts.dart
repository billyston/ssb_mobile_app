import 'dart:convert';

LinkedAccounts linkedAccountsFromJson(String str) => LinkedAccounts.fromJson(json.decode(str));

String linkedAccountsToJson(LinkedAccounts data) => json.encode(data.toJson());

class LinkedAccounts {
  bool status;
  int code;
  String message;
  dynamic description;
  Meta meta;
  List<Datum> data;

  LinkedAccounts({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
  });

  factory LinkedAccounts.fromJson(Map<String, dynamic> json) => LinkedAccounts(
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
  String scheme;
  bool isVerified;
  String status;

  Attributes({
    required this.resourceId,
    required this.accountName,
    required this.accountNumber,
    required this.scheme,
    required this.isVerified,
    required this.status,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resourceId: json["resource_id"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    scheme: json["scheme"],
    isVerified: json["is_verified"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "account_name": accountName,
    "account_number": accountNumber,
    "scheme": scheme,
    "is_verified": isVerified,
    "status": status,
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
