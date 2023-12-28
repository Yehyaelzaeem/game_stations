
class Helper{
  static double getOrderPrice(double total) {
    total += total != null ? total : 0;
    // total += deliveryFee;
    // total += order.tax * total / 100;
    return total;
  }
}

// _getTotal() {
//   print("get total");
//   total = all_price;
//   double more_price_hundred = double.parse(moreprice).toDouble() / 100;
//   double multi = more_price_hundred  * total;
//   total = all_price - multi ;
//   print("more_price_hundred: "+"$more_price_hundred");
//   print("multi: "+"$multi");
//   print("all_price: "+all_price.toString());
//   setState(() {
//     if (total >= 70) {
//       deliveryprice = 'free';
//     }else{
//       total = total + double.parse(deliveryprice.toString()).toDouble();
//     }
//   });
//   print("total: "+"$total");
// }