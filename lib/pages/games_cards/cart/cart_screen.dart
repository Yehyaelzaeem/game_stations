import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../../../models/Constant.dart';
import '../payment/payment_webview.dart';
import '../widgets/card_item.dart';
import 'cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart_screen";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("------>:${Constant.token}");

    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 32),

            globalHeader(context, translate("store.cart")),
            SizedBox(height: 8),

            ...cartProvider.products.map((e) {
              return CardItem(e);
            }).toList(),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 32, top: 10, bottom: 10, right: 32),
                    //height: 33.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          translate("store.productsCount"),
                          style: GoogleFonts.cairo(
                            fontSize: 16.0,
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${cartProvider.products.length}',
                          style: GoogleFonts.cairo(
                            fontSize: 18.0,
                            color: const Color(0xFF000081),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 2,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 32, top: 10, bottom: 10, right: 32),
                    //  height: 33.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          translate("store.total_price"),
                          style: GoogleFonts.cairo(
                            fontSize: 16.0,
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${cartProvider.totalPrice()} L.E',
                          style: GoogleFonts.cairo(
                            fontSize: 18.0,
                            color: const Color(0xFF000081),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CompletePaymentButton(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class CompletePaymentButton extends StatefulWidget {
  @override
  State<CompletePaymentButton> createState() => _CompletePaymentButtonState();
}

class _CompletePaymentButtonState extends State<CompletePaymentButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
     try{
        if (cartProvider.products.isEmpty) return;
        if (Constant.token == null || Constant.token!.isEmpty) {
          Fluttertoast.showToast(
            msg: translate("toast.login"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: appColor,
            textColor: colorWhite,
            fontSize: 16.0,
          );
          return;
        }
        if (loading) return;
        loading = true;
        setState(() {});
        String url = "";
          Map<String, dynamic> params = {};
          for (int i = 0; i < cartProvider.products.length; i++) {
            if (cartProvider.products[i].count! > 0) {
              params['product[$i][id]'] = '${cartProvider.products[i].id.toString()}';
              params['product[$i][qty]'] = '${cartProvider.products[i].count.toString()}';
            }
          }
          params.forEach((key, value) {
            print("------> key->$key: value->$value");
          });
        var headers = {
          'x-api-key': 'mwDA9w',
          'Content-Language': 'ar',
          'Content-Country': '1',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Constant.token}'
        };
        var data = FormData.fromMap(params);
        var dio = Dio();
        var response = await dio.request(
          'http://dev.gamestationapp.com/api/checkout',
          options: Options(
            method: 'POST',
            headers: headers,
          ),
          data: data,
        );
        if (response.statusCode == 200) {
          showToast('Success');
          print(json.encode(response.data));
        }
        else {
          showToast(response.statusMessage.toString());
          print(response.statusMessage);
        }
           url = response.data['payment_url'];
          print('------>response  ${response.data}');
          print('------>url  $url');
          if (url.isNotEmpty&&url!='')
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InAppWebViewExampleScreen(url: url),
              ),
            );

          // showToast('${response.data['message']}');

          // Fluttertoast.showToast(
          //   msg:"Successfully created" ,
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.TOP,
          //   backgroundColor: Colors.greenAccent,
          //   textColor: colorWhite,
          //   fontSize: 18.0,
          // );
        } on DioError catch (e) {

          if (e.response!.data['message'] != null){
            print('errrrrrorr : ${e.response!.data['message']}');
            showToast('${e.response!.data['message']}');
          }
          else
            showToast("Something went wrong please try again later");
        }

        loading = false;
        setState(() {});
      },
      child: Center(
        child: Container(
          width: 135.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.0),
            color: const Color(0xFF000081),
          ),
          child: loading
              ? Column(
                  children: [
                    SizedBox(height: 8),
                    Container(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.4),
                    ),
                    SizedBox(height: 8),
                  ],
                )
              :
          Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    translate("store.order_complete"),
                    style: GoogleFonts.cairo(
                      fontSize: 12.0,
                      color: const Color(0xFFEAC43D),
                      letterSpacing: 0.003920000016689301,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}
