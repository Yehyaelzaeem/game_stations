import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';

class SelectCountryScreen extends StatelessWidget {
  static const routeName = "/select_country_card_game_screen";
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          globalHeader(context, translate("activity_setting.choose_country")),
          SizedBox(height: 16),
          ListView.separated(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 29, end: 29, top: 7, bottom: 7),
                color: Colors.white,
              );
            },
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12,
              );
            },
          )
        ],
      ),
    );
  }
}
