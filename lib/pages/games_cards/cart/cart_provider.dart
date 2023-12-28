import 'package:flutter/cupertino.dart';

import '../../../models/game_card_model.dart';

class CartProvider with ChangeNotifier {
  List<GameCardModel> products = [];

  addProduct(GameCardModel product) async {
    if (products.where((element) => element.id == product.id).toList().length == 0) products.add(product);
    products.where((element) => element.id == product.id).first.count = 1;
    notifyListeners();
  }

  addQty(GameCardModel product) async {
    product.count = product.count! + 1;
    products.where((element) => element.id == product.id).first.count = product.count;
    notifyListeners();
  }

  removeQty(GameCardModel product) async {
    product.count = product.count! - 1;
    if (product.count == 0)
      products.removeWhere((element) => element.id == product.id);
    else
      products.where((element) => element.id == product.id).first.count = product.count;
    notifyListeners();
  }

  removeProduct(GameCardModel product) async {
    products.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }

  double totalPrice() {
    double total = 0;
    products.forEach((element) {
      total += element.price! * element.count!;
    });
    return total;
  }

  void removeAll() {
    products.clear();
  }
}
