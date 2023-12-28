import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamestation/pages/store/products.dart';
// import 'package:gamestation_app/pages/store/products.dart';

import '../helper/device_validation.dart';
import '../helper/showtoast.dart';
import '../models/Categories.dart';
import 'games_cards/categories/games_cards_main_categories.dart';

class SingleCategoryItemWidget extends StatelessWidget {
  final Categories category;
  const SingleCategoryItemWidget(
    this.category, {
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        if (category.id == "0") {
          if(!canView) {
            showToast("Coming Soon");
            return;
          }
          Navigator.of(context).pushNamed(
            GamesCardMainCategoriesScreen.routeName,
            arguments: category.name,
          );
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductsPage(
                    catID: category.id.toString(),
                    categoryTitle: category.name.toString(),
                  )));
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              //  Image.asset(
              //                                                     "${snapshot.data[index].image}",
              //                                                     fit: BoxFit.contain,
              //                                                   )

              if (category.image == null || category.imageType == 2)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/images/game_cards2.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              if (category.image != null && category.imageType != 2)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: "${category.image}",
                      placeholder: (context, url) => Image.asset(
                        'assets/images/loading.gif',
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              if (category.name != null && category.name!.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Color(0xff000081).withOpacity(0.75),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Center(
                    child: Text(
                      category.name!,
                      style: TextStyle(
                        color: Color(0xffEAC43D),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
