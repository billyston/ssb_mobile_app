import 'dart:convert';

NetworkSchemes networkSchemesFromJson(String str) => NetworkSchemes.fromJson(json.decode(str));

String networkSchemesToJson(NetworkSchemes data) => json.encode(data.toJson());

class NetworkSchemes {
  bool status;
  int code;
  String message;
  String description;
  Meta meta;
  List<Datum> data;

  NetworkSchemes({
    required this.status,
    required this.code,
    required this.message,
    required this.description,
    required this.meta,
    required this.data,
  });

  factory NetworkSchemes.fromJson(Map<String, dynamic> json) => NetworkSchemes(
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
  String code;
  String status;

  Attributes({
    required this.resourceId,
    required this.name,
    required this.code,
    required this.status,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    resourceId: json["resource_id"],
    name: json["name"],
    code: json["code"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "name": name,
    "code": code,
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
