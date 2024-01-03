import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helper/showtoast.dart';
import '../pages/games_cards/cart/cart_provider.dart';
import '../pages/games_cards/cart/cart_screen.dart';

Widget globalHeader(
  BuildContext context,
  String title, {
  bool showCart = false,
  bool showSearch = false,
  Function? onSearchTap,
}) {
  double width = MediaQuery.of(context).size.width;
  CartProvider cartProvider = Provider.of<CartProvider>(context);
  return Container(
    width: width,
    color: backGround,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [

          if (showCart)
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.shopping_cart,
                      color: appColor,
                      size: 20,
                    ),
                  ),
                  Positioned(
                      child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Color(0xFFEAC43D),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        child: Text(
                          cartProvider.products.length.toString(),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          Container(
            width: MediaQuery.of(context).size.width*0.5,
            child: Text(
              '$title',
              style: GoogleFonts.cairo(color: appColor, letterSpacing: 0.004200000017881393, fontWeight: FontWeight.w700, fontSize: width * 0.04 + 2),
               textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              if (showSearch)
                GestureDetector(
                    onTap: () {
                      if (onSearchTap != null) onSearchTap();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.search,
                        color: appColor,
                      ),
                    )),
              SizedBox(width: 6),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: appColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          )
        ],
      ),
    ),
  );
}
