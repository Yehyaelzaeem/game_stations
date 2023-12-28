import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../elements/review.dart';
import '../../elements/small_Widgets.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/customLaunch.dart';
import '../../helper/showtoast.dart';
import '../../models/Categories.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../../repository/auth_user.dart';
import '../../repository/categories.dart';
import '../user/add_games_club.dart';
import 'product_details.dart';

class GameStorePage extends StatefulWidget {
  const GameStorePage({Key? key}) : super(key: key);
  @override
  _GameStorePageState createState() => _GameStorePageState();
}

class _GameStorePageState extends State<GameStorePage> {
  @override
  void initState() {
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    // _dropDownMenuItemsState = _getDropDownMenuItemsState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: height * 0.05),
            globalHeader(context, translate("store.games_club")),
            SizedBox(height: height * 0.01),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddGamesClubPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: appColor,
                ),
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                margin: EdgeInsets.only(
                    right: width * 0.01 + 1, left: width * 0.01 + 1, top: 5),
                child: Text(
                  translate("store.add_club_games"),
                  style: GoogleFonts.cairo(
                      color: appColorTwo,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Align(
              alignment: Constant.lang == "ar"
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: appColor),
                child: Text(
                  translate("store.filter"),
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: colorWhite,
                      fontSize: width * 0.03 + 2),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              width: width - 10,
              height: height * 0.06,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: colorWhite),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        city = true;
                      });
                    },
                    child: Container(
                      width: width * 0.3,
                      padding:
                          EdgeInsets.only(left: 2, right: width * 0.03 - 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: price == true ? backGround : colorWhite),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          style: new TextStyle(
                              color: appColor, fontSize: width * 0.03 + 1),
                          value: _statusSelCityKind,
                          items: _dropDownMenuItemsCityKind,
                          hint: Text(translate("store.city"),
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.03 + 1)),
                          onChanged: _changeDrownItemCityKind,
                          icon: new Icon(Icons.keyboard_arrow_down),
                          onTap: () {
                            setState(() {
                              city = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: width * 0.3,
                      padding: EdgeInsets.only(right: 12, left: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorWhite),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            style: new TextStyle(
                                color: appColor, fontSize: width * 0.03 + 1),
                            value: _statusSelState ?? "0",
                            items: _dropDownMenuItemsState,
                            hint: Text(translate("store.state"),
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.03 + 1)),
                            onChanged: _changeDrownItemState,
                            icon: new Icon(Icons.keyboard_arrow_down),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.7,
              width: width,
              child: FutureBuilder(
                future: _statusSelCityKind != null
                    ? categoryProvider.getGamesClub(
                        checkCity: _statusSelCityKind!,
                        checkState: _statusSelState!)
                    : categoryProvider.getGamesClub(),
                builder:
                    (context, AsyncSnapshot snapshot) {
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
                        : ListView(
                            children: [
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                        id: "${snapshot.data![index].productId}",
                                                        location:
                                                            "${snapshot.data![index].location}",
                                                        title:
                                                            "${snapshot.data![index].productName}",
                                                        image: snapshot
                                                                    .data![index]
                                                                    .images!
                                                                    .length ==
                                                                0
                                                            ? "${snapshot
                                                            .data![index]
                                                            .productImage}"
                                                            : "${snapshot.data![index].images!.first.image}",
                                                        description:
                                                            "${snapshot.data![index].longDescription}",
                                                        countryName:
                                                            "${snapshot.data![index].countryName}",
                                                        address_details:
                                                            "${snapshot.data![index].address_details}",
                                                        rate_value:
                                                            "${snapshot.data![index].rate_value}",
                                                        lat:
                                                            "${snapshot.data![index].lat}",
                                                        lng:
                                                            "${snapshot.data![index].lng}",

                                                        // price: "${sdnapshot.data[index].price}",
                                                        // images: snapshot.data[index].images,
                                                        // marketName: "${snapshot.data[index].marketName}",
                                                        marketID:
                                                            "${snapshot.data![index].marketId}",
                                                        marketPhone:
                                                            "${snapshot.data![index].marketPhone}",
                                                        fav: snapshot
                                                                    .data![index]
                                                                    .fav
                                                                    .toString() ==
                                                                "true"
                                                            ? true
                                                            : false,
                                                      )));
                                        },
                                        child: Container(
                                          height: height * 0.1 + 25,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.04,
                                              vertical: height * 0.01),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: colorWhite),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  snapshot
                                                      .data![index].images!.length ==
                                                      0
                                                      ?
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: appColor),
                                                        image: DecorationImage(
                                                          image:AssetImage(
                                                                  "assets/images/home_1.png",
                                                                )
                                                        ),
                                                      ),
                                                      width: width * 0.1 + 5,
                                                      height:
                                                          height * 0.05 + 2):
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: appColor),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            "${snapshot.data![index].images!.first.image!}",
                                                          ),
                                                        ),
                                                      ),
                                                      width: width * 0.1 + 5,
                                                      height:
                                                          height * 0.05 + 2),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data![index].productName}",
                                                        style: GoogleFonts.cairo(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black54,
                                                            fontSize:
                                                                width * 0.04 +
                                                                    2),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_pin,
                                                            color: appColor,
                                                            size: width * 0.05,
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].location}",
                                                            style: GoogleFonts
                                                                .cairo(
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      snapshot.data![index]
                                                                  .rate_value
                                                                  .toString() !=
                                                              "null"
                                                          ? reView(
                                                              int.parse(snapshot
                                                                  .data![index]
                                                                  .rate_value
                                                                  .toString()),
                                                              context)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (Constant.id != null ||
                                                      Constant.token != null) {
                                                    customLaunch(
                                                        "tel:${snapshot.data![index].marketPhone}");
                                                  } else {
                                                    SmallWidgets
                                                        .shouldBeRegister(context);
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: appColor,
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      right: 16,
                                                      left: 16,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Text(
                                                    translate("store.contact"),
                                                    style: GoogleFonts.cairo(
                                                        color: appColorTwo,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: height * 0.02,
                                    );
                                  },
                                  itemCount: snapshot.data!.length),
                           SizedBox(height: 70)
                            ],
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool price = false;
  bool old_new = false;
  bool status = false;
  bool city = false;
  //drop down
  List<DropdownMenuItem<String>>? _dropDownMenuItemsCityKind;
  String? _statusSelCityKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsCityKind() {
    List<DropdownMenuItem<String>>? itemsCityKind =  [];
    for (int i = 0; i < Constant.cities.value.length; i++) {
      itemsCityKind.add(new DropdownMenuItem(
        child: new Text(
          "${Constant.cities.value[i].name}",
          style: GoogleFonts.cairo(
            color: appColor,
          ),
        ),
        value: "${Constant.cities.value[i].id}",
      ));
    }
    return itemsCityKind;
  }

  void _changeDrownItemCityKind(String? selectedItem) {
    setState(() {
      _dropDownMenuItemsState = [
        DropdownMenuItem(
          child: Text(
            "الحي",
            style: GoogleFonts.cairo(color: appColor),
          ),
          value: "0",
        )
      ];
      _statusSelState = "0";
      _statusSelCityKind = selectedItem;
      print(_statusSelCityKind);
    });
    _getDropDownMenuItemsState(cityID: selectedItem);
  }

  List<DropdownMenuItem<String>> _dropDownMenuItemsState = [];
  String? _statusSelState;

  _getDropDownMenuItemsState({String? cityID}) {
    Provider.of<UserAuth>(context, listen: false)
        .getStates(int.parse(cityID!))
        .then((List<Categories>? value) {
      for (int i = 0; i < value!.length; i++) {
        print("${value!.length} ????????????????");
        setState(() {
          _dropDownMenuItemsState.add(new DropdownMenuItem(
            child: Text(
              "${value[i].name}",
              style: GoogleFonts.cairo(color: appColor),
            ),
            value: "${value[i].id}",
          ));
        });
      }
    });
  }

  void _changeDrownItemState(String? selectedItem) {
    setState(() {
      _statusSelState = selectedItem;
      print("$_statusSelState ::::::::::::::::::::::::::::::::::");
    });
  }

  accessProduct(BuildContext context, String productID) {
    var removeProduct = Provider.of<CategoriesProvider>(context, listen: false);
    AlertDialog alert;
    Widget cancelButton = FloatingActionButton(
      child: Text(
        translate("button.cancel"),
        style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget okButton = new Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FloatingActionButton(
          backgroundColor: appColor,
          child: Text(
            translate("button.ok"),
            style: GoogleFonts.cairo(
                fontSize: 17, fontWeight: FontWeight.bold, color: colorWhite),
          ),
          onPressed: () async {
            await removeProduct
                .removeGameClub(context: context, productID: "$productID")
                .then((value) {
              if (value == "deleted") {
                Navigator.of(context, rootNavigator: true).pop();
                showToast(translate("store.remove_uploaded_product"));
                Timer(Duration(seconds: 2), () {
                  setState(() {});
                });
                Timer(Duration(seconds: 4), () {
                  setState(() {});
                });
              }
            });
          },
        ),
      ),
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text(
        translate("store.delete_ads"),
        style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
