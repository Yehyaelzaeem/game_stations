import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helper/ClientModel.dart';
import '../helper/Database.dart';
import '../helper/checkUser.dart';
import '../helper/device_validation.dart';
import '../helper/showtoast.dart';
import '../main.dart';
import '../models/Constant.dart';
import '../pages/about/about_us.dart';
import '../pages/about/contact_us.dart';
import '../pages/games_cards/cart/cart_screen.dart';
import '../pages/games_cards/screens/orders_screen.dart';
import '../pages/root_pages.dart';
import '../pages/signing/login_screen.dart';
import '../pages/store/game_store.dart';
import '../pages/subscriptions/subscriptions.dart';
import '../pages/user/edit_profile.dart';
import '../pages/user/market_subscription.dart';
import '../repository/aboutPagesProvider.dart';
import '../repository/auth_user.dart';
import '../repository/categories.dart';
import 'signOut.dart';

Widget drawerWidget(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  var aboutProvider = Provider.of<About>(context);
  var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
  var userProvider = Provider.of<UserAuth>(context, listen: false);
  return Container(
      height: height + 100,
      color: appColor,
      padding: EdgeInsets.only(bottom: 5),
      width: width - 100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: height * 0.2,
              padding: EdgeInsets.only(top: height * 0.07, bottom: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(height * 0.05),
                  bottomRight: Radius.circular(height * 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.1 + 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      Constant.id == null ? "H" : Constant.userName.toString().substring(0, 1).toString(),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.09, color: colorWhite),
                    ),
                  ),
                  Constant.id == null ? Text("الاسم") : Text("${Constant.userName.toString()}"),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Constant.id == null
                ? ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    title: Text(
                      translate("drawer.drawer_sign_in"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: colorWhite,
                      size: 30,
                    ),
                  )
                : SizedBox(),
            Constant.id != null
                ? ListTile(
                    title: Text(
                      translate("drawer.drawer_person_page"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: colorWhite,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RootPages(
                                checkPage: "4",
                              )));
                    },
                  )
                : SizedBox(),

            if (canView)
            ListTile(
              title: Text(
                translate("store.cart"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.shopping_basket,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            if(canView)
            ListTile(
              title: Text(
                translate("store.purchases"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.pie_chart,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
            ),
            ListTile(
              title: Text(
                translate("navigation_bar.favourite"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.favorite,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RootPages(
                          checkPage: "1",
                        )));
              },
            ),
            ListTile(
              title: Text(
                translate("store.games_club"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Image(
                height: height * 0.06,
                width: width * 0.08,
                fit: BoxFit.contain,
                image: Svg('assets/images/gamese.svg'),
              ),
              // leading: Image.asset("assets/images/console.png",height: height*0.06,
              //   width: width*0.08,alignment: Alignment.center,),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameStorePage()));
              },
            ),
            ListTile(
              title: Text(
                translate("navigation_bar.my_ads"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Image(
                height: height * 0.06,
                width: width * 0.08,
                fit: BoxFit.contain,
                image: Svg('assets/images/megaphonee.svg'),
              ),
              // leading: Image.asset("assets/images/notification.png",height: height*0.06,
              //   width: width*0.08,alignment: Alignment.center,),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RootPages(
                          checkPage: "3",
                        )));
              },
            ),
            if (canView)
              Constant.id != null
                  ? ListTile(
                      title: Text(
                        translate("drawer.subscribe"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
                      ),
                      leading: Icon(
                        Icons.shopping_bag,
                        color: colorWhite,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionPage()));
                      },
                    )
                  : SizedBox(),
            if (canView)
              Constant.id != null
                  ? ListTile(
                      title: Text(
                        translate("drawer.subscribe_saller"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
                      ),
                      leading: Icon(
                        Icons.shopping_bag,
                        color: colorWhite,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MarketSubscriptionPage()));
                      },
                    )
                  : SizedBox(),
            ListTile(
              title: Text(
                translate("navigation_bar.setting"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.settings,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                if (Constant.token == null || Constant.token.toString() == "null" || Constant.token.toString() == "") {
                  showToast(translate("profile.need_to_sign_up"));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()));
                }
              },
            ),
            ListTile(
              title: Text(
                translate("drawer.drawer_callus"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.account_box_outlined,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsPage()));
              },
            ),
            ListTile(
              title: Text(
                translate("drawer.drawer_us"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Text(
                "?   ",
                style: GoogleFonts.cairo(fontSize: height * 0.04, color: colorWhite),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage("${translate("drawer.drawer_us")}", "about_app")));
              },
            ),
            // ListTile(
            //   title: Text(
            //     translate("drawer.drawer_return"),
            //     style: GoogleFonts.cairo(
            //         fontWeight: FontWeight.bold,
            //         color: colorWhite,
            //         fontSize: 17
            //     ),
            //   ),
            //   leading: Icon(Icons.wifi_protected_setup,color: colorWhite,size: 30,),
            //   onTap: (){
            //     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            //     //     AboutUsPage("${translate("drawer.drawer_return")}","return-policy")));
            //   },
            // ),
            ListTile(
              title: Text(
                translate("drawer.drawer_policy"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: 17),
              ),
              leading: Icon(
                Icons.description,
                color: colorWhite,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage("${translate("drawer.drawer_policy")}", "Terms")));
              },
            ),
            ListTile(
              title: Text(
                translate("activity_setting.change_lang"),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite, fontSize: width * 0.05),
              ),
              leading: Icon(
                Icons.language,
                color: colorWhite,
                size: 30,
              ),
              onTap: () async {
                await clearDate();
                if (Constant.lang == "ar") {
                  Constant.lang = "en_US";
                  await DBProvider.db.updateClient(Client(
                    id: 0,
                    token: Constant.token,
                    email: Constant.email.toString(),
                    username: Constant.userName.toString(),
                    phone: Constant.userPhone.toString(),
                    lang: "en_US",
                    country: Constant.country == null ? "1" : Constant.country.toString(),
                  ));
                  await checkUser();
                  await checkUser();
                } else {
                  Constant.lang = "ar";
                  await DBProvider.db.updateClient(Client(
                    id: 0,
                    lang: "ar",
                    token: Constant.token,
                    email: Constant.email.toString(),
                    username: Constant.userName.toString(),
                    phone: Constant.userPhone.toString(),
                    country: Constant.country == null ? "1" : Constant.country.toString(),
                  ));
                  await checkUser();
                  await checkUser();
                }
                try {
                  await categoryProvider.getCategories();
                  await userProvider.getCities();
                  await userProvider.getStates(1);
                } catch (e) {
                  print(e);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
              },
            ),
            Divider(
              color: colorWhite,
            ),
            Constant.id != null
                ? ListTile(
                    title: Text(
                      translate("drawer.drawer_signout"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColorTwo, fontSize: 17),
                    ),
                    leading: Icon(
                      Icons.login,
                      color: appColorTwo,
                      size: 30,
                    ),
                    onTap: () {
                      showAlertDialogSignOut(context);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: height * 0.01,
            ),
            userProvider.countryImage == null || userProvider.countryImage.toString() == ""
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.07,
                      ),
                      Image.network(
                        "${userProvider.countryImage}",
                        height: height * 0.05,
                        width: width * 0.1,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      Text(
                        "${userProvider.countryNameAfterSign.toString().replaceAll("null", "").toString()}",
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: colorWhite),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ));
}
