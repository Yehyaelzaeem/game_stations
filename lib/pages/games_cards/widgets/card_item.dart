import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/Constant.dart';
import '../../../models/game_card_model.dart';
import '../cart/cart_provider.dart';
import '../products/game_card_details.dart';

class CardItem extends StatelessWidget {
  final GameCardModel product;
  const CardItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>GameCardDetailsScreen(gameCardModel: product,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        width: MediaQuery.of(context).size.width,
        height: 106,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.23,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(Constant.lang == "ar" ? 20 : 0), bottomRight: Radius.circular(Constant.lang == "ar" ? 20 : 0), bottomLeft: Radius.circular(Constant.lang == "en" ? 20 : 0), topLeft: Radius.circular(Constant.lang == "en" ? 20 : 0)),
                child: product.image!.isNotEmpty
                    ? Image.network(
                        product.image!,
                        width: 91,
                        height: 104,
                        fit: BoxFit.fill,
                  errorBuilder: (context ,error ,errorBuilder){
                          return Text('waiting for image ....');
                  },
                      )
                    : Image.asset(
                        'assets/images/s.png',
                        width: 91,
                        height: 104,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: GoogleFonts.cairo(
                      fontSize: 14.0,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: 0.0047600000202655795,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${product.price} L.E',
                    style: GoogleFonts.cairo(
                      fontSize: 14.0,
                      color: const Color(0xFF000081),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width*0.1),
                      Text(
                        product.count.toString(),
                        style: GoogleFonts.cairo(
                          fontSize: 19.0,
                          color: const Color(0xFF000081),
                          letterSpacing: 0.005320000022649765,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                     // StatefulBuilder(builder: (context,setState){
                     //   return  Row(
                     //     mainAxisSize: MainAxisSize.min,
                     //     mainAxisAlignment: MainAxisAlignment.start,
                     //     crossAxisAlignment: CrossAxisAlignment.center,
                     //     children: [
                     //       GestureDetector(
                     //         onTap: () {
                     //           cartProvider.addQty(product);
                     //           setState(() {});
                     //         },
                     //         child: Container(
                     //           width: 27.0,
                     //           height: 27.0,
                     //           alignment: Alignment.center,
                     //           decoration: BoxDecoration(
                     //             borderRadius: BorderRadius.circular(5.0),
                     //             color: Colors.white,
                     //             border: Border.all(
                     //               width: 1.0,
                     //               color: const Color(0xFF46468F),
                     //             ),
                     //           ),
                     //           child: Text(
                     //             '+',
                     //             style: GoogleFonts.cairo(
                     //               fontSize: 15.0,
                     //               color: const Color(0xFF000081),
                     //               letterSpacing: 0.004200000017881393,
                     //               fontWeight: FontWeight.w700,
                     //             ),
                     //             textAlign: TextAlign.center,
                     //           ),
                     //         ),
                     //       ),
                     //       SizedBox(
                     //         width: 15,
                     //       ),
                     //       Text(
                     //         '${product.count}',
                     //         style: GoogleFonts.cairo(
                     //           fontSize: 19.0,
                     //           color: const Color(0xFF000081),
                     //           letterSpacing: 0.005320000022649765,
                     //           fontWeight: FontWeight.w600,
                     //         ),
                     //         textAlign: TextAlign.center,
                     //       ),
                     //       SizedBox(
                     //         width: 15,
                     //       ),
                     //       GestureDetector(
                     //         onTap: () {
                     //           cartProvider.removeQty(product);
                     //         },
                     //         child: Container(
                     //           width: 27.0,
                     //           height: 27.0,
                     //           alignment: Alignment.center,
                     //           decoration: BoxDecoration(
                     //             borderRadius: BorderRadius.circular(5.0),
                     //             color: Colors.white,
                     //             border: Border.all(
                     //               width: 1.0,
                     //               color: const Color(0xFF46468F),
                     //             ),
                     //           ),
                     //           child: Text(
                     //             '-',
                     //             style: GoogleFonts.cairo(
                     //               fontSize: 15.0,
                     //               color: const Color(0xFF000081),
                     //               letterSpacing: 0.004200000017881393,
                     //               fontWeight: FontWeight.w700,
                     //             ),
                     //             textAlign: TextAlign.center,
                     //           ),
                     //         ),
                     //       )
                     //     ],
                     //   );
                     //
                     // }),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          cartProvider.removeProduct(product);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: const Color(0xFF000081),
                          ),
                          child: Text(
                            translate("store.remove"),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05),

                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
