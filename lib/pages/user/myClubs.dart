import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_translate/global.dart';
import '../../elements/review.dart';
import '../../helper/showtoast.dart';
import '../../models/ProductDetails.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'edit_game_club.dart';

class MyClubs extends StatefulWidget {
  @override
  _MyClubsState createState() => _MyClubsState();
}

class _MyClubsState extends State<MyClubs> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: appColor, opacity: 12, size: 25),
        backgroundColor: colorWhite,
        title: Text(
          translate("profile.my_clubs"),
          style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:
      FutureBuilder(
        future: Provider.of<CategoriesProvider>(context, listen: false).getGamesClub(checkAuthClubs: true),
        builder:
            (context, AsyncSnapshot snapshot) {
          if (snapshot!.data == null) {
            return Center(child: Text(""));
          }
          else {
            return snapshot.data!.length == 0
                ? Center(
                child: Text(
                  translate("profile.no_data"),
                  style: TextStyle(color: appColor),
                ))
                : Container(
              height: height,
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: height * 0.1 + 36,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: colorWhite),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  snapshot.data![index].images!.length == 0
                                      ?
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 2, color: appColor),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/home_1.png",
                                          ),
                                        ),
                                      ),
                                      width: width * 0.1 + 5,
                                      height: height * 0.05 + 2):
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 2, color: appColor),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "${snapshot.data![index].images!.first.image}",
                                          ),
                                        ),
                                      ),
                                      width: width * 0.1 + 5,
                                      height: height * 0.05 + 2),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data![index].productName}",
                                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: width * 0.04 + 2),
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
                                            style: GoogleFonts.cairo(
                                              color: Colors.black38,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * 0.01),
                                      snapshot.data![index].rate_value.toString() != "null" ? reView(int.parse(snapshot.data![index].rate_value.toString()), context) : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: appColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => EditGameClubPage(
                                            title: "${snapshot.data![index].productName}",
                                            id: "${snapshot.data![index].productId}",
                                            lat: "${snapshot.data![index].lat}",
                                            lng: "${snapshot.data![index].lng}",
                                            description: "${snapshot.data![index].longDescription}",
                                            address: "${snapshot.data![index].address_details.toString().replaceAll("null", "")}",
                                            city_id: "${snapshot.data![index].city_id}",
                                            state_id: "${snapshot.data![index].state_id}",
                                            country_id: "${snapshot.data![index].country_id}",
                                            imageOne: "${snapshot.data![index].images!.first.image}",
                                            imgID: "${snapshot.data![index].images!.first.id}",
                                            images: snapshot.data![index].images,
                                            phone: "${snapshot.data![index].marketPhone}",
                                          )));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      accessProduct(context, "${snapshot.data![index].productId}");
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height * 0.02);
                  },
                  itemCount: snapshot.data!.length),
            );
          }
        },
      ),
    );
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
            style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.bold, color: colorWhite),
          ),
          onPressed: () async {
            await removeProduct.removeGameClub(context: context, productID: "$productID").then((value) {
              showToast(translate("store.remove_uploaded_product"));
              Timer(Duration(seconds: 1), () {
                setState(() {});
              });
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
