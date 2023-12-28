import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/Orders.dart';
import '../../models/ProductDetails.dart';
import '../../repository/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../helper/showtoast.dart';
import '../../main.dart';
import '../../models/Constant.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  List<ProductDetails>? products;
  String? date,location,status,orderID,order_date,shipping_fees,
      tax,discount,total;
  OrderDetailsPage({this.products,this.date,
    this.location,this.status,this.orderID,this.order_date,
    this.shipping_fees,this.tax,this.discount,this.total});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var orderProvider = Provider.of<Order>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_sharp,color: appColor,
                      size: width*0.08,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    translate("myorder.order_details"),
                    style: GoogleFonts.cairo(
                      color: appColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
         children: [
           Container(
             height: height*0.3+26,
             width: width,
             color: Colors.grey.shade100,
             padding: EdgeInsets.all(10),
             child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Text(translate("myorder.date"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.date.toString()
                         ,style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
                 Row(
                   children: [
                     Text(translate("myorder.order_date"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.order_date.toString(),style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
                 Row(
                   children: [
                     Text(translate("myorder.location"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     SizedBox(width: width*0.7,
                       child:Text(widget.location.toString(),
                       style: TextStyle(color: Colors.black45,),
                       overflow: TextOverflow.ellipsis,),)
                   ],
                 ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        Text(translate("myorder.status"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold),),
                        Text(widget.status.toString(),style: TextStyle(color: Colors.black45,),)
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.description_outlined,color: appColor,),
                      onPressed: (){

                      },
                    ),
                  ],
                ),
                 Row(
                   children: [
                     Text(translate("myorder.shipping_fees"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.shipping_fees.toString()+
                         translate("store.bound"),style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
                 Row(
                   children: [
                     Text(translate("myorder.tax"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.tax.toString()+
                         translate("store.bound"),style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
                 Row(
                   children: [
                     Text(translate("myorder.after_discount"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.discount.toString()+
                         translate("store.bound"),style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
                 Row(
                   children: [
                     Text(translate("activity_cart.total"),
                       style: GoogleFonts.cairo(
                           fontWeight: FontWeight.bold),),
                     Text(widget.total.toString()+
                         translate("store.bound"),style: TextStyle(color: Colors.black45,),)
                   ],
                 ),
               ],
             ),
           ),
           Container(
               height: height*0.6,
               width: width,
               child:GridView.builder(
                   padding: EdgeInsets.all(15.0),
                   itemCount: widget.products!.length,
                   physics: BouncingScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                       crossAxisSpacing: 1,
                       mainAxisSpacing: 10,
                       childAspectRatio: 0.84),
                   itemBuilder: (context, index) {
                     return  GestureDetector(
                       onTap: () {
                       },
                       child: Card(
                           elevation: 5,
                           color: colorWhite,
                           child: Container(
                             margin: EdgeInsets.all(3),
                             // color: Colors.yellow,
                             child:Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Stack(
                                   alignment: Alignment.topCenter,
                                   children: [
                                     Align(
                                       alignment: Alignment.bottomCenter,
                                       child: ClipRRect(
                                         borderRadius: BorderRadius.circular(8),
                                         child: Image.network(
                                           '${widget.products![index].productImage.toString()}',
                                           fit: BoxFit.fitWidth,
                                           height: height * 0.16,
                                           width: width,
                                         ),
                                       ),
                                     ),
                                     Align(
                                       alignment: Alignment.topRight,
                                       child: Container(
                                         decoration: BoxDecoration(
                                             color: Colors.grey.shade100,
                                             borderRadius: BorderRadius.circular(0)
                                         ),
                                         padding: EdgeInsets.only(left: 4,right: 4,top: 0,bottom: 0),
                                         margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                                         child: Text("${widget.products![index].amount}",
                                           style: GoogleFonts.cairo(color: appColor,
                                               fontWeight: FontWeight.bold,fontSize: width*0.05),),
                                       ),
                                     ),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(
                                       '${widget.products![index].productName}',
                                       style: TextStyle(color: Colors.black),
                                       textAlign: TextAlign.center,
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: [
                                     Text(
                                       '${widget.products![index].price}${translate("store.bound")}',
                                       style: TextStyle(
                                           color: appColor,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15),
                                     ),
                                     Text("${widget.products![index].weight}"),
                                     // ${translate("store.kg")}
                                   ],
                                 ),
                               ],
                             ),
                           )),
                     );
                   }
               ),
           ),
           Align(
               alignment: Alignment.bottomCenter,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [


                   MaterialButton(
                     child: Text(translate("myorder.add_another_order"),
                       style: GoogleFonts.cairo(color: colorWhite,
                           fontWeight: FontWeight.bold,fontSize: width*0.05),),
                     onPressed: (){
                       Navigator.of(context).push(MaterialPageRoute(builder:
                           (context)=>MyApp()));
                     },
                     color: appColor,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(50)
                     ),
                     padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                   ),
                   SizedBox(height: height*0.02,),
                   Container(
                     margin: EdgeInsets.only(left: 10,right: 10),
                     child: MaterialButton(
                       child: Text(translate("myorder.add_after_order"),
                         style: GoogleFonts.cairo(color: colorWhite,
                             fontWeight: FontWeight.bold,fontSize: width*0.05),),
                       onPressed: (){
                         orderProvider.orderIDForAddAnotherProduct=
                             widget.orderID.toString();
                       },
                       color: Colors.green,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10)
                       ),
                       padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                     ),
                   ),
                   SizedBox(height: height*0.02,),
                 ],
               )
           ),
         ],
        ),
      ),
    );
  }
}
