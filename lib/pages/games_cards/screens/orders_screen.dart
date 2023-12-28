import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/networkUtlis.dart';
import '../../../helper/showtoast.dart';
import '../../../models/Constant.dart';
import '../data/orders_response.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/order_screen";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGround,
        body: FutureBuilder<List<OrderProducts>>(
          key: GlobalKey(),
          future: getNetworkData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 32),
                globalHeader(context, translate("store.purchases")),
                Expanded(
                  flex: 4,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // return OrderItem(snapshot.data[index]);
                        if (Constant.lang == "ar")
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height / 1.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 12),
                                            OrderItem(snapshot.data![index].products!),
                                            SizedBox(height: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "رقم الطلب : ${snapshot.data![index].id}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    trailing: Text("الإجمالي : ${snapshot.data![index].totalPrice}"),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 12),
                                      Expanded(child: Text("الكمية ${snapshot.data![index].qty}")),
                                      OrderStatus(
                                          title: "${snapshot.data![index].orderType}",
                                          orderId: '${snapshot.data![index].id}',
                                          callback: () {
                                            setState(() {});
                                          }),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${snapshot.data![index].createdAt!.year}/${snapshot.data![index].createdAt!.month}/${snapshot.data![index].createdAt!.day}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Spacer(),
                                        if (snapshot.data![index].orderType!.toLowerCase() != "paid")
                                          Text(
                                            "الرجاء تأكيد الدفع",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 1.7,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 12),
                                          OrderItem(snapshot.data![index].products!),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "Order number : ${snapshot.data![index].id}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text("${snapshot.data![index].qty} Quantity"),
                                  trailing: Text("Total : ${snapshot.data![index].totalPrice}"),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 12),
                                      Expanded(child: Text("${snapshot.data![index].qty} Quantity")),
                                      Text(" Order status : "),
                                      OrderStatus(
                                          title: "${snapshot.data![index].orderType}",
                                          orderId: '${snapshot.data![index].id}',
                                          callback: () {
                                            setState(() {});
                                          }),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${snapshot.data![index].createdAt!.year}/${snapshot.data![index].createdAt!.month}/${snapshot.data![index].createdAt!.day}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Spacer(),
                                      if (snapshot.data![index].orderType!.toLowerCase() != "paid")
                                        Text(
                                          "Please confirm payment",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 30,
                        );
                      },
                      itemCount: snapshot.data!.length),
                ),
                SizedBox(height: 12),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else
              return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<List<OrderProducts>> getNetworkData() async {
    try {
      NetworkUtil networkUtil = NetworkUtil();
      Response response = await networkUtil.get("my_order",{'':''});
      if(response.statusCode == 200 || response.statusCode == 201){
      MyOrdersResponse ordersResponse = MyOrdersResponse.fromJson(response.data);
      return ordersResponse.data!;
      }else{
        return Future.error(response.data['errors']??"No data");
      }
    } catch (e) {
      return Future.error("$e");
    }
  }
}

class OrderStatus extends StatefulWidget {
  final String? title;
  final String? orderId;
  final Function? callback;
  const OrderStatus({@required this.title, @required this.orderId, @required this.callback});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool? loading = false;
  String? title = '';
  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    if (loading!)
      return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 0.8));
    return GestureDetector(
      onTap: () {
        if (title!.toLowerCase() != "paid") refresh();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Text(
              "$title",
              style: TextStyle(
                color: title!.toLowerCase() == "paid" ? Colors.green : Colors.orange,
              ),
            ),
            if (title!.toLowerCase() != "paid") SizedBox(width: 12),
            if (title!.toLowerCase() != "paid")
              Text(
                Constant.lang == 'ar' ? "تأكيد" : "Confirm",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> refresh() async {
    loading = true;
    setState(() {});
    NetworkUtil _utils = new NetworkUtil();
    try {
      FormData formData = FormData.fromMap({'order_id': widget.orderId});
      Response res = await _utils.get('order_pay?order_id=${widget.orderId}',{'':''});
      print('----> ${_utils.dio.options.baseUrl}order_pay/order_id=${widget.orderId}');
      print('----> ${res.statusCode}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        if ("${res.data['message']}".toLowerCase().contains("success")) {
          widget.callback!();
        } else if (res.data['message'] != null) {
          showToast("${res.data['message']}");
        }
      } else {
        showToast("Something went wrong \n please try again later");
      }
    } catch (e) {
      print('----> error $e');
      showToast("Something went wrong \n please try again later");
    }

    loading = false;
    setState(() {});
  }
}
