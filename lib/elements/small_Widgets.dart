import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../helper/showtoast.dart';
import '../pages/signing/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallWidgets{
  static Widget adsActivities(double height,double width,String title,String value){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$title",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
              color: Colors.grey,fontSize: width*0.04),),
        // SizedBox(height: height*0.01,),
        Text("$value",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
              color: appColor),),
      ],
    );
  }

  static  shouldBeRegister(BuildContext context){
      AlertDialog alert;
      Widget cancelButton = MaterialButton(
        child: Text(translate("button.cancel"), style: GoogleFonts.cairo(fontSize: 15,fontWeight: FontWeight.bold),),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      Widget okButton = new Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            color: appColor,
            child: Text(
              translate("login.app_bar"),
              style: GoogleFonts.cairo(fontSize: 17,fontWeight: FontWeight.bold,
                  color: colorWhite),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).push(MaterialPageRoute(builder:
                  (context)=>LoginScreen()));
            },
          ),
        ),
      );
      // set up the AlertDialog
      alert = AlertDialog(
        title: Text(
          translate("toast.login"),
          style: GoogleFonts.cairo(fontSize: 17,fontWeight: FontWeight.bold),
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