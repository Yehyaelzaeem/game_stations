import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/game_card_category_model.dart';
import '../products/games_cards_list_screen.dart';
import '../sub_categories/games_cards_sub_categories.dart';

class MainCategoryItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    GameCardCategoryModel model = Provider.of<GameCardCategoryModel>(context,listen: false);

    return InkWell(
      onTap: () {
        if (model.subCategoryList!.isNotEmpty) {

          print("name :  MainCategoryItemWidget subCategoryList  => GamesCardSubCategoriesScreen");
          print("id :  ${model.id}");
          print("name :  ${model.name}");
          print("subCategoryList :  ${model.subCategoryList![0].name}");

          Navigator.of(context).pushNamed(GamesCardSubCategoriesScreen.routeName, arguments: model);
        } else {
          print("name :  MainCategoryItemWidget not subCategoryList  => GamesCardsListScreen");

          Navigator.of(context).pushNamed(GamesCardsListScreen.routeName, arguments: model);
        }
      },
      child: Container(
        // height: 141,
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: model.image!.isNotEmpty
                    ? Image.network(
                        model.image!,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/images/s.png",
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: FittedBox(
                  child: Text(model.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 17.0,
                        color: const Color(0xFF46468F),
                        height: 1,
                        letterSpacing: 0.0047600000202655795,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
