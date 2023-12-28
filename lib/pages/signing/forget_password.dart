import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../helper/showtoast.dart';
import '../../repository/auth_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var resetProvider = Provider.of<UserAuth>(context);
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          iconTheme: IconThemeData(color: colorWhite, opacity: 12, size: 25),
          backgroundColor: appColor,
          elevation: 0,
          title: Text(
            translate("signup.password"),
            style: TextStyle(color: colorWhite),
          ),
          centerTitle: true,
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
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/home_1.png",
                    height: height * 0.2,
                    width: width * 0.6,
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: new TextFormField(
                            validator: (value) => value!.isEmpty ? 'email password can\'t be empty' : null,
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            cursorWidth: 2.0,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1.0),
                              ),
                              border: OutlineInputBorder(),
                              hintText: translate("signup.email") + " * ",
                            ),
                            onTap: () {},
                            autofocus: false,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black, decorationColor: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            height: 45,
                            child: MaterialButton(
                              color: appColor,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(30))),
                              onPressed: () async {
                                await resetProvider.forgetPassword(context: context, id: _emailEditingController.text.toString().trim());
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Spacer(),
                                Text(translate("button.ok"), style: GoogleFonts.cairo(color: colorWhite, fontWeight: FontWeight.bold, fontSize: 20.0)),
                                Spacer(),
                                Icon(
                                  Icons.account_box_outlined,
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
        ));
  }

  TextEditingController _emailEditingController = TextEditingController();
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
