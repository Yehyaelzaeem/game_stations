

import 'ProductDetails.dart';

class OrdersModel {
  String? userPhone,
      marketPhone,
      orderNumber,
      complete,
      amount,
      orderDetails,
      orderPrice,
      uploadId,
      latorderlocate,
      lonorderlocate,date,location,shipping_fees,order_date,tax,discount;
  List<ProductDetails>? productsList;

  OrdersModel(
      {
        this.userPhone,
      this.marketPhone,
      this.orderNumber,
      this.complete,
      this.amount,
      this.orderDetails,
      this.orderPrice,
      this.uploadId,
      this.latorderlocate,
      this.lonorderlocate,this.date,this.location,
        this.productsList,this.shipping_fees,this.order_date,this.tax,this.discount});
}

class OrderStatus{
  String? id,content,active,updated_at;
  OrderStatus({this.id,this.content,this.active,this.updated_at});
}