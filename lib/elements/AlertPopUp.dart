
import 'package:flutter/material.dart';
import '../helper/customLaunch.dart';
import '../helper/showtoast.dart';
bool valueRules = false;
showAlertDialogPopUp(BuildContext _context,{String? img, String? link}) async{
  double  height= MediaQuery.of(_context).size.height;
  double  width= MediaQuery.of(_context).size.width;
  AlertDialog alert;
  // Widget okButton = new Align(
  //   alignment: Alignment.center,
  //   child: Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: FlatButton(
  //       color: appColor,
  //       child: Text(
  //         translate("button.ok"),
  //         style: TextStyle(
  //             color: colorWhite,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             letterSpacing: 2.0),
  //       ),
  //       onPressed: () async {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ),
  //   ),
  // );
  // set up the AlertDialog
  alert = AlertDialog(
    title:Container(
      width: width,
      alignment: Alignment.centerLeft,
      child:  IconButton(
        icon: Icon(Icons.close,color: appColor,),
        onPressed: (){
          Navigator.of(_context, rootNavigator: true).pop();
        },
      ),
    ),
    insetPadding: EdgeInsets.all(height*0.05),
    contentPadding: EdgeInsets.all(15),
    content: StatefulBuilder (
      builder: (ctx, setState) {
        return Container(
          height:height *0.4,
          width:width - 50,
          child: SingleChildScrollView(
            child:GestureDetector(
              onTap: (){
                customLaunch("$link");
              },
              child: Stack(
                children: [
                  Image.network("$img",alignment: Alignment.center,fit: BoxFit.contain,
                    height:height*0.3 ,),
                ],
              ),
            ),

          ),
        );
      }
      ,),
    actions: [
      // okButton,
    ],
  );
  // show the dialog
  await showDialog(
    context: _context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
