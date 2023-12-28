import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../repository/auth_user.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfilePage> {
  bool enableUpdate = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var updateProfile = Provider.of<UserAuth>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: appColor, opacity: 12, size: 25),
        backgroundColor: colorWhite,
        title: Text(
          translate("profile.edit_profile"),
          style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await selectImage().then((value) {
                  setState(() {
                    imageFileUpload = value;
                  });
                });
              },
              child: Container(
                child: enableUpdate == true
                    ? Container(
                        width: width * 0.2 + 5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.all(4),
                        child: imageFileUpload == null
                            ? Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(100)),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                          color: colorWhite,
                                        ),
                                      )),
                                ],
                              )
                            : Image.file(
                                imageFileUpload!,
                                height: height * 0.07,
                                width: width * 0.6,
                                fit: BoxFit.cover,
                              ),
                      )
                    : Container(
                        width: width * 0.2 + 5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Constant.image.toString().trim() == "null" ? Colors.grey.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.all(4),
                        child: Constant.image.toString().trim() != "null"
                            ? Image.network(
                                Constant.image!,
                                height: height * 0.07,
                                width: width * 0.6,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                backgroundColor: appColor,
                                maxRadius: 40,
                                child: Text(
                                  '${Constant.userName == null ? "H" : Constant.userName!.substring(0, 1).toString()}',
                                  style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Visibility(
              visible: enableUpdate == false ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: appColor,
                          ),
                          onPressed: () {
                            if (enableUpdate == true) {
                              setState(() {
                                enableUpdate = false;
                              });
                            } else {
                              setState(() {
                                enableUpdate = true;
                                _usernameController.text = Constant.userName.toString();
                                _emailController.text = Constant.email.toString();
                                _mobilephonecontroller.text = Constant.userPhone.toString();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translate("signup.username"),
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: TextFormField(
                enabled: enableUpdate,
                validator: (value) => value!.isEmpty ? 'username can\'t be empty' : null,
                controller: _usernameController,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorDark, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: Constant.userName.toString().replaceAll("null", "").toString(),
                ),
                onTap: () {},
                autofocus: false,
                cursorColor: colorDark,
                style: TextStyle(color: colorDark, decorationColor: colorDark),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translate("signup.email"),
                  style: TextStyle(color: colorDark, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: TextFormField(
                enabled: enableUpdate,
                validator: (value) => value!.length < 6 ? ' user email can\tn be empty' : null,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hoverColor: Colors.black,
                  hintText: Constant.email.toString().replaceAll("null", "").toString(),
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                onTap: () {},
                autofocus: false,
                cursorColor: Colors.black,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translate("signup.phone"),
                  style: TextStyle(color: colorDark, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: TextFormField(
                enabled: enableUpdate,
                validator: (value) => value!.isEmpty ? 'mobile phone can\'t be empty' : null,
                controller: _mobilephonecontroller,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorDark, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: Constant.userPhone.toString().trim().replaceAll("null", "").toString(),
                ),
                onTap: () {},
                autofocus: false,
                cursorColor: colorDark,
                style: TextStyle(color: colorDark, decorationColor: colorDark),
              ),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            Visibility(
              visible: enableUpdate,
              child: SizedBox(
                height: 40,
                width: 140,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () async {
                    // if (_usernameController.text.toString().trim() ==
                    //         Constant.userName.toString().trim() &&
                    //     _emailController.text.toString().trim() ==
                    //         Constant.email.toString().trim() &&
                    //     _mobilephonecontroller.text.toString().trim() ==
                    //         Constant.userPhone.toString().trim()
                    //     &&imageFileUpload!=null) {
                    //   setState(() {
                    //     enableUpdate = false;
                    //   });
                    // } else {
                    //   if (_usernameController.text
                    //           .toString()
                    //           .trim()
                    //           .isNotEmpty &&
                    //       _emailController.text.toString().trim().isNotEmpty &&
                    //       _mobilephonecontroller.text
                    //           .toString()
                    //           .trim()
                    //           .isNotEmpty &&
                    //       _mobilephonecontroller.text.toString() != "null") {
                    await updateProfile
                        .updateProfile(
                            context: context,
                            userName: _usernameController.text.toString().trim(),
                            userEmail: _emailController.text.toString().trim(),
                            phone: _mobilephonecontroller.text.toString().trim(),
                            image: imageFileUpload)
                        .then((value) {
                      setState(() {
                        enableUpdate = false;
                      });
                    });

                    //   } else {
                    //     showToast(translate("toast.field_empty"));
                    //   }
                    // }
                  },
                  child: new Text(translate("profile.update"), style: GoogleFonts.cairo(color: colorWhite, fontWeight: FontWeight.bold, fontSize: 18)),
                  color: appColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Delete account
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(translate("profile.delete_account")),
                        content: Text(translate("profile.delete_account_msg")),
                        actions: [
                          FloatingActionButton(
                            child: Text(translate("profile.cancel")),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FloatingActionButton(
                            child: Text(translate("profile.delete")),
                            onPressed: () async {
                              Navigator.pop(context);
                              await updateProfile.deleteAccount();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text(translate("profile.delete_account"),
                  style: GoogleFonts.cairo(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userShippingAddressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobilephonecontroller = TextEditingController();

  File? imageFileUpload;
  static Future<File> selectImage() async {
    File? image;
    final _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_imagePicker != null && pickedImage != null && pickedImage.path != null) {
      image = File(pickedImage.path);
      print("imagePath\n" + image.path);
    } else {
      print("No Image Selected");
    }
    return image!;
  }
}
