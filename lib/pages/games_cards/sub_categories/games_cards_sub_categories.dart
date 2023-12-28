import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../../../models/game_card_category_model.dart';
import '../widgets/sub_category_item.dart';

class GamesCardSubCategoriesScreen extends StatelessWidget {
  static const routeName = "games_card_sub_categories_screen";
  String? title;

  @override
  Widget build(BuildContext context) {
    GameCardCategoryModel model = ModalRoute.of(context)!.settings.arguments as GameCardCategoryModel;
    return Scaffold(
      backgroundColor: backGround,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 32),
          globalHeader(context, model.name!,showCart: true),
          SizedBox(height: 16),
          if (model.subCategoryList!.isEmpty) SizedBox(height: 40),
          if (model.subCategoryList!.isEmpty) Center(child: Text(' No Products Available')),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(right: 20, left: 20),
              shrinkWrap: true,
              itemCount: model.subCategoryList!.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(value: model.subCategoryList![index], child: SubCategoryItemWidget());
              },
            ),
          )
        ],
      ),
    );
  }
}
