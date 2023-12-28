// To parse this JSON data, do
//
//     final searchCardGamesResponse = searchCardGamesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

SearchCardGamesResponse searchCardGamesResponseFromJson(String str) => SearchCardGamesResponse.fromJson(json.decode(str));

String searchCardGamesResponseToJson(SearchCardGamesResponse data) => json.encode(data.toJson());

class SearchCardGamesResponse {
    SearchCardGamesResponse({
         this.success,
         this.data,
         this.message,
         this.code,
    });

    final bool? success;
    final List<SingleCardGameProductItem>? data;
    final String? message;
    final int? code;

    factory SearchCardGamesResponse.fromJson(Map<String, dynamic> json) => SearchCardGamesResponse(
        success: json["success"],
        data: List<SingleCardGameProductItem>.from(json["data"].map((x) => SingleCardGameProductItem.fromJson(x))),
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "code": code,
    };
}

class SingleCardGameProductItem {
    SingleCardGameProductItem({
        @required this.id,
        @required this.productId,
        @required this.name,
        @required this.sku,
        @required this.details,
        @required this.price,
        @required this.image,
    });

    final int? id;
    final int? productId;
    final String? name;
    final String? sku;
    final String? details;
    final double? price;
    final String? image;

    factory SingleCardGameProductItem.fromJson(Map<String, dynamic> json) => SingleCardGameProductItem(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        sku: json["sku"],
        details: json["details"] == null ? null : json["details"],
        price : json['price'].toDouble(),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "sku": sku,
        "details": details == null ? null : details,
        "price": price,
        "image": image,
    };
}
