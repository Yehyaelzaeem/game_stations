import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../elements/AlertPopUp.dart';
import '../../elements/drawer.dart';
import '../../elements/review.dart';
import '../../elements/small_Widgets.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/customLaunch.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../../models/sliderModel.dart';
import '../../repository/categories.dart';
import '../../repository/fav_cart.dart';
import 'product_details.dart';

// ignore: must_be_immutable
class ProductsPage extends StatefulWidget {
  String? categoryTitle, catID;
  ProductsPage({this.categoryTitle, this.catID});
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    print('product title ****************************: ${widget.categoryTitle}');
    print('catID title *******************************: ${widget.catID}');
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsStatus = _getDropDownMenuItemsStatus();
    setState(() {
      showAds = true;
    });
    Timer(Duration(seconds: 40), () {
      if (showAds == true) {
        if (Constant.subscribe != true) {
          getPopUp().then((value) async {
            if (value != null && value.image.toString().trim() != "null") {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await showAlertDialogPopUp(
                  context,
                  img: value.image.toString(),
                  link: value.link.toString(),
                );
                setState(() {
                  showAds = false;
                });
              });
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    var favProvider = Provider.of<FavAndCart>(context, listen: false);
    return Scaffold(
      backgroundColor: backGround,
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            globalHeader(context, widget.categoryTitle != null ? widget.categoryTitle.toString() : "أجهزة بلايستيشن"),
            SizedBox(height: 16),
            Align(
              alignment: Constant.lang == "ar" ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: appColor),
                child: Text(
                  translate("store.filter"),
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: width * 0.03 + 2),
                ),
              ),
            ),
            SizedBox(height: 16),

            Container(
              width: width - 10,
              height: height * 0.06,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: colorWhite),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = false;
                        city = true;
                        kind = false;
                        dept = false;
                      });
                    },
                    child: Container(
                      width: width * 0.3 - 20,
                      padding: EdgeInsets.only(left: 3, right: width * 0.03 - 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: city == true ? backGround : colorWhite),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          style: new TextStyle(color: appColor, fontSize: width * 0.03 + 1),
                          value: _statusSelCityKind,
                          items: _dropDownMenuItemsCityKind,
                          hint: Text(translate("store.city"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 1)),
                          onChanged: (String? selectedItem) {
                            setState(() {
                              categoryProvider.cityIDSearch = selectedItem!;
                              _statusSelCityKind = selectedItem;
                              print("cityy: " + _statusSelCityKind!);
                              _statusSelStatus = "0";
                            });
                          },
                          icon: new Icon(Icons.keyboard_arrow_down),
                          onTap: () {
                            setState(() {
                              status = false;
                              city = true;
                              kind = false;
                              dept = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        status = true;
                        city = false;
                        kind = false;
                        dept = false;
                      });
                    },
                    child: Container(
                      width: width * 0.2 + 10,
                      padding: EdgeInsets.only(left: 3, right: width * 0.03 - 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: status == true ? backGround : colorWhite),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          style: new TextStyle(color: appColor, fontSize: width * 0.03 + 1),
                          value: _statusSelStatus,
                          items: _dropDownMenuItemsStatus,
                          hint: Text(
                            translate("store.status"),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 1),
                          ),
                          onChanged: (String? selectedItem) {
                            setState(() {
                              categoryProvider.typeIDSearch = selectedItem!;
                              _statusSelStatus = selectedItem;
                              print(_statusSelStatus);
                            });
                          },
                          icon: new Icon(Icons.keyboard_arrow_down),
                          onTap: () {
                            setState(() {
                              status = true;
                              city = false;
                              kind = false;
                              dept = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: height * 0.8 - 30,
              width: width - 30,
              child: FutureBuilder(
                future: _statusSelCityKind == null
                    ? categoryProvider.getProducts("${widget.catID}", "${widget.categoryTitle}")
                    : categoryProvider.getProducts("${widget.catID}", "${widget.categoryTitle}", type: "$_statusSelStatus", city: "$_statusSelCityKind", insideDept: true),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator(backgroundColor: appColor));
                  } else {
                    return snapshot.data!.length == 0
                        ? Center(child: Text(translate("toast.home_no_product"), style: TextStyle(color: appColor)))
                        : ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return index == 1 || index == 4
                                  ? Column(
                                      children: [
                                        Constant.freeAds.value != null && Constant.freeAds.value.length != 0
                                            ? ValueListenableBuilder(
                                                valueListenable: Constant.freeAds,
                                                builder: (context, List<SliderModel> value, child) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      customLaunch(index == 1 ? "${value.first.link}" : "${value.last.link}");
                                                    },
                                                    child: Image.network(
                                                      index == 1 ? "${value.first.image}" : "${value.last.image}",
                                                      height: height * 0.1 + 30,
                                                      width: width,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  );
                                                },
                                              )
                                            : SizedBox(),

                                        SizedBox(height: 8),
                                        GestureDetector(
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
                                                        lat: "${snapshot.data![index].lat}",
                                                        lng: "${snapshot.data![index].lng}",
                                                        fav: value.first.fav.toString() == "true" ? true : false,
                                                      )));
                                            });
                                          },
                                          child: Container(
                                              height: height * 0.3 - 30,
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: height * 0.3 - 5,
                                                    width: width * 0.3 ,
                                                    decoration: BoxDecoration(
                                                      color: backGround,
                                                      borderRadius: BorderRadius.circular(20),
                                                      image: DecorationImage(image: NetworkImage("${snapshot.data![index].productImage}"), fit: BoxFit.cover, alignment: Alignment.center),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.3,
                                                    width: width * 0.6,
                                                    decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                                    padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
                                                    child: FittedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height * 0.02,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 200,
                                                                height: 70,
                                                                child: AutoSizeText(
                                                                  "${snapshot.data![index].productName}",
                                                                  maxLines: 2,
                                                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
                                                                ),
                                                              ),
                                                              SizedBox(width: 5),
                                                              SizedBox(
                                                                width: width * 0.1,
                                                                child: snapshot.data![index].special == "true"
                                                                    ? Text(
                                                                        translate("store.special"),
                                                                        style: GoogleFonts.cairo(color: appColorTwo),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      )
                                                                    : Text(""),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].price}" + translate("store.bound"),
                                                            style: GoogleFonts.cairo(
                                                              fontWeight: FontWeight.bold,
                                                              color: appColor,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.person, color: appColor),
                                                              SizedBox(width: width * 0.5, child: Text("${snapshot.data![index].marketName.toString()}", style: GoogleFonts.cairo(color: Colors.grey))),
                                                            ],
                                                          ),
                                                          snapshot.data![index].rate_value.toString() != "null" ? reView(int.parse(snapshot.data![index].rate_value.toString()), context) : SizedBox(),
                                                          Row(
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
                                                          SizedBox(height: 8),
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
                                                                    padding: EdgeInsets.only(right: 10, left: 10, top: 3, bottom: 3),
                                                                    child: Text(
                                                                      translate("store.contact_with_seller"),
                                                                      style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width * 0.01,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                                                                      SmallWidgets.shouldBeRegister( context);
                                                                    } else {
                                                                      await favProvider
                                                                          .addToFavourite(
                                                                              productID: "${snapshot.data![index].productId}",
                                                                              context: context,
                                                                              favOrDis: snapshot.data![index].fav.toString().trim() == "true" ? "false" : "true")
                                                                          .then((value) {
                                                                        setState(() {
                                                                          snapshot.data![index].fav = value.toString().trim();
                                                                        });
                                                                        // if(snapshot.data[index].fav.toString().trim()=="false"){
                                                                        //   setState(() {
                                                                        //     snapshot.data[index].fav="false";
                                                                        //   });
                                                                        // }else{
                                                                        //   if(value.toString().trim()=="true"){
                                                                        //     setState(() {
                                                                        //       snapshot.data[index].fav="true";
                                                                        //     });
                                                                        //   }
                                                                        // }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(100),
                                                                      color: appColor,
                                                                    ),
                                                                    padding: EdgeInsets.only(right: 12, left: 12, top: 5, bottom: 5),
                                                                    child: Icon(
                                                                      snapshot.data![index].fav.toString() == "true" ? Icons.favorite : Icons.favorite_border,
                                                                      color: appColorTwo,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
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
                                                    lat: "${snapshot.data![index].lat}",
                                                    lng: "${snapshot.data![index].lng}",
                                                    fav: value.first.fav.toString() == "true" ? true : false,
                                                  )));
                                        });
                                      },
                                      child: Container(
                                          height: height * 0.3 - 30,
                                          decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: height * 0.3 - 5,
                                                width: width * 0.3 ,
                                                decoration: BoxDecoration(
                                                  color: backGround,
                                                  borderRadius: BorderRadius.circular(20),
                                                  image: DecorationImage(image: NetworkImage("${snapshot.data![index].productImage}"), fit: BoxFit.cover, alignment: Alignment.center),
                                                ),
                                              ),
                                              Container(
                                                height: height * 0.3,
                                                width: width * 0.6,
                                                decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                                padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
                                                child: FittedBox(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            height: 70,
                                                            child: AutoSizeText(
                                                              "${snapshot.data![index].productName}",
                                                              maxLines: 2,
                                                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          SizedBox(
                                                            width: width * 0.1,
                                                            child: snapshot.data![index].special == "true"
                                                                ? Text(
                                                                    translate("store.special"),
                                                                    style: GoogleFonts.cairo(color: appColorTwo),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  )
                                                                : Text(""),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${snapshot.data![index].price}" + translate("store.bound"),
                                                        style: GoogleFonts.cairo(
                                                          fontWeight: FontWeight.bold,
                                                          color: appColor,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.person, color: appColor),
                                                          SizedBox(
                                                              width: width * 0.5,
                                                              child: Text(
                                                                "${snapshot.data![index].marketName.toString()}",
                                                                style: GoogleFonts.cairo(
                                                                  color: Colors.grey,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      snapshot.data![index].rate_value.toString() != "null" ? reView(int.parse(snapshot.data![index].rate_value.toString()), context) : SizedBox(),
                                                      Row(
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
                                                      SizedBox(height: 8),
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
                                                                padding: EdgeInsets.only(right: 10, left: 10, top: 3, bottom: 3),
                                                                child: Text(
                                                                  translate("store.contact_with_seller"),
                                                                  style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                                                                  SmallWidgets.shouldBeRegister(context);
                                                                } else {
                                                                  await favProvider
                                                                      .addToFavourite(
                                                                          productID: "${snapshot.data![index].productId}",
                                                                          context: context,
                                                                          favOrDis: snapshot.data![index].fav.toString().trim() == "true" ? "dis" : "fav")
                                                                      .then((value) {
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
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(100),
                                                                  color: appColor,
                                                                ),
                                                                padding: EdgeInsets.only(right: 12, left: 12, top: 5, bottom: 5),
                                                                child: Icon(
                                                                  snapshot.data![index].fav.toString() == "true" ? Icons.favorite : Icons.favorite_border,
                                                                  color: appColorTwo,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 16);
                            },
                            itemCount: snapshot.data!.length);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool dept = true;
  bool city = false;
  bool kind = false;
  bool status = false;
  List<DropdownMenuItem<String>>? _dropDownMenuItemsCityKind;
  String? _statusSelCityKind;
  List<DropdownMenuItem<String>>? _getDropDownMenuItemsCityKind() {
    List<DropdownMenuItem<String>>? itemsCityKind = [];
    for (int i = 0; i < Constant.cities.value.length; i++) {
      itemsCityKind.add(new DropdownMenuItem(
        child: new Text(
          "${Constant.cities.value[i].name}",
          style: GoogleFonts.cairo(
            color: appColor,
          ),
        ),
        value: "${Constant.cities.value[i].name}",
      ));
    }
    return itemsCityKind;
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsStatus;
  String? _statusSelStatus;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsStatus() {
    List<DropdownMenuItem<String>> itemsMarketKind = [];
    itemsMarketKind.add(new DropdownMenuItem(
      child: new Text(
        translate("store.new"),
        style: GoogleFonts.cairo(
          color: appColor,
        ),
      ),
      value: "0",
    ));
    itemsMarketKind.add(new DropdownMenuItem(
      child: new Text(
        translate("store.old"),
        style: GoogleFonts.cairo(
          color: appColor,
        ),
      ),
      value: "1",
    ));
    return itemsMarketKind;
  }
}
