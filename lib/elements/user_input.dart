import 'package:flutter/material.dart';
import '../models/Constant.dart';

class UserInput {
  static Widget userinput({
    String? hint,
    bool password = false,
    final IconButton? suffix,
    TextEditingController? textEditingController,
    TextInputType? textInputType,
  }) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
          obscureText: password,
          controller: textEditingController,
          textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          keyboardType:textInputType,
        ));
  }
}
