import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_translate/global.dart';
import '../elements/drawer.dart';
import '../helper/showtoast.dart';
import '../models/Constant.dart';
import 'home.dart';
import 'store/search.dart';
import 'user/add_product.dart';
import 'user/chat_list.dart';
import 'user/favourite.dart';
import 'user/my_ads.dart';
import 'user/profile.dart';
import '../repository/categories.dart';
import '../repository/messageCountProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RootPages extends StatefulWidget {
  String? checkPage;
  RootPages({this.checkPage});
  @override
  _RootPagesState createState() => _RootPagesState();
}

class _RootPagesState extends State<RootPages> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  final pages = [
    Home(),
    FavouritePage(),
    AddProductPage(),
    MyAdsPage(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    _loading();
    Provider.of<MassageCountProvider>(context, listen: false).messageCount();
    if (widget.checkPage != null) {
      selectedIndex = int.parse(widget.checkPage.toString()).toInt();
    } else {
      selectedIndex = 0;
    }
    super.initState();
  }
  _loading()async{
    try {
      Provider.of<CategoriesProvider>(context, listen: false).getSlider();
      await getFreeAds();
    } catch (e) {
      print(e.toString());
    }
  }

  var userInfo;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    // var userProvider = Provider.of<UserAuth>(context,listen: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backGround,
      drawer: drawerWidget(context),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: Container(
          height: height * 0.2,
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: new Padding(
            padding: EdgeInsets.only(top: height * 0.01, right: width * 0.04, left: width * 0.04, bottom: height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Image(
                    height: height * 0.05,
                    width: width * 0.05,
                    fit: BoxFit.contain,
                    image: Svg('assets/images/Icon open-menu.svg'),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Card(
                    color: colorWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding: EdgeInsets.only(left: Constant.lang == "ar" ? 10 : 0, right: Constant.lang != "ar" ? 10 : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: width - 130,
                            padding: EdgeInsets.only(right: Constant.lang == "ar" ? 5 : 0, left: Constant.lang != "ar" ? 5 : 0),
                            child: TextField(
                              autocorrect: true,
                              onTap: null,
                              controller: _searchEditingController,
                              decoration: InputDecoration(
                                hintText: translate("home.search"),
                                counterStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.search_rounded),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              word: _searchEditingController.text.toString().trim(),
                                              type: "${categoryProvider.typeIDSearch}",
                                              cat: "${categoryProvider.catIDSearch}",
                                              city: "${categoryProvider.cityIDSearch}",
                                            )));
                                  },
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(color: Colors.black45),
                                filled: true,
                                fillColor: colorWhite,
                                contentPadding: EdgeInsets.only(top: 0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(color: colorWhite, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: colorWhite, width: 2),
                                ),
                              ),
                              onSubmitted: (_) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                          word: _searchEditingController.text.toString().trim(),
                                          type: "${categoryProvider.typeIDSearch}",
                                          cat: "${categoryProvider.catIDSearch}",
                                          city: "${categoryProvider.cityIDSearch}",
                                        )));
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('sdfsdfsd');
                              // Constant.enableFilter.value = !Constant.enableFilter.value;
                              if (Constant.enableFilter.value != true) {
                                Constant.enableFilter.value = true;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootPages()));
                              }
                            },
                            child: Image(
                              height: height * 0.03,
                              width: width * 0.05,
                              fit: BoxFit.contain,
                              image: Svg('assets/images/preferences.svg'),
                            ),
                          ),
                        ],
                      ),
                    )),


                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatListPage()));
                  },
                  child: Consumer<MassageCountProvider>(builder: (context, unread, child) {
                    return Stack(
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Align(
                              alignment: Alignment.lerp(Alignment.topRight,
                                  Alignment.center,0.7)!,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: colorStar,
                                ),
                              ),
                            ),
                            Image(
                              height: height * 0.03,
                              width: width * 0.05,
                              fit: BoxFit.contain,
                              image: Svg('assets/images/Icon feather-message-square.svg'),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.lerp(Alignment.topRight,
                              Alignment.center,0.7)!,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.black,
                            child: Center(
                                child: Text(
                              "${unread.unRead}",
                              style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold,color: Colors.white),
                            )),
                          ),
                        )
                      ],
                    );
                  }),
                ),


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
        preferredSize: new Size(MediaQuery.of(context).size.width, height * 0.1 - 4),
      ),
      body: Stack(
        children: [
          pages[selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomNavigationBar(width, height),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar(double width, double height) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: height * 0.1 + 15,
          padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
          decoration: BoxDecoration(
            color: appColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width * 0.07),
              topRight: Radius.circular(width * 0.07),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: (ind) {
              setState(() {
                selectedIndex = ind;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: selectedIndex == 0 ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
                  decoration: BoxDecoration(border: selectedIndex == 0 ? Border(bottom: BorderSide(width: 4, color: appColorTwo)) : Border()),
                  child: Image(
                    height: height * 0.05,
                    width: width * 0.08,
                    fit: BoxFit.contain,
                    image: Svg('assets/images/Icon feather-home.svg'),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: selectedIndex == 1 ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
                  decoration: BoxDecoration(border: selectedIndex == 1 ? Border(bottom: BorderSide(width: 4, color: appColorTwo)) : Border()),
                  child: Image(
                    height: height * 0.05,
                    width: width * 0.08,
                    fit: BoxFit.contain,
                    image: Svg('assets/images/heart.svg'),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(border: selectedIndex == 2 ? Border(bottom: BorderSide(width: 4, color: appColorTwo)) : Border()),
                  child: Container(
                    height: height * 0.05 - 2,
                    width: width * 0.2,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: selectedIndex == 3 ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
                  decoration: BoxDecoration(border: selectedIndex == 3 ? Border(bottom: BorderSide(width: 4, color: appColorTwo)) : Border()),
                  child: Image(
                    height: height * 0.05,
                    width: width * 0.09,
                    fit: BoxFit.contain,
                    image: Svg('assets/images/megaphone.svg'),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: selectedIndex == 4 ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
                  decoration: BoxDecoration(border: selectedIndex == 4 ? Border(bottom: BorderSide(width: 4, color: appColorTwo)) : Border()),
                  child: Image.asset(
                    'assets/images/Profile.png',
                    height: height * 0.05,
                    width: width * 0.08,
                    // image: Svg('assets/images/user.svg'),
                  ),
                ),
                label: "",
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.only(bottom: height * 0.06),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: Image.asset(
                "assets/images/blus.png",
                height: height * 0.1,
                width: width * 0.1 + 9,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController _searchEditingController = new TextEditingController();
}
