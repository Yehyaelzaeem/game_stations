import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../elements/PermissionDeniedWidget.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../../repository/categories.dart';
import '../../repository/fav_cart.dart';
import '../store/product_details.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  ScrollController? myScrollController;
  @override
  void initState() {
    myScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var favProvider = Provider.of<FavAndCart>(context);
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backGround,
      body:
      Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
          ?
      SingleChildScrollView(
              child: Column(
                children: [
                  // globalHeader(context, translate("favourite.title")),
                  // SizedBox(height: height*0.02,),

                  Container(
                    height: height * 0.7 - 30,
                    width: width,
                    child: FutureBuilder(
                      future: favProvider.getFavProducts(),
                      builder: (context, AsyncSnapshot<List<ProductDetails>> snapshot) {
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
                                        onTap: () async {
                                          await categoryProvider.getProductDetails(snapshot.data![index].productId!).then((value) {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ProductDetailsPage(
                                                      id: "${snapshot.data![index].productId}",
                                                      location: "${snapshot.data![index].countryName}",
                                                      title: "${snapshot.data![index].productName}",
                                                      image: "${snapshot.data![index].productImage}",
                                                      price: "${snapshot.data![index].price}",
                                                      rate_value: "${snapshot.data![index].rate_value}",
                                                      images: value.first.images,
                                                      views: "${value.first.views}",
                                                      description: "${value.first.longDescription}",
                                                      marketName: "${value.first.marketName}",
                                                      marketID: "${value.first.marketId}",
                                                      marketPhone: "${value.first.marketPhone}",
                                                      fav: value.first.fav.toString() == "true" ? true : false,
                                                    )));
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Container(
                                                height: height * 0.3 - 10,
                                                color: backGround,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: height * 0.1 + 20,
                                                      decoration: BoxDecoration(
                                                        color: backGround,
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(width * 0.04), topLeft: Radius.circular(width * 0.04)),
                                                        image: DecorationImage(image: NetworkImage("${snapshot.data![index].productImage}"), fit: BoxFit.contain, alignment: Alignment.center),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.1 + 30,
                                                      decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
                                                      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height * 0.02,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${snapshot.data![index].productName}",
                                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: width * 0.04),
                                                              ),
                                                              Text(
                                                                "${snapshot.data![index].price}" + translate("store.bound"),
                                                                style: GoogleFonts.cairo(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: appColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.category,
                                                                    color: appColor,
                                                                  ),
                                                                  Text(
                                                                    "${snapshot.data![index].categoryName}",
                                                                    style: GoogleFonts.cairo(
                                                                      color: Colors.grey,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Icon(
                                                                    Icons.location_pin,
                                                                    color: appColor,
                                                                    size: width * 0.05,
                                                                  ),
                                                                  Text(
                                                                    "${snapshot.data![index].countryName}",
                                                                    style: GoogleFonts.cairo(
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
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
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: appColor,
                                                      ),
                                                      padding: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
                                                      child: Text(
                                                        translate("store.contact_with_seller"),
                                                        style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await favProvider.addToFavourite(productID: "${snapshot.data![index].productId}", context: context).then((value) {
                                                        if (snapshot.data![index].fav.toString().trim() == "true") {
                                                          setState(() {
                                                            snapshot.data![index].fav = "false";
                                                          });
                                                        } else {
                                                          setState(() {
                                                            snapshot.data![index].fav = "true";
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: appColor,
                                                      ),
                                                      padding: EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
                                                      child: Icon(
                                                        Icons.favorite,
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
                  ),
                ],
              ),
            )
          : PermissionDeniedWidget(),
    );
  }
}
