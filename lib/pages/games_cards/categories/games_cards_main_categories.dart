import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/showtoast.dart';
import '../../../models/game_card_model.dart';
import '../data/game_card_category_provider.dart';
import '../widgets/main_category_item.dart';
import 'game_card_item_widget.dart';
import 'game_cards_categories_appbar.dart';

class GamesCardMainCategoriesScreen extends StatelessWidget {
  static const routeName = "games_card_main_categories_screen";

  @override
  Widget build(BuildContext context) {
    print('***GamesCardMainCategoriesScreen****');
    String title = ModalRoute.of(context)!.settings.arguments as String;
    Provider.of<GameCardCategoryProvider>(context, listen: false).fetchData();
    return Scaffold(
      backgroundColor: backGround,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 32),

          GameCardCategoriesAppBar(title: title),

          SizedBox(height: 16),

          Consumer<GameCardCategoryProvider>(
            builder: (context, value, child) {
              if (value.isLoading) return Center(child: CircularProgressIndicator());
              return Expanded(
                  child: Column(
                children: [
                  if (value.inSearchMode && value.products.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 30),
                          scrollDirection: Axis.vertical,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            GameCardModel model = GameCardModel(
                              id: value.products[index].productId,
                              name: value.products[index].name,
                              image: value.products[index].image,
                              details: value.products[index].details,
                              price: value.products[index].price,
                              sku: value.products[index].sku,
                              // count: value.products[index].count,
                              // pinValue: value.products[index].pinValue,
                              // snValue: value.products[index].snValue,
                            );
                            return GameCardItemWidget(model);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 26,
                              ),
                          itemCount: value.products.length),
                    ),
                  if (value.products.isEmpty || !value.inSearchMode)
                    Expanded(
                      child: Container(
                        color:Colors.blue,
                        child: GridView.builder(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          shrinkWrap: true,
                          itemCount: value.items.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              child: MainCategoryItemWidget(),
                              value: value.items[index],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ));
            },
          )
        ],
      ),
    );
  }
}
