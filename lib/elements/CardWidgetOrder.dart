import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../helper/showtoast.dart';
import '../models/ProductDetails.dart';
import '../pages/user/order_details.dart';
import 'package:google_fonts/google_fonts.dart';



Widget CardWidgetOrder(
    {String? userPhone,
    String? marketPhone,
    String? orderNumber,
    String? complete,
    String? amount,
    String? orderDetails,
    String? orderPrice,
    String? uploadId,
    String? latorderlocate,
String? shipping_fees,String? tax,String? order_date,String? discount,
    String? lonorderlocate,List<ProductDetails>? productList,
    BuildContext? context,String? date,String? location}){
  String product_name="";
  for(int i=0; i<productList!.length;i++){
    product_name=product_name+productList[i].productName!+ " (${productList[i].amount}) "+"\n";
  }
   double height= MediaQuery.of(context!).size.height;
   double width= MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder:
        (context)=>OrderDetailsPage(
          date: date!,
          location: location!,
          status: complete!,
          products: productList,
            orderID:uploadId!,
          shipping_fees: shipping_fees!,
          discount: discount!,
          tax: tax!,
          total: orderPrice!,
          order_date: order_date!,
        )));

      },
      child: Card(
          elevation: 10,
          clipBehavior: Clip.hardEdge,
          child: Container(
            padding: EdgeInsets.all(width*0.03),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: width*0.6,
                      child: Text(translate("myorder.date")+date!,
                        style: GoogleFonts.cairo(color: Colors.black45),
                        overflow: TextOverflow.ellipsis,),
                    ),
                     SizedBox(
                       width: width*0.6,
                       child:  Text(translate("myorder.location")+location!,
                         style: GoogleFonts.cairo(color: Colors.black45,
                             fontSize: width*0.04),
                         overflow: TextOverflow.ellipsis,),
                     ),
                  ],
                ),
                SizedBox(width: width*0.02,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${orderNumber.toString()}#",
                      style: GoogleFonts.cairo(color: Colors.black),),
                    Text(
                      "${orderPrice.toString()}${translate("store.bound")}",
                      style: GoogleFonts.cairo(
                        fontSize: height * 0.02,
                        color: appColor,
                      ),),
                  ],
                ),
              ],
            ),
          )
      ),
    );
}
// Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text("$complete",
// style: GoogleFonts.cairo(fontSize: width*0.04,
// color: Colors.grey[500]),),
// Text("${orderNumber.toString()}#",
// style: GoogleFonts.cairo(color: Colors.grey),),
// ],
// ),
// Row(
// children: [
// CircleAvatar(
// backgroundColor: colorButton.withOpacity(0.09),
// radius: height * 0.04,
// child: Icon(Icons.storefront, color:  colorButtonTwo),
// ),
// SizedBox(width: width * 0.04),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "${orderPrice.toString()}${translate("store.bound")}",
// style: GoogleFonts.cairo(
// fontSize: height * 0.03,
// color: appColor,
// ),
// ),
// SizedBox(height: height*0.01,),
// GestureDetector(
// onTap: (){
// showDialog(
// context: context,
// builder: (ctx) {
// return ButtonBarTheme(
// data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
// child:AlertDialog(
// title: Align(
// child: Container(
// decoration: BoxDecoration(
// color: colorButton.withOpacity(0.2),
// borderRadius: BorderRadius.circular(40)
// ),
// child: IconButton(
// icon: Icon(Icons.close,color: colorButton,),
// onPressed: (){
// Navigator.of(ctx).pop();
// },
// ),
// ),
// alignment: Alignment.centerLeft,
// ),
// content: SingleChildScrollView(
// child:Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(translate("activity_cart.total"),
// style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
// Text(
// "${orderPrice.toString()}${translate("store.bound")}",
// style: GoogleFonts.cairo(
// fontSize: height * 0.03,
// color: Colors.grey,
// ),
// ),
// ],
// ),
// SizedBox(height: height*0.01,),
// Text("${product_name.toString()}",
// textAlign: TextAlign.center,),
// ],
// ),
// ),
// ),);
// });
// },
// child: Row(
// children: [
// Icon(Icons.description_outlined),
// Text(
// translate("myorder.order_details"),
// style: GoogleFonts.cairo(
// color: Colors.grey.shade700,
// ),
// ),
// ],
// ),
// ),
// ],
// )
// ],
// ),
// ],
// ),