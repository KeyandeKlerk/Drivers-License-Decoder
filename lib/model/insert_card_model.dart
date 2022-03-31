// To parse this JSON data, do
//
//     final insertCard = insertCardFromJson(jsonString);

import 'dart:convert';

InsertCard insertCardFromJson(String str) => InsertCard.fromJson(json.decode(str));

String insertCardToJson(InsertCard data) => json.encode(data.toJson());

class InsertCard {
  InsertCard({
    this.error,
  });

  String error;

  factory InsertCard.fromJson(Map<String, dynamic> json) => InsertCard(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}

InsertBook insertBookFromJson(String str) => InsertBook.fromJson(json.decode(str));

String insertBookToJson(InsertCard data) => json.encode(data.toJson());

class InsertBook {
  InsertBook({
    this.error,
  });

  String error;

  factory InsertBook.fromJson(Map<String, dynamic> json) => InsertBook(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}

InsertDriver insertDriverFromJson(String str) => InsertDriver.fromJson(json.decode(str));

String insertDriverToJson(InsertCard data) => json.encode(data.toJson());

class InsertDriver {
  InsertDriver({
    this.error,
  });

  String error;

  factory InsertDriver.fromJson(Map<String, dynamic> json) => InsertDriver(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}

InsertDisk insertDiskFromJson(String str) => InsertDisk.fromJson(json.decode(str));

String insertDiskToJson(InsertCard data) => json.encode(data.toJson());

class InsertDisk {
  InsertDisk({
    this.error,
  });

  String error;

  factory InsertDisk.fromJson(Map<String, dynamic> json) => InsertDisk(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}