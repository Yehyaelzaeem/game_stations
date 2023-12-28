import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/Constant.dart';
import '../../../models/game_card_model.dart';
import '../cart/cart_provider.dart';

class GameCardItemWidget extends StatelessWidget {
  final GameCardModel product;
  GameCardItemWidget(this.product,) : super();

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(GameCardDetailsScreen.routeName, arguments: product);  
            },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(Constant.lang == "ar" ? 20 : 0), bottomRight: Radius.circular(Constant.lang == "ar" ? 20 : 0), bottomLeft: Radius.circular(Constant.lang == "en" ? 20 : 0), topLeft: Radius.circular(Constant.lang == "en" ? 20 : 0)),
                  child: product.image != null && product.image!.isNotEmpty
                      ? CachedNetworkImage(
                          height: double.infinity,
                          width: MediaQuery.of(context).size.width / 3,
                          fit: BoxFit.fill,
                          imageUrl: product.image!,
                        )
                      : Image.asset(
                          'assets/images/s.png',
                          height: double.infinity,
                          width: MediaQuery.of(context).size.width / 3,
                          fit: BoxFit.fill,
                        ),
                ),
                if (false)
                  PositionedDirectional(
                      top: 5,
                      start: 5,
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.24),
                              offset: Offset(0, 3.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          // color: appColor,
                          size: 24,
                        ),
                      ))
              ],
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    product.name!,
                    locale: Locale(Constant.lang!, ""),
                    style: GoogleFonts.cairo(
                      fontSize: 12.0,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '${product.price} L.E',
                    style: GoogleFonts.cairo(
                      fontSize: 12.0,
                      color: const Color(0xFF000081),
                      letterSpacing: 0.0047600000202655795,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(
                      product.sku!,
                      style: GoogleFonts.cairo(
                        fontSize: 12.0,
                        color: const Color(0xFF636363),
                        height: 1.3,
                      ),
                      maxLines: 4,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (cartProvider.products.where((element) => element.id == product.id).toList().length == 0)
                    GestureDetector(
                      onTap: () {
                        cartProvider.addProduct(product);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.0),
                          color: const Color(0xFF000081),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Center(
                            child: Text(
                              translate("store.addToCart"),
                              style: GoogleFonts.cairo(
                                fontSize: 12.0,
                                color: const Color(0xFFEAC43D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (cartProvider.products.where((element) => element.id == product.id).toList().length > 0)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.0),
                        color: const Color(0xFF000081),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Center(
                          child: Icon(Icons.check_circle, color: Color(0xFFEAC43D)),
                        ),
                      ),
                    ),
                  SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
