import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../../../models/Constant.dart';
import '../../../models/game_card_model.dart';
import '../cart/cart_provider.dart';

class GameCardDetailsScreen extends StatelessWidget {
  GameCardDetailsScreen({Key? key, required this.gameCardModel}) : super(key: key);
  static const routeName = "/games_card_details_screen";
final GameCardModel gameCardModel;
  @override
  Widget build(BuildContext context) {
    print('namenamename ===  : ${gameCardModel.name}');
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    GameCardModel model = gameCardModel;
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
                      ? Container(
                        width:MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.3,
                        child: CachedNetworkImage(
                            imageUrl: model.image!,
                            height: MediaQuery.of(context).size.width / 3,
                            width:  MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                      )
                      : Image.asset(
                          'assets/images/s.png',
                          height: MediaQuery.of(context).size.width / 3,
                          width: double.infinity,
                          fit: BoxFit.fitHeight,
                        ),
                  SizedBox(width: 18),
                  Padding(
                    padding: const EdgeInsets.only(left:20,right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        // DefaultTextStyle(
                        //   style: GoogleFonts.poppins(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //     color: appColor,
                        //   ),
                        //   textAlign: TextAlign.center,
                        //   child: AnimatedTextKit(
                        //     animatedTexts: [
                        //       WavyAnimatedText('${model.name!}'),
                        //     ],
                        //     isRepeatingAnimation: true,
                        //     onTap: () {
                        //       print("Tap Event");
                        //     },
                        //   ),
                        // ),
                        Text(
                          model.name!,
                          style:
                          GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          locale: Locale(Constant.lang!, ""),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),

                        Text(
                          model.details!,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          locale: Locale(Constant.lang!, ""),
                          textAlign: TextAlign.start,
                        ),
                        // SizedBox(
                        //   width: 250.0,
                        //   child: DefaultTextStyle(
                        //     style:  GoogleFonts.cairo(
                        //       fontSize: 15.0,
                        //       fontWeight: FontWeight.w700,
                        //       color: const Color(0xFF000081),
                        //       letterSpacing: 0.0047600000202655795,
                        //     ),
                        //     child:
                        //     AnimatedTextKit(
                        //       pause: Duration(seconds: 3),
                        //       animatedTexts: [
                        //
                        //         WavyAnimatedText('${model.price} L.E'),
                        //         // TyperAnimatedText('${model.price} L.E',speed: Duration(milliseconds: 40)),
                        //         // TypewriterAnimatedText('${model.price} L.E'),
                        //
                        //       ],
                        //       isRepeatingAnimation: true,
                        //       onTap: () {
                        //         print("Tap Event");
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Text(
                          '${model.price} L.E',
                          style:
                          GoogleFonts.cairo(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000081),
                            letterSpacing: 0.0047600000202655795,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          model.sku!,
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
                        SizedBox(height: 50),
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
