import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

fullView(BuildContext context,String imgUrl) {
  AlertDialog alert;
  // set up the AlertDialog
  alert = AlertDialog(
    insetPadding: EdgeInsets.all(1),
    backgroundColor: Colors.grey.withOpacity(0.1),
    content:Stack(
      clipBehavior: Clip.none, children: [
        Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child:PhotoView(
              backgroundDecoration: BoxDecoration(
                color:Colors.grey.withOpacity(0.1),
              ),
              enableRotation: true,
              imageProvider: NetworkImage("${imgUrl.toString()}"),
            )
        )
      ],
    ) ,

  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}