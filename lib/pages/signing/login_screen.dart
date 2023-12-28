import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../elements/user_input.dart';
import '../../helper/showtoast.dart';
import '../../repository/auth_user.dart';
import 'forget_password.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        height: _size.height,
        width: _size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.04),
            child: Column(
              children: [
                SizedBox(
                  height: _size.height * 0.15,
                ),
                Text(
                  translate("login.login"),
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: appColor),
                ),
                SizedBox(
                  height: _size.height * 0.06,
                ),
                UserInput.userinput(hint: translate("signup.phone"), textEditingController: _emailController, textInputType: TextInputType.phone),
                SizedBox(
                  height: _size.height * 0.03,
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
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        pass = !pass;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.03,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.toString().trim().isNotEmpty || _passwordController.text.toString().trim().isNotEmpty) {
                      await userAuth.loginUser(context: context, password: _passwordController.text.toString().trim(), phone: _emailController.text.toString().trim());
                    } else {
                      showToast(translate("login.not_true"));
                    }
                  },
                  child: Text(
                    translate("login.app_bar"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: appColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: Size(_size.width, _size.height * 0.070),
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      translate("login.forget_password"),
                      style: TextStyle(color: appColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate("login.dont_have_anaccount"),
                      style: TextStyle(
                        color: appColor.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        translate("signup.signup"),
                        style: TextStyle(color: appColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: appColor,
                      size: width * 0.06,
                    )
                  ],
                ),
                SizedBox(
                  height: _size.height * 0.03,
                ),
                if (!Platform.isIOS)
                  Text(
                    translate("signup.or"),
                    style: TextStyle(color: appColor.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: width * 0.04 + 2),
                  ),
                if (!Platform.isIOS)
                  SizedBox(
                    height: _size.height * 0.04,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!Platform.isIOS)
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
                    if (!Platform.isIOS)
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
}
