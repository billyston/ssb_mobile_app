import 'dart:convert';

TransactionHistory transactionHistoryFromJson(String str) => TransactionHistory.fromJson(json.decode(str));

String transactionHistoryToJson(TransactionHistory data) => json.encode(data.toJson());

class TransactionHistory {
  bool status;
  int code;
  String message;
  dynamic description;
  Meta meta;
  List<Datum> data;
  DataMeta dataMeta;

  TransactionHistory({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
    required this.dataMeta,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) => TransactionHistory(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    description: json["description"],
    meta: Meta.fromJson(json["meta"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    dataMeta: DataMeta.fromJson(json["data_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "description": description,
    "meta": meta.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "data_meta": dataMeta.toJson(),
  };
}

class Datum {
  Type type;
  Attributes attributes;
  List<dynamic> extra;

  Datum({
    required this.type,
    required this.attributes,
    required this.extra,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: typeValues.map[json["type"]]!,
    attributes: Attributes.fromJson(json["attributes"]),
    extra: List<dynamic>.from(json["extra"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "attributes": attributes.toJson(),
    "extra": List<dynamic>.from(extra.map((x) => x)),
  };
}

class Attributes {
  String resourceId;
  String referenceNumber;
  String transactionType;
  String amount;
  String wallet;
  String description;
  String narration;
  DateTime transactionDate;
  String status;

  Attributes({
    required this.resourceId,
    required this.referenceNumber,
    required this.transactionType,
    required this.amount,
    required this.wallet,
    required this.description,
    required this.narration,
    required this.transactionDate,
    required this.status,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resourceId: json["resource_id"],
    referenceNumber: json["reference_number"],
    transactionType: json["transaction_type"],
    amount: json["amount"],
    wallet: json["wallet"],
    description: json["description"],
    narration: json["narration"],
    transactionDate: DateTime.parse(json["transaction_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "reference_number": referenceNumber,
    "transaction_type": transactionTypeValues.reverse[transactionType],
    "amount": amount,
    "wallet": wallet,
    "description": descriptionValues.reverse[description],
    "narration": narrationValues.reverse[narration],
    "transaction_date": transactionDate.toIso8601String(),
    "status": statusValues.reverse[status],
  };
}

enum Description {
  RECURRING_DEBIT_FOR_SUSUACCOUNT_NUMBER_305517799211
}

final descriptionValues = EnumValues({
  "Recurring debit for susuaccount number: 305517799211": Description.RECURRING_DEBIT_FOR_SUSUACCOUNT_NUMBER_305517799211
});

enum Narration {
  SOME_NARRATION_FOR_BIZ_SUSU_GOES_HERE
}

final narrationValues = EnumValues({
  "Some narration for biz susu goes here": Narration.SOME_NARRATION_FOR_BIZ_SUSU_GOES_HERE
});

enum Status {
  SUCCESS
}

final statusValues = EnumValues({
  "success": Status.SUCCESS
});

enum TransactionType {
  DEBIT
}

final transactionTypeValues = EnumValues({
  "debit": TransactionType.DEBIT
});

enum Type {
  TRANSACTION
}

final typeValues = EnumValues({
  "Transaction": Type.TRANSACTION
});

class DataMeta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  DataMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory DataMeta.fromJson(Map<String, dynamic> json) => DataMeta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
