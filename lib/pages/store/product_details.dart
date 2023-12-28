import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../../elements/drawer.dart';
import '../../elements/fullView.dart';
import '../../elements/review.dart';
import '../../elements/small_Widgets.dart';
import '../../helper/customLaunch.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../../models/sliderModel.dart';
import '../../repository/auth_user.dart';
import '../../repository/categories.dart';
import '../../repository/fav_cart.dart';
import '../chat/chat.dart';
import '../show_on_map.dart';
import '../signing/login_screen.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  String? id, title, image, description, price, marketName, marketID, marketPhone, location, countryName, address_details, rate_value, views, lat, lng;
  bool? fav;
  List<SliderModel>? images;
  ProductDetailsPage({this.id, this.title, this.image, this.description, this.price, this.images, this.marketName, this.marketID, this.marketPhone, this.location, this.fav, this.countryName, this.address_details, this.rate_value, this.views, this.lat, this.lng});
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  SwiperController? _swiperController;
  String? fav;
  int count = 0;
  double priceAfterDiscount = 0.0;
  // ignore: non_constant_identifier_names
  String rate_vaue = "";
  @override
  void initState() {
    _swiperController = SwiperController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var userProfile = Provider.of<UserAuth>(context, listen: false);
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    var favUser = Provider.of<FavAndCart>(context, listen: false);
    return WillPopScope(
        // hurab: i have no idea why Husam disabled back button
        onWillPop: () => Future.value(true),
        child: Scaffold(
          backgroundColor: backGround,
          drawer: drawerWidget(context),
          appBar: PreferredSize(
            child: Container(
              height: height * 0.2,
              alignment: Alignment.center,
              padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: new Padding(
                padding: EdgeInsets.only(top: height * 0.01, right: width * 0.06, left: width * 0.06, bottom: height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     _scaffoldKey.currentState.openDrawer();
                    //   },
                    //   child: Image.asset(
                    //     "assets/images/drawer.png",
                    //     height: height * 0.05,
                    //     width: width * 0.05,
                    //   ),
                    // ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: appColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: [backGround, backGround]),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(height * 0.08),
                    bottomLeft: Radius.circular(height * 0.08),
                  ),
                  boxShadow: [
                    new BoxShadow(
                      color: backGround,
                      blurRadius: 50.0,
                      spreadRadius: 1.0,
                    )
                  ]),
            ),
            preferredSize: new Size(MediaQuery.of(context).size.width, height * 0.06),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.images != null && widget.images!.length != 0
                    ? Container(
                        height: height * 0.3 - 20,
                        width: width,
                        decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(topRight: Radius.circular(22), topLeft: Radius.circular(22))),
                        child: Swiper(
                          controller: _swiperController,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    fullView(context, "${widget.images![index].image}");
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.images![index].image!,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/loading.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    height: height * 0.3 - 20,
                                  ),
                                ),
                                // Text(snapshots.data[index].categoryId)
                              ],
                            );
                          },
                          itemCount: widget.images!.length,
                          pagination: new SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: new DotSwiperPaginationBuilder(color: colorWhite, activeColor: appColorTwo, size: width * 0.04, activeSize: width * 0.04),
                          ),
                          control: new SwiperControl(
                            color: appColorTwo,
                            disableColor: colorWhite,
                            size: 0.0,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          fullView(context, "${widget.image}");
                        },
                        child: Container(
                          height: height * 0.3 - 20,
                          width: width,
                          child: widget.image.toString() == "null" ? Image.asset("assets/images/home_1.png") : Image.network("${widget.image}"),
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                  padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
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
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              "${widget.title.toString().replaceAll("null", "").toString()}",
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: width * 0.05),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (widget.price.toString().trim() != "null")
                            Text(
                              "${widget.price}" + translate("store.bound"),
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor, fontSize: width * 0.05),
                            ),
                          Spacer(),
                          if (widget.marketName.toString().trim() != "null")
                            GestureDetector(
                              onTap: () async {
                                if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                                  SmallWidgets.shouldBeRegister(context);
                                } else {
                                  await favUser.addToFavourite(productID: "${widget.id}", context: context, favOrDis: widget.fav.toString().trim() == "true" ? "false" : "true").then((value) {
                                    if (widget.fav.toString().trim() == "true") {
                                      setState(() {
                                        widget.fav = false;
                                      });
                                    } else {
                                      setState(() {
                                        widget.fav = true;
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
                                  widget.fav == true ? Icons.favorite : Icons.favorite_border,
                                  color: appColorTwo,
                                ),
                              ),
                            )
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12),
                                if (widget.marketName.toString().trim() != "null")
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person, color: appColor),
                                        Expanded(
                                          child: Text(
                                            "${widget.marketName.toString().replaceAll("null", "").toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 4),
                                            GestureDetector(
                                                onTap: () {
                                                  reportUser(height: height, width: width, userProfile: userProfile);
                                                },
                                                child: Icon(Icons.report, color: Colors.orange)),
                                            SizedBox(width: 16),
                                            GestureDetector(
                                                onTap: () {
                                                  blockUser(height: height, width: width, userProfile: userProfile);
                                                },
                                                child: Icon(Icons.block, color: Colors.redAccent)),
                                            SizedBox(width: 4),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                if (widget.location.toString().trim() != "null")
                                  GestureDetector(
                                    onTap: () {
                                      print("lat: " + widget.lat.toString());
                                      print("lng: " + widget.lng.toString());
                                      if (widget.lat != null) {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ShowOnMapPage(
                                                  latitude: widget.lat.toString(),
                                                  longitude: widget.lng.toString(),
                                                  justDisPlay: true,
                                                )));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: appColor,
                                          size: width * 0.05,
                                        ),
                                        Text(
                                          "${widget.countryName.toString().replaceAll("null", "").toString()} - ${widget.location} ",
                                          style: GoogleFonts.cairo(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.views.toString() != "null")
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: appColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text("${widget.views}"),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      widget.marketName.toString().trim() == "null"
                          ? Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: appColor,
                                  size: width * 0.05,
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text(
                                  "${widget.marketPhone}",
                                  style: GoogleFonts.cairo(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      widget.address_details.toString().trim() != "null"
                          ? Column(
                              children: [
                                Text(
                                  translate("store.address_details"),
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor, fontSize: width * 0.05),
                                ),
                                Text(
                                  "${widget.address_details.toString()}",
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: width * 0.04),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        translate("store.product_details"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor, fontSize: width * 0.05),
                      ),
                      Text(
                        "${widget.description.toString()}",
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      widget.rate_value.toString().trim() != "null"
                          ? Column(
                              children: [
                                Text(translate("store.rate")),
                                reView(int.parse(widget.rate_value.toString()), context),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
                          ? Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: width * 0.08,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      rate_vaue = rating.toString();
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: width * 0.09,
                                ),
                                Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == ""
                                    ? SizedBox()
                                    : GestureDetector(
                                        onTap: () async {
                                          if (rate_vaue != "") {
                                            await favUser.productRate(productID: "${widget.id}", rate_value: "$rate_vaue", kind: widget.marketName.toString().trim() != "null" ? "rate_product" : "rate_game_Club");
                                          } else {
                                            showToast(translate("toast.enter_rate"));
                                          }
                                        },
                                        child: Card(
                                          elevation: 4,
                                          clipBehavior: Clip.hardEdge,
                                          child: Container(
                                            decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(40)),
                                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                                            child: Text(
                                              translate("store.do_rate"),
                                              style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                                  SmallWidgets.shouldBeRegister( context);
                                } else {
                                  await categoryProvider.addPhoneCounter(context: context, productID: widget.id.toString(), salesID: widget.marketID.toString()).then((value) {
                                    customLaunch("tel:+20${widget.marketPhone}");
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: appColor,
                                ),
                                padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                                child: Text(
                                  widget.marketName.toString().trim() != "null" ? translate("store.contact_with_seller") : translate("store.contact"),
                                  style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
                              ? Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                                saller_id: "${widget.marketID.toString()}",
                                                saller_name: "${widget.marketName.toString()}",
                                                kind_room: "saller_id",
                                              )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: appColorTwo,
                                      ),
                                      padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                                      child: Text(
                                        translate("chat.chat"),
                                        style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      //Report or block
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              reportItem(
                                height: height,
                                width: width,
                                userProfile: userProfile,
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.report, color: Colors.orange, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  translate("store.report"),
                                  style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              blockUser(
                                height: height,
                                width: width,
                                userProfile: userProfile,
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.block, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  translate("store.block_all_ads_from_this_user"),
                                  style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                                ),
                              ],
                            ),
                          ),
                        
                          GestureDetector(
                            onTap: () {
                              hideAd(
                                height: height,
                                width: width,
                                userProfile: userProfile,
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.warning, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  translate("store.hide_ad"),
                                  style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                widget.marketName.toString().trim() != "null"
                    ? Column(
                        children: [
                          Align(
                            alignment: Constant.lang == "ar" ? Alignment.topRight : Alignment.topLeft,
                            child: Text(
                              translate("store.another_ads") + " ${widget.marketName} ",
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: width * 0.04 - 2),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.2 + 40,
                            width: width,
                            padding: EdgeInsets.only(left: Constant.lang == "ar" ? 0 : width * 0.01 + 1, right: Constant.lang == "ar" ? width * 0.01 + 1 : 0),
                            child: FutureBuilder(
                              future: categoryProvider.adsSales("${widget.marketID}"),
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
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => ProductDetailsPage(
                                                            id: "${snapshot.data![index].productId}",
                                                            location: "${snapshot.data![index].countryName}",
                                                            title: "${snapshot.data![index].productName}",
                                                            image: "${snapshot.data![index].productImage}",
                                                            description: "${snapshot.data![index].longDescription}",
                                                            price: "${snapshot.data![index].price}",
                                                            images: snapshot.data![index].images,
                                                            marketName: "${snapshot.data![index].marketName}",
                                                            marketID: "${snapshot.data![index].marketId}",
                                                            marketPhone: "${snapshot.data![index].marketPhone}",
                                                            fav: snapshot.data![index].fav.toString() == "true" ? true : false,
                                                          )));
                                                },
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                        width: width * 0.5,
                                                        height: height * 0.3,
                                                        padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment.center,
                                                              height: height * 0.1 + 20,
                                                              width: width * 0.5,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                                  image: DecorationImage(
                                                                    image: NetworkImage(
                                                                      "${snapshot.data![index].productImage}",
                                                                    ),
                                                                    fit: BoxFit.cover,
                                                                  )),
                                                            ),
                                                            // CachedNetworkImage(
                                                            //   fit: BoxFit.cover,
                                                            //   alignment: Alignment.center,
                                                            //   height: height*0.1+20,
                                                            //   width: width * 0.5,
                                                            //   imageUrl:
                                                            //   "${snapshot.data[index].productImage}",
                                                            //   placeholder: (context, url) =>
                                                            //       Image.asset(
                                                            //         'assets/images/loading.gif',
                                                            //         fit: BoxFit.cover,
                                                            //       ),
                                                            //   errorWidget:
                                                            //       (context, url, error) =>
                                                            //       Icon(Icons.error),
                                                            // ),
                                                            Container(
                                                              color: colorWhite,
                                                              height: height * 0.09,
                                                              padding: EdgeInsets.all(4),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "${snapshot.data![index].productName}",
                                                                        style: GoogleFonts.cairo(fontSize: width * 0.03 + 2, color: Colors.black45, fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        "${snapshot.data![index].price}" + translate("store.bound"),
                                                                        style: GoogleFonts.cairo(
                                                                          color: appColor,
                                                                          fontSize: width * 0.03,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.person,
                                                                            size: width * 0.04,
                                                                          ),
                                                                          SizedBox(
                                                                            width: width * 0.2,
                                                                            child: Text(
                                                                              "${snapshot.data![index].marketName}",
                                                                              style: GoogleFonts.cairo(fontSize: width * 0.03 + 2, color: Colors.black45, fontWeight: FontWeight.bold),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.location_pin,
                                                                            size: width * 0.04,
                                                                          ),
                                                                          Text(
                                                                            "${snapshot.data![index].countryName}",
                                                                            style: GoogleFonts.cairo(fontSize: width * 0.03 + 2, color: Colors.black45, fontWeight: FontWeight.bold),
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
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            width: width * 0.2 - 17,
                                                            height: height * 0.04 + 6,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(30),
                                                              color: appColor,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    snapshot.data![index].fav == "true" ? Icons.favorite : Icons.favorite_border,
                                                                    color: appColorTwo,
                                                                    size: width * 0.06 + 2,
                                                                  ),
                                                                  onPressed: () async {
                                                                    if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                                                                      showToast(translate("profile.need_to_sign_up"));
                                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                                                    } else {
                                                                      await favUser.addToFavourite(productID: "${snapshot.data![index].productId}", context: context).then((value) {
                                                                        if (snapshot.data![index].fav.toString() == "true") {
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.05,
                                                          ),
                                                          Container(
                                                              width: width * 0.2,
                                                              height: height * 0.05 - 1,
                                                              padding: EdgeInsets.only(top: height * 0.01 - 3),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(30),
                                                                color: appColor,
                                                              ),
                                                              child: Text(
                                                                translate("store.contact"),
                                                                style: TextStyle(color: appColorTwo),
                                                                textAlign: TextAlign.center,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              width: width * 0.05,
                                            );
                                          },
                                          itemCount: snapshot.data!.length);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          ),
        ));
  }

  void reportItem({
     double? height,
     double? width,
     UserAuth? userProfile,
  }) {
    //show dialog with input message
    TextEditingController reportController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: height! * 0.02),
                  Text(
                    translate("store.report"),
                    style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width! * 0.05),
                  ),
                  SizedBox(height: height! * 0.02),
                  Container(
                    width: width! * 0.8,
                    child: TextField(
                      controller: reportController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: translate("store.report_hint"),
                        hintStyle: GoogleFonts.cairo(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
                    onTap: () async {
                      if (reportController.text.toString().trim() != "") {
                        userProfile!.reportProduct(
                          context: context,
                          productId: widget.id.toString(),
                          message: reportController.text.toString().trim(),
                        );
                        showToast(translate("store.report_sent"));
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                      } else {
                        showToast(translate("store.enter_report"));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColor,
                      ),
                      padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                      child: Text(
                        translate("store.send"),
                        style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void reportUser({
    @required double? height,
    @required double? width,
    @required UserAuth? userProfile,
  }) {
    //show dialog with input message
    TextEditingController reportController = TextEditingController();
    String? reportType;
    List<String>? reportTypesList = [translate("store.bad_content"), translate("store.frogery"), translate("store.spam"), translate("store.other")];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: height! * 0.02),
                  Text(
                    translate("store.report_user"),
                    style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width! * 0.05),
                  ),
                  SizedBox(height: height * 0.02),
                  //Radio group (bad content - frogery - spam)
                  ...reportTypesList.map((e) {
                    return RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      value: e,
                      groupValue: reportType,
                      onChanged: (String? value) {
                        setState(() {
                          reportType = value!;
                        });
                      },
                      title: Text(
                        e,
                        style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width! * 0.04),
                      ),
                    );
                  }).toList(),
                

                  Container(
                    width: width! * 0.8,
                    child: TextField(
                      controller: reportController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: translate("store.report_hint"),
                        hintStyle: GoogleFonts.cairo(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
                    onTap: () async {
                      if (reportController.text.toString().trim() != "") {
                        userProfile!.reportProduct(
                          context: context,
                          productId: widget.id.toString(),
                          message: reportController.text.toString().trim()+" "+"$reportType",
                        );
                        showToast(translate("store.report_sent"));
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        showToast(translate("store.enter_report"));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColor,
                      ),
                      padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                      child: Text(
                        translate("store.send"),
                        style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold, fontSize: width! * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void blockUser({
    @required double? height,
    @required double? width,
    @required UserAuth? userProfile,
  }) {
    //Show dialog confirm
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text(
                    translate("store.block_all_ads_from_this_user"),
                    style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width! * 0.05),
                  ),
                  SizedBox(height: height! * 0.02),
                  GestureDetector(
                    onTap: () async {
                      userProfile!.blockUser(
                        context: context,
                        productId: widget.id.toString(),
                      );
                      showToast(translate("store.blocked_successfully"));
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColor,
                      ),
                      padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                      child: Text(
                        translate("store.block"),
                        style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void hideAd({
    @required double? height,
    @required double? width,
    @required UserAuth? userProfile,
  }) {
    //Show dialog confirm
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text(
                    translate("store.hide_ad"),
                    style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width! * 0.05),
                  ),
                  SizedBox(height: height! * 0.02),
                  GestureDetector(
                    onTap: () async {
                      userProfile!.blockUser(
                        context: context,
                        productId: widget.id.toString(),
                        type:"hide",

                      );
                      showToast(translate("store.hidden_successfully"));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColor,
                      ),
                      padding: EdgeInsets.only(right: 22, left: 22, top: 6, bottom: 10),
                      child: Text(
                        translate("store.hide_ad"),
                        style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
