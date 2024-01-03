import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../../../models/game_card_category_model.dart';
import '../categories/game_card_item_widget.dart';
import '../data/game_card_provider.dart';

class GamesCardsListScreen extends StatelessWidget {
  static const routeName = "/games_card_list_screen";
  @override
  Widget build(BuildContext context) {

    GameCardCategoryModel model = ModalRoute.of(context)!.settings.arguments as GameCardCategoryModel;
    return FutureBuilder<void>(
      future: Provider.of<GameCardProvider>(context, listen: false).fetchData(model.id!),
      builder: (context, sp) {
        if (sp.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          backgroundColor: backGround,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 38),
              globalHeader(context, model.name!, showCart: true),
              if (model.subCategoryList!.isEmpty) SizedBox(height: 40),
              Expanded(
                child: Consumer<GameCardProvider>(builder: (context, snapshot, child) {
                  if (snapshot.items.isEmpty) return Center(child: Text(' No Products Available'));
                  return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 30),
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: snapshot.items[index],
                          child: GameCardItemWidget(snapshot.items[index]),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 26,
                          ),
                      itemCount: snapshot.items.length);
                }),
              )
            ],
          ),
        );
      },
    );
  }
}
