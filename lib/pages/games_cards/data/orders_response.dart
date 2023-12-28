// To parse this JSON data, do
//
//     final myOrdersResponse = myOrdersResponseFromJson(jsonString);

import 'dart:convert';

MyOrdersResponse myOrdersResponseFromJson(String str) => MyOrdersResponse.fromJson(json.decode(str));

String myOrdersResponseToJson(MyOrdersResponse data) => json.encode(data.toJson());

class MyOrdersResponse {
  MyOrdersResponse({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  bool? success;
  List<OrderProducts>? data;
  String? message;
  int? code;

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) => MyOrdersResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : List<OrderProducts>.from(json["data"].map((x) => OrderProducts.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null ? null : message,
        "code": code == null ? null : code,
      };
}

class OrderProducts {
  OrderProducts({
    this.id,
    this.qty,
    this.totalPrice,
    this.products,
    this.orderType,
    this.createdAt,
  });

  int? id;
  int? qty;
  String? totalPrice;
  String? orderType;
  DateTime? createdAt;
  List<OrderItemProducts>? products;

  factory OrderProducts.fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json["id"] == null ? null : json["id"],
        qty: json["qty"] == null ? null : json["qty"],
        totalPrice: json["total_price"] == null ? null : json["total_price"],
        orderType: json["order_type"] ?? "",
        products: json["products"] == null ? null : List<OrderItemProducts>.from(json["products"].map((x) => OrderItemProducts.fromJson(x))),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "qty": qty == null ? null : qty,
        "total_price": totalPrice == null ? null : totalPrice,
        "products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class OrderItemProducts {
  OrderItemProducts({
    this.id,
    this.productId,
    this.name,
    this.sku,
    this.price,
    this.image,
    this.pinValue,
    this.snValue,
  });

  int? id;
  int? productId;
  String? name;
  String? sku;
  String? price;
  String? image;
  String? pinValue;
  String? snValue;

  factory OrderItemProducts.fromJson(Map<String, dynamic> json) => OrderItemProducts(
        id: json["id"] == null ? '' : json["id"],
        productId: json["product_id"] == null ? '' : json["product_id"],
        name: json["name"] == null ? '' : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null ? '' : '${json["price"]}',
        image: json["image"] == null ? '' : json["image"],
        pinValue: json["PIN_VALUE"] == null ? null : json["PIN_VALUE"],
        snValue: json["SN_VALUE"] == null ? null : json["SN_VALUE"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "product_id": productId == null ? null : productId,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "price": price == null ? null : price,
        "image": image == null ? null : image,
        "PIN_VALUE": pinValue == null ? null : pinValue,
        "SN_VALUE": snValue == null ? null : snValue,
      };
}
