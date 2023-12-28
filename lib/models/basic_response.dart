// To parse this JSON data, do
//
//     final basicResponse = basicResponseFromJson(jsonString);

import 'dart:convert';

BasicResponse basicResponseFromJson(String str) => BasicResponse.fromJson(json.decode(str));

String basicResponseToJson(BasicResponse data) => json.encode(data.toJson());

class BasicResponse {
  BasicResponse({
    this.success,
    this.message,
    this.code,
  });

  bool? success;
  String? message;
  int? code;

  factory BasicResponse.fromJson(Map<String, dynamic> json) => BasicResponse(
        success: json["success"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "code": code,
      };
}
