
import 'Options.dart';

class Cart{
  String? id,name,qty,price,weight,discount,tax,subtotal;
  List<Options>? options;

  Cart(
      {this.id,
      this.name,
      this.qty,
      this.price,
      this.weight,
      this.discount,
      this.tax,
      this.subtotal,
      this.options});

    // factory Cart.fromJson(Map<String, dynamic> jsonMap) {
    //  return
    //    Cart(
    //      id : jsonMap['id'],
    //   name :jsonMap['name'],
    //   qty : jsonMap['qty'],
    //   price : jsonMap['price'],
    //   subtotal :jsonMap['subtotal']);
    // }

}