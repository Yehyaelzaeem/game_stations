import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../elements/widget_store_header.dart';
import '../../../models/Constant.dart';
import '../../../models/game_card_model.dart';
import '../cart/cart_provider.dart';

class GameCardDetailsScreen extends StatelessWidget {
  GameCardDetailsScreen({Key? key}) : super(key: key);
  static const routeName = "/games_card_details_screen";

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    GameCardModel model = ModalRoute.of(context)!.settings.arguments as GameCardModel;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 32),
          globalHeader(context, model.name!, showCart: true),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  model.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: model.image!,
                          height: MediaQuery.of(context).size.width / 3,
                          width: double.infinity,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset(
                          'assets/images/s.png',
                          height: MediaQuery.of(context).size.width / 3,
                          width: double.infinity,
                          fit: BoxFit.fitHeight,
                        ),
                  SizedBox(width: 18),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          model.name!,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          locale: Locale(Constant.lang!, ""),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          model.details!,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          locale: Locale(Constant.lang!, ""),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${model.price} L.E',
                          style: GoogleFonts.cairo(
                            fontSize: 16.0,
                            color: const Color(0xFF000081),
                            letterSpacing: 0.0047600000202655795,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          model.sku!,
                          style: GoogleFonts.cairo(
                            fontSize: 16.0,
                            color: const Color(0xFF636363),
                            height: 1.3,
                          ),
                          maxLines: 4,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 32),
                        if (cartProvider.products.where((element) => element.id == model.id).toList().length == 0)
                          GestureDetector(
                            onTap: () {
                              cartProvider.addProduct(model);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17.0),
                                color: const Color(0xFF000081),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Center(
                                  child: Text(
                                    translate("store.addToCart"),
                                    style: GoogleFonts.cairo(
                                      fontSize: 14.0,
                                      color: const Color(0xFFEAC43D),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (cartProvider.products.where((element) => element.id == model.id).toList().length > 0)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: const Color(0xFF000081),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          ),
        ],
      ),
    );
  }
}
