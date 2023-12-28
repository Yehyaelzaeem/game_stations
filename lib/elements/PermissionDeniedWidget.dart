

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../helper/showtoast.dart';
import '../pages/signing/login_screen.dart';
import '../pages/signing/signup_screen.dart';

class PermissionDeniedWidget extends StatefulWidget {
  @override
  _PermissionDeniedWidgetState createState() => _PermissionDeniedWidgetState();
}
class _PermissionDeniedWidgetState extends State<PermissionDeniedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.bottomLeft,
                        end: Alignment.topRight, colors: [
                      Theme.of(context).focusColor.withOpacity(0.7),
                      Theme.of(context).focusColor.withOpacity(0.05),
                    ])),
                child: Icon(
                  Icons.https,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 70,
                ),
              ),
              Positioned(
                right: -30,
                bottom: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: 0.4,
            child: Text(
              translate("profile.need_to_sign_up"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3!.merge(TextStyle(fontWeight: FontWeight.w300,fontSize: 20)),
            ),
          ),
          SizedBox(height: 50),
          SizedBox(
            height: 40,
            width: 160,
            child: Material(
              color: appColor,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder:
                      (context)=>LoginScreen()));
                },
                child:Center(
                  child: Text(translate("login.login"),
                    style: TextStyle(color: colorWhite,
                        fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder:
                  (context)=>SignUpScreen()));
            },
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            shape: StadiumBorder(),
            child: Text(
              translate("login.dont_have_anaccount"),
              style: TextStyle(color: appColor),
            ),
          ),

        ],
      ),
    );
  }
}
// Center(
// child: SizedBox(
// height: 41,
// width: 270,
// child: new RaisedButton(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// onPressed: () {
// Navigator.of(context)
//     .push(MaterialPageRoute(builder: (context) => signup()));
// },
// child: new Text(
// translate("profile.need_to_sign_up"),
// textAlign: TextAlign.center,
// style: TextStyle(
// color: Colors.white,
// fontSize: 20,
// ),
// ),
// color: color,
// ),
// ),
// );