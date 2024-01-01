import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gamestation/pages/single_category_item_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../elements/AlertPopUp.dart';
import '../helper/customLaunch.dart';
import '../helper/device_validation.dart';
import '../helper/showtoast.dart';
import '../models/Categories.dart';
import '../models/Constant.dart';
import '../models/ProductDetails.dart';
import '../repository/auth_user.dart';
import '../repository/categories.dart';
import 'store/game_store.dart';
import 'store/product_details.dart';
import 'store/search.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  SwiperController? _swiperController;
  SwiperController? _swiperControllerBanners;
  List<ProductDetails>? gameClubProducts;
  @override
  void initState() {
    _loading();
    itemKey = GlobalKey();
    scrollController = ScrollController();
    _swiperController = SwiperController();
    _swiperControllerBanners = SwiperController();
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsDeptKind = _getDropDownMenuItemsDeptKind();
    _dropDownMenuItemsStatus = _getDropDownMenuItemsStatus();
    setState(() {
      showAds = true;
    });

    Timer(Duration(seconds: 45), () {
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
  _loading()async{
    await getSlider();
    await getFreeAds();
  }
  GlobalKey? itemKey;
  ScrollController? scrollController;
  GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    var userProvider = Provider.of<UserAuth>(context, listen: false);
    userProvider.getCities();

    categoryProvider.getCategories();
    userProvider.getStates(1);
    print("country: ${Constant.country}");
    if (userProvider.country != null)
      setState(() {
        Constant.country = userProvider.country;
      });
    if (Constant.id != null) {
      if (Constant.subscribe == null) userProvider.userProfile();
      if (Constant.country == null || Constant.country == "null") userProvider.getCountries(false, context);
      // cartUser.getFavProducts();
    }
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backGround,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: Constant.enableFilter,
                builder: (context, value, child) {
                  if (value == true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.9 + 10,
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
                                    city = false;
                                    kind = false;
                                    dept = true;
                                  });
                                },
                                child: Container(
                                  width: 115,
                                  padding: EdgeInsets.only(left: 4, right: 4),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: dept == true ? backGround : colorWhite),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      style: new TextStyle(color: appColor, fontSize: width * 0.03 + 1),
                                      value: _statusSelDeptKind,
                                      items: _dropDownMenuItemsDeptKind,
                                      hint: Text(translate("store.dept"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 1)),
                                      onChanged: (String? selectedItem) {
                                        setState(() {
                                          categoryProvider.catIDSearch = selectedItem!;
                                          _statusSelDeptKind = selectedItem;
                                          print(_statusSelDeptKind);
                                        });
                                      },
                                      icon: new Icon(Icons.keyboard_arrow_down),
                                      onTap: () {
                                        setState(() {
                                          status = false;
                                          city = false;
                                          kind = false;
                                          dept = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
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
                                      hint: FittedBox(child: Text(translate("store.city"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 1))),
                                      onChanged: (String? selectedItem) {
                                        setState(() {
                                          categoryProvider.cityIDSearch = selectedItem!;
                                          _statusSelCityKind = selectedItem;
                                          print(_statusSelCityKind);
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

                              SizedBox(width: 2),
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
                              IconButton(
                                  icon: Icon(Icons.filter_alt_rounded),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              word: "",
                                              type: "${categoryProvider.typeIDSearch}",
                                              cat: "${categoryProvider.catIDSearch}",
                                              city: "${categoryProvider.cityIDSearch}",
                                            )));
                                  })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),

              Container(
                height: height * 0.2 + 30,
                width: width,
                padding: EdgeInsets.zero,
                child: ValueListenableBuilder(
                  valueListenable: Constant.sliders,
                  builder: (context,dynamic value, child) {
                    return Swiper(
                      controller: _swiperController,
                      autoplay: true,
                      autoplayDisableOnInteraction: false,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (value[index].link == "null") {
                              showToast("${value[index].link}");
                            } else {
                              customLaunch("${value[index].link}");
                            }
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              SizedBox(
                                height: height * 0.2 + 22,
                                width: width,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: "${value[index].image}",
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/loading.gif',
                                    fit: BoxFit.fill,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              Text(
                                "${value[index].name}",
                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: width * 0.04),
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Text(snapshots.data[index].categoryId)
                            ],
                          ),
                        );
                      },
                      itemCount: value.length,
                      pagination: new SwiperPagination(
                        alignment: Alignment.bottomCenter,
                      ),
                      control: new SwiperControl(
                        color: appColorTwo,
                        size: 0,
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  FutureBuilder(
                    future: categoryProvider.getCategories(
                      notCheck: "not",
                      startFromIndex: 0,
                      itemsLength: 1,
                    ),
                    builder: (context, AsyncSnapshot<List<Categories>> snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: appColor,
                        ));
                      } else {
                        return Container(
                          width: width - 30,
                          padding: EdgeInsets.only(left: 2, right: 2, top: 0),
                          margin: EdgeInsets.only(left: 2, right: 2, top: 2),
                          child: GridView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.5,
                            ),
                            itemBuilder: (context, index) {
                              if(!canView && index ==0)
                              return Container();
                              else
                              return SingleCategoryItemWidget(snapshot.data![index]);
                            },
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  if (Constant.freeAds.value.length > 0)
                    Container(
                      height: 120,
                      width: width,
                      padding: EdgeInsets.zero,
                      child: ValueListenableBuilder(
                        valueListenable: Constant.freeAds,
                        builder: (context,dynamic value, child) {
                          return Swiper(
                            controller: _swiperControllerBanners,
                            autoplay: true,
                            autoplayDisableOnInteraction: false,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  customLaunch("${value.first.link}");
                                },
                                child: Image.network(
                                  "${value[index].image}",
                                  height: height * 0.1 + 30,
                                  width: width,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                            itemCount:value.length,
                            pagination: new SwiperPagination(
                              alignment: Alignment.bottomCenter,
                            ),
                            control: new SwiperControl(
                              color: appColorTwo,
                              size: 0,
                            ),
                          );
                        },
                      ),
                    ),
                  FutureBuilder(
                    future: categoryProvider.getCategories(notCheck: "not", startFromIndex: 1, itemsLength: 0),
                    builder: (context, AsyncSnapshot<List<Categories>> snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: appColor,
                        ));
                      } else {
                        return snapshot.data!.length == 0
                            ? Center(
                                child: Text(
                                "",
                                style: TextStyle(color: appColor),
                              ))
                            : Container(
                                width: width - 30,
                                padding: EdgeInsets.only(left: 2, right: 2, top: 0),
                                margin: EdgeInsets.only(left: 2, right: 2, top: 2),
                                child: GridView.builder(
                                  itemCount: snapshot.data!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: snapshot.data!.length >= 2 ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 18,
                                    // mainAxisExtent: height * 0.2 - 25,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return SingleCategoryItemWidget(snapshot.data![index]);
                                  },
                                ),
                              );
                      }
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                    color: colorWhite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translate("store.games_club"),
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor, fontSize: width * 0.04 + 2),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameStorePage()));
                          },
                          child: Text(
                            translate("home.show_all"),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor, fontSize: width * 0.03 + 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    height: height * 0.2,
                    width: width,
                    padding: EdgeInsets.only(left: Constant.lang == "ar" ? 0 : 10, right: Constant.lang == "ar" ? 10 : 0),
                    child:
                    FutureBuilder(
                      future: categoryProvider.getGamesClub(savedProducts: gameClubProducts, delay: true),
                      builder:
                          (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: appColor,
                              ));
                        } else {
                          gameClubProducts = snapshot.data;

                          return snapshot.data!.length == 0
                              ? Center(
                              child: Text(
                                translate(
                                  "toast.home_no_games",
                                ),
                                style: TextStyle(color: appColor),
                              ))
                              : ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ProductDetailsPage(
                                            id: "${snapshot.data![index].productId}",
                                            location: "${snapshot.data![index].location}",
                                            title: "${snapshot.data![index].productName}",
                                            image: snapshot.data![index].images!.length == 0 ? snapshot.data![index].productImage : "${snapshot.data![index].images!.first.image}",
                                            rate_value: "${snapshot.data![index].rate_value}",
                                            description: "${snapshot.data![index].longDescription}",
                                            countryName: "${snapshot.data![index].countryName}",
                                            address_details: "${snapshot.data![index].address_details}",
                                            lat: "${snapshot.data![index].lat}",
                                            lng: "${snapshot.data![index].lng}",
                                            // price: "${snapshot.data[index].price}",
                                            images: snapshot.data![index].images,
                                            // marketName: "${snapshot.data[index].marketName}",
                                            marketID: "${snapshot.data![index].marketId}",
                                            marketPhone: "${snapshot.data![index].marketPhone}",
                                            fav: snapshot.data![index].fav.toString() == "true" ? true : false,
                                          )));
                                    },
                                    child: Card(
                                        elevation: 4,
                                        color: backGround,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              snapshot.data![index].images!.length == 0
                                                  ?
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                width: width * 0.1 + 15,
                                                height: height * 0.07,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    image: DecorationImage(
                                                        image:AssetImage(
                                                          "assets/images/home_1.png",
                                                        ),
                                                        fit: BoxFit.cover),
                                                    border: Border.all(width: 2, color: appColor)),
                                              ):
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                width: width * 0.1 + 15,
                                                height: height * 0.07,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    image: DecorationImage(
                                                        image:NetworkImage(
                                                          "${snapshot.data![index].images!.first.image}",
                                                        ),
                                                        fit: BoxFit.cover),
                                                    border: Border.all(width: 2, color: appColor)),
                                              ),
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
                                                        color: Colors.red,
                                                        size: width * 0.05,
                                                      ),
                                                      Text(
                                                        "${snapshot.data![index].location}",
                                                        style: GoogleFonts.cairo(
                                                          color: appColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )));
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: height * 0.02,
                                );
                              },
                              itemCount: snapshot.data!.length <= 1 ? 1 : 2);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.2 - 20),
            ],
          ),
        ));
  }

  bool dept = true;
  bool city = false;
  bool kind = false;
  bool status = false;
  List<DropdownMenuItem<String>>? _dropDownMenuItemsCityKind;
  String? _statusSelCityKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsCityKind() {
    List<DropdownMenuItem<String>> itemsCityKind = [];
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

  List<DropdownMenuItem<String>>? _dropDownMenuItemsDeptKind;
  String? _statusSelDeptKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsDeptKind() {
    List<DropdownMenuItem<String>> itemsMarketKind = [];
    for (int i = 0; i < Constant.categories.value.length; i++) {
      itemsMarketKind.add(new DropdownMenuItem(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            i == 0
                ? SizedBox()
                : Divider(
                    thickness: 2.0,
                  ),
            Text(
              "${Constant.categories.value[i].name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        value: "${Constant.categories.value[i].id}",
      ));
    }
    return itemsMarketKind;
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsStatus;
  String ? _statusSelStatus;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsStatus() {
    List<DropdownMenuItem<String>> itemsMarketKind =[];
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
