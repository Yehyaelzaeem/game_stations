import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/customLaunch.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../repository/aboutPagesProvider.dart';

class ContactUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactUsPageState();
  }
}

class _ContactUsPageState extends State<ContactUsPage> {
  String twitterLink = "", facebookLink = "";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var aboutProvider = Provider.of<About>(context);
    if (twitterLink.toString().trim() == "") {
      aboutProvider.getSocial().then((value) {
        for (int i = 0; i < value.length; i++) {
          if (value[i].kind == "facebook") {
            setState(() {
              facebookLink = value[i].value.toString();
              print(facebookLink);
            });
          } else if (value[i].kind == "twitter") {
            setState(() {
              twitterLink = value[i].value.toString();
              print(twitterLink);
            });
          }
        }
      });
    }
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        iconTheme: IconThemeData(color: appColor),
        title: Text(
          translate("drawer.drawer_callus"),
          style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Container(
                width: width * 0.9,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 4, right: 5),
                child: new TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  cursorWidth: 2.0,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorDark, width: 1.0),
                    ),
                    hoverColor: colorDark,
                    hintText: translate("signup.username"),
                  ),
                  textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  autofocus: false,
                  cursorColor: colorDark,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              child: Container(
                width: width * 0.9,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 4, right: 5),
                child: new TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  cursorWidth: 2.0,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorDark, width: 1.0),
                    ),
                    hoverColor: colorDark,
                    hintText: translate("signup.email"),
                  ),
                  textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  autofocus: false,
                  cursorColor: colorDark,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              child: Container(
                width: width * 0.9,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 4, right: 5),
                child: new TextFormField(
                  controller: _mobilephoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  cursorWidth: 2.0,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorDark, width: 1.0),
                    ),
                    hoverColor: colorDark,
                    hintText: translate("signup.phone"),
                  ),
                  textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  autofocus: false,
                  cursorColor: colorDark,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              child: Container(
                width: width * 0.9,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 4, right: 5),
                child: new TextFormField(
                  controller: _locationController,
                  textInputAction: TextInputAction.next,
                  cursorWidth: 2.0,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorDark, width: 1.0),
                    ),
                    hoverColor: colorDark,
                    hintText: translate("store.title"),
                  ),
                  textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  autofocus: false,
                  cursorColor: colorDark,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translate("activity_setting.message"),
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Container(
              height: height * 0.2 - 10,
              color: Colors.grey[50],
              width: width,
              child: TextFormField(
                validator: (value) => value!.isEmpty ? 'the message can\'t be empty' : null,
                controller: _thetopicController,
                textAlignVertical: TextAlignVertical.center,
                minLines: 5,
                maxLines: 6,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: translate("activity_setting.message")),
                onTap: () {},
                autofocus: false,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black, decorationColor: Colors.black),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              height: 45,
              width: width * 0.6,
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                color: appColor,
                minWidth: width * 0.6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Text(
                  translate("activity_setting.send"),
                  style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                ),
                onPressed: () async {
                  if (_usernameController.text.toString().trim().isNotEmpty && _mobilephoneController.text.toString().trim().isNotEmpty && _emailController.text.toString().trim().isNotEmpty && _locationController.text.toString().trim().isNotEmpty && _thetopicController.text.toString().trim().isNotEmpty) {
                    await aboutProvider.sendContact(msg: _thetopicController.text.toString().trim(), name: _usernameController.text.toString().trim(), mobile: _mobilephoneController.text.toString().trim(), email: _emailController.text.toString().trim()).then((value) {});
                  } else {
                    showToast(translate("toast.field_empty"));
                  }
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    try {
                      customLaunch("$twitterLink");
                    } catch (e) {
                      print(e);
                      print("error twitterLink");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          // Text(translate("activity_setting.contact_whats"),
                          //   style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
                          Image.asset(
                            "assets/images/t.png",
                            height: height * 0.06,
                            width: width * 0.1 + 15,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      customLaunch("$facebookLink");
                    } catch (e) {
                      print(e);
                      print("error facebookLink");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          // Text(translate("activity_setting.contact_whats"),
                          //   style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
                          Image.asset(
                            "assets/images/f.png",
                            height: height * 0.06,
                            width: width * 0.1 + 15,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      try {
                        await launch("https://api.whatsapp.com/send?phone=201228071228");
                      } catch (e) {
                        print('cant launch https://api.whatsapp.com/send?phone=201228071228');
                        //show dialog for phone
                        await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //copy to clipboard
                                    Clipboard.setData(ClipboardData(text: "201228071228"));
                                    Fluttertoast.showToast(msg: "تم النسخ");
                                  },
                                  child: Text(
                                    '+201228071228',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                      print("error call phone");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          // Text(translate("activity_setting.contact_whats"),
                          //   style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
                          Image.asset(
                            "assets/images/whatsappp.png",
                            height: height * 0.06,
                            width: width * 0.1 + 15,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      customLaunch("tel:+201228071228");
                    } catch (e) {
                      print(e);
                      print("erorr call phone");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          // Text(translate("activity_setting.contact_call"),
                          //   style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Icon(
                            Icons.call,
                            color: appColor,
                            size: width * 0.1 + 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilephoneController = TextEditingController();
  final TextEditingController _thetopicController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
}
