import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gamestation/pages/store/product_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../elements/review.dart';
import '../../elements/small_Widgets.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../repository/categories.dart';
import '../../repository/fav_cart.dart';
import '../signing/login_screen.dart';

class SearchPage extends StatefulWidget {
  String? cat, city, type, word;
  SearchPage({this.cat, this.city, this.type, this.word});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController? myScrollController;
  @override
  void initState() {
    myScrollController = ScrollController();
    print(
        widget.city! + " " + widget.word! + " " + widget.type! + " " + widget.cat!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    var favProvider = Provider.of<FavAndCart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate("store.search") +
              "${widget.word == "" || widget.word == "filter" ? "...." : widget.word}",
          style: GoogleFonts.cairo(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
              color: appColor),
        ),
        backgroundColor: colorWhite,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: appColor, opacity: 12, size: 25),
      ),
      backgroundColor: backGround,
      body: widget.word == "filter"
          ? FutureBuilder(
              future: categoryProvider.search(
                  type:
                      'null', // "${widget.type.toString().replaceAll("null", "").toString().trim()}",
                  cat:
                      'null', // "${widget.cat.toString().replaceAll("null", "").toString().trim()}",
                  city:
                      'null' //"${widget.city.toString().replaceAll("null", "").toString().trim()}"
                  ,
                  word:
                      "${widget.word.toString().replaceAll("null", "").toString().trim()}"),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: appColor,
                  ));
                } else {
                  return snapshot.data!.length == 0
                      ? Center(
                          child: Text(
                          translate(
                            "toast.home_no_product",
                          ),
                          style: TextStyle(color: appColor),
                        ))
                      : ListView.separated(
                          padding: EdgeInsets.all(20),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () async {
                                  await categoryProvider
                                      .getProductDetails(
                                          snapshot.data![index].productId!)
                                      .then((value) {
                                    print("______________" +
                                        value[index].images!.length.toString());
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsPage(
                                                  id: "${snapshot.data![index].productId}",
                                                  location:
                                                      "${snapshot.data![index].countryName}",
                                                  title:
                                                      "${snapshot.data![index].productName}",
                                                  image:
                                                      "${snapshot.data![index].productImage}",
                                                  price:
                                                      "${snapshot.data![index].price}",
                                                  rate_value:
                                                      "${snapshot.data![index].rate_value}",
                                                  images: value.first.images,
                                                  views: "${value.first.views}",
                                                  description:
                                                      "${value.first.longDescription}",
                                                  marketName:
                                                      "${value.first.marketName}",
                                                  marketID:
                                                      "${value.first.marketId}",
                                                  marketPhone:
                                                      "${value.first.marketPhone}",
                                                  fav: value.first.fav
                                                              .toString() ==
                                                          "true"
                                                      ? true
                                                      : false,
                                                )));
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                        height: height * 0.3,
                                        color: backGround,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height * 0.1 + 30,
                                              decoration: BoxDecoration(
                                                color: backGround,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.04),
                                                    topLeft: Radius.circular(
                                                        width * 0.04)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${snapshot.data![index].productImage}"),
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment.center),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.1 + 30,
                                              decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  30),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  30))),
                                              padding: EdgeInsets.only(
                                                  left: width * 0.05,
                                                  right: width * 0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].productName}",
                                                            style: GoogleFonts.cairo(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize:
                                                                    width *
                                                                        0.04),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${snapshot.data![index].price}" +
                                                            translate(
                                                                "store.bound"),
                                                        style:
                                                            GoogleFonts.cairo(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: appColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: appColor,
                                                              ),
                                                              Text(
                                                                "${snapshot.data![index].marketName.toString()}",
                                                                style:
                                                                    GoogleFonts
                                                                        .cairo(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          reView(200, context),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_pin,
                                                            color: appColor,
                                                            size: width * 0.05,
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].countryName}",
                                                            style: GoogleFonts
                                                                .cairo(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: appColor,
                                              ),
                                              padding: EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                translate(
                                                    "store.contact_with_seller"),
                                                style: GoogleFonts.cairo(
                                                    color: appColorTwo,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (Constant.token == null ||
                                                  Constant.token.toString() ==
                                                      "null" ||
                                                  Constant.token.toString() ==
                                                      "") {
                                                SmallWidgets.shouldBeRegister(
                                                    context);
                                              } else {
                                                await favProvider
                                                    .addToFavourite(
                                                        productID:
                                                            "${snapshot.data![index].productId}",
                                                        context: context)
                                                    .then((value) {
                                                  if (snapshot.data![index].fav
                                                          .toString() ==
                                                      "true") {
                                                    snapshot.data![index].fav =
                                                        "true";
                                                  } else {
                                                    snapshot.data![index].fav =
                                                        "false";
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: appColor,
                                              ),
                                              padding: EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Icon(
                                                snapshot.data![index].fav
                                                            .toString() ==
                                                        "true"
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: appColorTwo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: height * 0.02,
                            );
                          },
                          itemCount: snapshot.data!.length);
                }
              },
            )
          : FutureBuilder(
              future: categoryProvider.search(
                  type: "${widget.type}",
                  cat: "${widget.cat}",
                  city: "${widget.city}",
                  word: "${widget.word}"),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: appColor,
                  ));
                } else {
                  return snapshot.data!.length == 0
                      ? Center(
                          child: Text(
                          translate(
                            "toast.home_no_product",
                          ),
                          style: TextStyle(color: appColor),
                        ))
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                            id: "${snapshot.data![index].productId}",
                                            location:
                                                "${snapshot.data![index].countryName}",
                                            title:
                                                "${snapshot.data![index].productName}",
                                            image:
                                                "${snapshot.data![index].productImage}",
                                            description:
                                                "${snapshot.data![index].longDescription}",
                                            price:
                                                "${snapshot.data![index].price}",
                                            images: snapshot.data![index].images,
                                            marketName:
                                                "${snapshot.data![index].marketName}",
                                            marketID:
                                                "${snapshot.data![index].marketId}",
                                            marketPhone:
                                                "${snapshot.data![index].marketPhone}",
                                            fav: snapshot.data![index].fav
                                                        .toString() ==
                                                    "true"
                                                ? true
                                                : false,
                                          )));
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                        height: height * 0.3,
                                        color: backGround,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height * 0.1 + 30,
                                              decoration: BoxDecoration(
                                                color: backGround,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.04),
                                                    topLeft: Radius.circular(
                                                        width * 0.04)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${snapshot.data![index].productImage}"),
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment.center),
                                              ),
                                            ),
                                            Container(
                                              height: height * 0.1 + 30,
                                              decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  30),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  30))),
                                              padding: EdgeInsets.only(
                                                  left: width * 0.05,
                                                  right: width * 0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].productName}",
                                                            style: GoogleFonts.cairo(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize:
                                                                    width *
                                                                        0.04),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${snapshot.data![index].price}" +
                                                            translate(
                                                                "store.bound"),
                                                        style:
                                                            GoogleFonts.cairo(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: appColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: appColor,
                                                              ),
                                                              Text(
                                                                "${snapshot.data![index].marketName.toString()}",
                                                                style:
                                                                    GoogleFonts
                                                                        .cairo(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          reView(200, context),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_pin,
                                                            color: appColor,
                                                            size: width * 0.05,
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].countryName}",
                                                            style: GoogleFonts
                                                                .cairo(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: appColor,
                                              ),
                                              padding: EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                translate(
                                                    "store.contact_with_seller"),
                                                style: GoogleFonts.cairo(
                                                    color: appColorTwo,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (Constant.token == null ||
                                                  Constant.token.toString() ==
                                                      "null" ||
                                                  Constant.token.toString() ==
                                                      "") {
                                                showToast(translate(
                                                    "profile.need_to_sign_up"));
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              } else {
                                                await favProvider
                                                    .addToFavourite(
                                                        productID:
                                                            "${snapshot.data![index].productId}",
                                                        context: context)
                                                    .then((value) {
                                                  if (snapshot.data![index].fav
                                                          .toString() ==
                                                      "true") {
                                                    snapshot.data![index].fav =
                                                        "true";
                                                  } else {
                                                    snapshot.data![index].fav =
                                                        "false";
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: appColor,
                                              ),
                                              padding: EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Icon(
                                                snapshot.data![index].fav
                                                            .toString() ==
                                                        "true"
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: appColorTwo,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: height * 0.02,
                            );
                          },
                          itemCount: snapshot.data!.length);
                }
              },
            ),
    );
  }
}
