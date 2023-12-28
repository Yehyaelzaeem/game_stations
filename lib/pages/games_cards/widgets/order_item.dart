import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helper/showtoast.dart';
import '../data/orders_response.dart';

class OrderItem extends StatefulWidget {
  final List<OrderItemProducts> products;
  const OrderItem(this.products, {Key? key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.products.map((product) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 3,
                spreadRadius: .5,
              )
            ]),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.image!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product!.image!,
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/images/s.png',
                                    width: 91,
                                    height: 104,
                                    fit: BoxFit.fill,
                                  );
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
                    SizedBox(width: 4),
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
                            maxLines: 2,
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
                          if (product.sku != null)
                            Text(
                              'SKU ${product.sku}',
                              style: GoogleFonts.cairo(fontSize: 14.0, color: const Color(0xFF000081)),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                        ],
                      ),
                    ))
                  ],
                ),
                if (product.snValue != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            //copy
                            String text = product.snValue!;
                            Clipboard.setData(ClipboardData(text: text));
                            showToast("Copied successfully");
                          },
                          icon: Icon(Icons.copy)),
                      Expanded(
                        child: Text(
                          'SN Value ${product.snValue}',
                          style: GoogleFonts.cairo(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000081),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                if (product.pinValue != null)
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            //copy
                            String text = product.pinValue!;
                            Clipboard.setData(ClipboardData(text: text));
                            showToast("Copied successfully");
                          },
                          icon: Icon(Icons.copy)),
                      Expanded(
                        child: Text(
                          'PIN Value ${product.pinValue}',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: const Color(0xFF000081),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
