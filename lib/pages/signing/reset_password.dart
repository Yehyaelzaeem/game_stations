import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../helper/showtoast.dart';
import '../../repository/auth_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var resetProvider = Provider.of<UserAuth>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: new PreferredSize(
        preferredSize: new Size(
            MediaQuery.of(context).size.width,
            height*0.07
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [-1, 0.4, 0.7, 4],
              colors: [
                appColorTwo.withOpacity(0.9),
                appColor.withOpacity(0.9),
                appColor.withOpacity(0.7),
                appColor.withOpacity(0.5),
              ],
            ),
          ),
          child:  AppBar(
            iconTheme: IconThemeData(color: colorWhite, opacity: 12, size: 25,),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title:Text(translate("login.change_pass"),
              style: TextStyle(color:colorWhite),),
            centerTitle: true,

          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Image.asset("assets/images/logo.png",
                    height: height*0.2,width: width ,),
                  SizedBox(height: 30,),
                  Form(
                    key:formkey ,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: new TextFormField(
                            validator: (value) =>
                            value!.isEmpty ? 'old password can\'t be empty' : null,
                            controller: _oldEditingController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            cursorWidth: 2.0,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                              ),
                              border: OutlineInputBorder(),
                              hintText: translate("login.old_pass")+" * ",
                            ),
                            onTap: () {},
                            autofocus: false,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                color: Colors.black, decorationColor: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: new TextFormField(
                            validator: (value) =>
                            value!.isEmpty ? 'new password can\'t be empty' : null,
                            controller: _newEditingController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            cursorWidth: 2.0,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                              ),
                              border: OutlineInputBorder(),
                              hintText: translate("login.new_pass")+" * ",
                            ),
                            onTap: () {},
                            autofocus: false,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                color: Colors.black, decorationColor: Colors.black),
                          ),
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                            height: 45,
                            child: MaterialButton(
                              color: appColor,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(30))),
                              onPressed: ()async {
                                await resetProvider.resetPassword(context: context,
                                    newPassword: _newEditingController.text.toString().trim(),
                                oldPassword: _oldEditingController.text.toString().trim());
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Spacer(),
                                Text(translate("button.ok"),
                                    style: GoogleFonts.cairo(color: colorWhite,
                                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                                Spacer(),
                                Icon(
                                  Icons.lock_outline,
                                  color: colorWhite,
                                ),
                              ]),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

        ],
      )
    );
  }
  TextEditingController _oldEditingController = TextEditingController();
  TextEditingController _newEditingController = TextEditingController();
  final formkey = new GlobalKey<FormState>();
  validateForm() {
    print("validate form ...");
    if (formkey.currentState!.validate()) {
      print("validate succes");
      return true;
    } else {
      print("validate faield");
      return false;
    }
  }
}
