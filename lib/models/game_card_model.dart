import 'package:flutter/cupertino.dart';

class GameCardModel with ChangeNotifier {
  int? id;
  String? name;
  String? image;
  String? details;
  double? price;
  String? sku;
  String? pinValue;
  String? snValue;
  int? count;

  GameCardModel({
    this.id,
    this.name,
    this.image,
    this.details,
    this.price,
    this.sku,
    this.pinValue,
    this.snValue,
  });

  GameCardModel.fromJson(Map<String, dynamic> json) {
    id = json['product_id'] as int;
    name = json['name'];
    image = json['image'] ??= "";
    details = json['details'] ??= "";
    sku = json['sku'];
    snValue = "${json['SN_VALUE']}";
    pinValue = "${json['PIN_VALUE']}";
    sku = "${json['sku']}";
    count = 1;
    price = json['price'].toDouble();
  }
}
