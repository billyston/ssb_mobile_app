import 'dart:convert';

SusuSchemes susuSchemesFromJson(String str) => SusuSchemes.fromJson(json.decode(str));

String susuSchemesToJson(SusuSchemes data) => json.encode(data.toJson());

class SusuSchemes {
  bool status;
  int code;
  String message;
  String description;
  Meta meta;
  List<Datum> data;

  SusuSchemes({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
  });

  factory SusuSchemes.fromJson(Map<String, dynamic> json) => SusuSchemes(
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
  String name;
  String alias;
  String code;
  String description;
  String status;

  Attributes({
    required this.resourceId,
    required this.name,
    required this.alias,
    required this.code,
    required this.description,
    required this.status,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resourceId: json["resource_id"],
    name: json["name"],
    alias: json["alias"],
    code: json["code"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "name": name,
    "alias": alias,
    "code": code,
    "description": description,
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
