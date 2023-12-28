import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// var appColor = const Color(0xff188e8d);
// const Color appColor=Color(0xFF40a944);
Color appColor = Color(0xff000081); //#EAC43D
Color appColorTwo = Color(0xffEAC43D); //#EAC43D
Color backGround = Color(0xffededf5); //#000081
var colorWhite = const Color(0xffffffff);
var colorDark = const Color(0xff000000);
var colorStar = const Color(0xffFFD27D);
var colorGreen = const Color(0xff29ff37);

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: appColor,
    textColor: colorWhite,
    fontSize: 16.0,
  );
}
