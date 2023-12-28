import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/user_input.dart';
import '../../helper/showtoast.dart';
import '../about/about_us.dart';
import 'login_screen.dart';
import '../../repository/auth_user.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool pass = true;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userAuth = Provider.of<UserAuth>(context, listen: false);
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        // height: _size.height,
        // width: _size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.03),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, right: 40),
                    child: InkWell(
                        onTap: () {
                          print("OnClieck");
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: appColor,
                            ),
                            onPressed: null)),
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.09,
                ),
                Text(
                  translate("signup.signup"),
                  style: TextStyle(fontSize: width * 0.08, fontWeight: FontWeight.bold, color: appColor),
                ),
                SizedBox(
                  height: _size.height * 0.04,
                ),
                UserInput.userinput(hint: translate("signup.first_name"), textEditingController: _firstController),
                SizedBox(
                  height: 10,
                ),
                UserInput.userinput(hint: translate("signup.last_name"), textEditingController: _lastController),
                SizedBox(
                  height: 10,
                ),
                UserInput.userinput(hint: translate("signup.phone"), textEditingController: __phoneController, textInputType: TextInputType.phone),
                SizedBox(
                  height: 10,
                ),
                UserInput.userinput(hint: translate("signup.email"), textEditingController: _emailController, textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 10,
                ),
                UserInput.userinput(
                  hint: translate("signup.password"),
                  password: pass,
                  textEditingController: _passwordController,
                  suffix: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      pass ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        pass = !pass;
                      });
                    },
                  ),
                ),

                //Agree with terms and conditions
                SizedBox(
                  height: _size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage("${translate("drawer.drawer_policy")}", "Terms")));
                      },
                      child: Text(
                        translate("signup.BySigningUpYouagreeOurPolicyAndTermsOfUse"),
                        style: TextStyle(
                          color: appColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: _size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_firstController.text.toString().trim().isNotEmpty || _lastController.text.toString().trim().isNotEmpty || __phoneController.text.toString().trim().isNotEmpty || _emailController.text.toString().trim().isNotEmpty || _passwordController.text.toString().trim().isNotEmpty) {
                      await userAuth.registerUser(
                        context: context,
                        password: _passwordController.text.toString().trim(),
                        firstName: _firstController.text.toString().trim(),
                        lastName: _lastController.text.toString().trim(),
                        mobile: __phoneController.text.toString().trim(),
                        email: _emailController.text.toString().trim(),
                      );
                    } else {
                      showToast(translate("login.not_true"));
                    }
                  },
                  child: Text(
                    translate("signup.signup"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.06,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: appColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: Size(_size.width, _size.height * 0.070),
                  ),
                ),

                SizedBox(
                  height: _size.height * 0.06,
                ),
                if (!Platform.isIOS)
                  Text(
                    'أو استخدم',
                    style: TextStyle(
                      color: appColor.withOpacity(0.6),
                    ),
                  ),
                SizedBox(
                  height: _size.height * 0.03,
                ),
                if (!Platform.isIOS)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await userAuth.signInWithFacebook("kindRegister", context);
                        },
                        child: Container(
                          height: width * 0.1 + 20,
                          width: width * 0.1 + 20,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/f.png"), fit: BoxFit.contain)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await userAuth.signInWithGoogle("kindRegister", context);
                        },
                        child: Container(
                          height: width * 0.1 + 20,
                          width: width * 0.1 + 20,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/gmail.png"), fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: _size.height * 0.03,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'لديك حساب',
                        style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: colorWhite,
                      size: width * 0.06,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController __phoneController = TextEditingController();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
}
