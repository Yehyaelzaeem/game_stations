import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../elements/small_Widgets.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../root_pages.dart';
import 'edit_ads.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({Key? key}) : super(key: key);

  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      body:
      Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height * 0.06 + 4,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.04),
                    color: colorWhite,
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: new TabBar(
                        controller: _tabController,
                        tabs: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              translate("store.active_ads"),
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              translate("store.expired_ads"),
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        isScrollable: true,
                        indicatorColor: appColor,
                        labelColor: appColor,
                        unselectedLabelColor: Colors.black54,
                        unselectedLabelStyle:
                            TextStyle(color: colorDark, fontSize: 18),
                        labelStyle: TextStyle(color: colorDark, fontSize: 18),
                        labelPadding: EdgeInsets.only(left: 4.5, right: 4.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.7 - 35,
                    width: width,
                    color: backGround,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        setAdsKindWidget(height, width, context, "new_ads"),
                        setAdsKindWidget(height, width, context, "old_ads"),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : PermissionDeniedWidget(),
    );
  }

  Widget setAdsKindWidget(
      double height, double width, BuildContext context, String adsKind) {
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Container(
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: categoryProvider.getMyAds('$adsKind'),
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
                      "toast.home_no_ads",
                    ),
                    style: TextStyle(color: appColor),
                  ))
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.separated(
                        reverse: true,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                  height: height * 0.3 + 65,
                                  color: backGround,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.1 + 20,
                                        decoration: BoxDecoration(
                                          color: backGround,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  width * 0.1 + 20),
                                              topLeft: Radius.circular(
                                                  width * 0.1 + 20)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "${snapshot.data![index].productImage}"),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.2 + 15,
                                        decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(30))),
                                        padding: EdgeInsets.only(
                                            left: width * 0.05,
                                            right: width * 0.05),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].productName}",
                                                  style: GoogleFonts.cairo(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: width * 0.04),
                                                ),
                                                Text(
                                                  "${snapshot.data![index].price}" +
                                                      translate("store.bound"),
                                                  style: GoogleFonts.cairo(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: appColor,
                                                      fontSize: width * 0.04),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.date_range,
                                                  color: appColor,
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                Text(
                                                  "${snapshot.data![index].date}",
                                                  style: GoogleFonts.cairo(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: appColor),
                                                ),
                                                // SizedBox(width: width*0.02,),
                                                // Text("30 ابريل 2021",style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                                //     color: Colors.grey),),
                                                // // SizedBox(width: width*0.02,),
                                                // // Text(translate("store.to"),
                                                // //   style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                                // //       color: appColor),),
                                                // // SizedBox(width: width*0.02,),
                                                // // Text("20 ابريل 2021",style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                                // //     color: Colors.grey),),
                                              ],
                                            ),
                                            Divider(
                                              thickness: width * 0.01 - 1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SmallWidgets.adsActivities(
                                                    height,
                                                    width,
                                                    translate("store.watch"),
                                                    "${snapshot.data![index].views.toString()}"),
                                                // SmallWidgets.adsActivities(height, width, translate("store.phone"), "${snapshot.data[index].phone_counter.toString()}"),
                                                SmallWidgets.adsActivities(
                                                    height,
                                                    width,
                                                    translate("store.fav"),
                                                    "${snapshot.data![index].count_pro_fav.toString()}"),
                                                SmallWidgets.adsActivities(
                                                    height,
                                                    width,
                                                    translate("store.do_rate"),
                                                    "0"),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // GestureDetector(
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(100),
                                    //       color: appColor,
                                    //     ),
                                    //     padding: EdgeInsets.only(right: 20,left: 20,top: 5,bottom: 5),
                                    //     child: Text(translate("store.paid_ads"),
                                    //       style: GoogleFonts.cairo(color: appColorTwo,
                                    //           fontWeight: FontWeight.bold),),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: width * 0.06,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: appColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                CupertinoIcons.delete,
                                                color: appColorTwo,
                                                size: width * 0.07,
                                              ),
                                              onPressed: () {
                                                removeAds(
                                                    context,
                                                    width,
                                                    height,
                                                    "${snapshot.data![index].productId}");
                                              },
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                CupertinoIcons.ellipsis,
                                                color: appColorTwo,
                                                size: width * 0.08,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditAdsPage(
                                                              title: snapshot
                                                                  .data![index]
                                                                  .productName,
                                                              imageOne: snapshot
                                                                  .data![index]
                                                                  .productImage,
                                                              description: snapshot
                                                                  .data![index]
                                                                  .longDescription,
                                                              price: snapshot
                                                                  .data![index]
                                                                  .price,
                                                              old: snapshot
                                                                          .data![
                                                                              index]
                                                                          .type ==
                                                                      "old"
                                                                  ? true
                                                                  : false,
                                                              catID: snapshot
                                                                  .data![index]
                                                                  .categoryId,
                                                              id: snapshot
                                                                  .data![index]
                                                                  .productId,
                                                              images: snapshot
                                                                  .data![index]
                                                                  .images,
                                                            )));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: height * 0.03,
                          );
                        },
                        itemCount: snapshot.data!.length),
                  );
          }
        },
      ),
    );
  }

  removeAds(
      BuildContext context, double width, double height, String productID) {
    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (ctx) {
          return ButtonBarTheme(
            data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
            child: AlertDialog(
              title: Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        translate("store.delete_ads"),
                        style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold, color: appColor),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: appColor.withOpacity(0.2)),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          color: appColor,
                        ),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await categoryProvider
                              .removeAds(context: context, productID: productID)
                              .then((value) {
                            Navigator.of(ctx).pop();
                            if (value.toString() == "deleted") {
                              showToast(
                                  translate("store.remove_uploaded_product"));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RootPages(
                                        checkPage: "3",
                                      )));
                            }
                          });
                        },
                        child: Text(
                          translate("button.ok"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, color: appColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          translate("button.cancel"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, color: appColor),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          );
        });
  }
}
