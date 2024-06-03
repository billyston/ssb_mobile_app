import 'dart:convert';

BizSusuAccount bizSusuAccountFromJson(String str) => BizSusuAccount.fromJson(json.decode(str));

String bizSusuAccountToJson(BizSusuAccount data) => json.encode(data.toJson());

class BizSusuAccount {
  bool status;
  int code;
  String message;
  dynamic description;
  Meta meta;
  Data data;

  BizSusuAccount({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
  });

  factory BizSusuAccount.fromJson(Map<String, dynamic> json) => BizSusuAccount(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    description: json["description"],
    meta: Meta.fromJson(json["meta"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "description": description,
    "meta": meta.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String type;
  DataAttributes attributes;
  Included included;

  Data({
    required this.type,
    required this.attributes,
    required this.included,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    attributes: DataAttributes.fromJson(json["attributes"]),
    included: Included.fromJson(json["included"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "attributes": attributes.toJson(),
    "included": included.toJson(),
  };
}

class DataAttributes {
  String resourceId;
  String businessName;
  String accountNumber;
  String? purpose;
  String susuAmount;
  String frequency;
  String linkedWallet;
  bool rolloverDebit;
  String status;
  DateTime dateCreated;

  DataAttributes({
    required this.resourceId,
    required this.businessName,
    required this.accountNumber,
    this.purpose,
    required this.susuAmount,
    required this.frequency,
    required this.linkedWallet,
    required this.rolloverDebit,
    required this.status,
    required this.dateCreated,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
    resourceId: json["resource_id"],
    businessName: json["business_name"],
    accountNumber: json["account_number"],
    purpose: json["purpose"],
    susuAmount: json["susu_amount"],
    frequency: json["frequency"],
    linkedWallet: json["linked_wallet"],
    rolloverDebit: json["rollover_debit"],
    status: json["status"],
    dateCreated: DateTime.parse(json["date_created"]),
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "business_name": businessName,
    "account_number": accountNumber,
    "purpose": purpose,
    "susu_amount": susuAmount,
    "frequency": frequency,
    "linked_wallet": linkedWallet,
    "rollover_debit": rolloverDebit,
    "status": status,
    "date_created": dateCreated.toIso8601String(),
  };
}

class Included {
  Scheme scheme;
  Currency currency;

  Included({
    required this.scheme,
    required this.currency,
  });

  factory Included.fromJson(Map<String, dynamic> json) => Included(
    scheme: Scheme.fromJson(json["scheme"]),
    currency: Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "scheme": scheme.toJson(),
    "currency": currency.toJson(),
  };
}

class Currency {
  CurrencyAttributes attributes;

  Currency({
    required this.attributes,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    attributes: CurrencyAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes.toJson(),
  };
}

class CurrencyAttributes {
  String currency;
  String symbol;

  CurrencyAttributes({
    required this.currency,
    required this.symbol,
  });

  factory CurrencyAttributes.fromJson(Map<String, dynamic> json) => CurrencyAttributes(
    currency: json["currency"],
    symbol: json["symbol"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "symbol": symbol,
  };
}

class Scheme {
  SchemeAttributes attributes;

  Scheme({
    required this.attributes,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) => Scheme(
    attributes: SchemeAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes.toJson(),
  };
}

class SchemeAttributes {
  String name;
  String code;

  SchemeAttributes({
    required this.name,
    required this.code,
  });

  factory SchemeAttributes.fromJson(Map<String, dynamic> json) => SchemeAttributes(
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
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
