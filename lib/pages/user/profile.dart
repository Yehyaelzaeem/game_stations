import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../elements/fullView.dart';
import '../../elements/signOut.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../root_pages.dart';
import 'edit_profile.dart';
import 'myClubs.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backGround,
      body: Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
          ? Container(
              width: _size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Constant.image != null && Constant.image.toString().trim() != "null"
                        ? GestureDetector(
                            onTap: () {
                              fullView(context, "${Constant.image}");
                            },
                            child: Container(
                              width: width * 0.2 + 10,
                              height: height * 0.1,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), image: DecorationImage(image: NetworkImage("${Constant.image}"), fit: BoxFit.cover)),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: appColor,
                            maxRadius: 40,
                            child: Text(
                              '${Constant.userName == null ? "H" : Constant.userName!.substring(0, 1).toString()}',
                              style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${Constant.userName == null ? "username@gmail.com" : Constant.userName.toString().replaceAll("null", "").toString()}',
                      style: TextStyle(fontSize: width * 0.04, color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${Constant.email == null ? "username@gmail.com" : Constant.email.toString().replaceAll("null", "").toString()}',
                      style: TextStyle(fontSize: width * 0.03 + 1, color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    // reView(200,context),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      color: appColorTwo.withOpacity(0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          drawerElement(
                              icon: Icons.favorite,
                              title: translate("navigation_bar.favourite"),
                              tap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RootPages(
                                          checkPage: "1",
                                        )));
                              }),
                          drawerElement(
                              title: translate("profile.my_clubs"),
                              tap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyClubs()));
                              }),

                          drawerElement(
                              icon: Icons.shopping_bag,
                              title: translate("navigation_bar.my_ads"),
                              tap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RootPages(
                                          checkPage: "3",
                                        )));
                              }),
                          drawerElement(
                              icon: Icons.settings,
                              title: translate("drawer.drawer_setting"),
                              tap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()));
                              }),

                          // drawerElement(icon: Icons.language,
                          //     title: translate("drawer.change_lang"),
                          //     tap: ()async{
                          //       if(Constant.lang=="ar"){
                          //         Constant.lang = "en_US";
                          //         await DBProvider.db.updateClient(Client(
                          //           id: 0,
                          //           password: Constant.userPassword.toString(),
                          //           token: Constant.token,
                          //           lang: "en_US",
                          //           country: "en_US",));
                          //       }else{
                          //         Constant.lang = "ar";
                          //         await DBProvider.db.updateClient(Client(
                          //           id: 0,
                          //           lang: "ar",
                          //           password: Constant.userPassword.toString(),
                          //           token: Constant.token,
                          //           country: "ar",));
                          //       }
                          //       await checkUser();
                          //       Navigator.of(context).push(MaterialPageRoute(builder:
                          //           (context)=>MyApp(check: "0",)));
                          //     }
                          // ),
                          ListTile(
                            leading: Icon(
                              Icons.login_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                            title: Text(
                              translate("drawer.drawer_signout"),
                              style: GoogleFonts.cairo(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              showAlertDialogSignOut(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : PermissionDeniedWidget(),
    );
  }
}

Widget drawerElement({IconData? icon, String? title, void Function()? tap}) {
  return ListTile(
    onTap: tap!,
    leading: icon != null
        ? Icon(
            icon,
            color: appColor,
            size: 30,
          )
        : Image(
            height: 30,
            width: 30,
            fit: BoxFit.contain,
            color: appColor,
            image: Svg('assets/images/gamese.svg'),
          ),
    title: Text(
      title!,
      style: TextStyle(fontSize: 18),
    ),
  );
}
