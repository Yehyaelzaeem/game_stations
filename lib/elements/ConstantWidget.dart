import 'package:flutter/material.dart';

class ConstantWidget{
  static Future loadingData({ BuildContext? context}) async {
    await showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (context) => AlertDialog(
        title: Center(child: CircularProgressIndicator()),
      ),
    );
  }

}