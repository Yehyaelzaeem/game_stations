import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_translate/global.dart';
import 'package:provider/provider.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../data/game_card_category_provider.dart';
import 'edit_text_search.dart';

class GameCardCategoriesAppBar extends StatefulWidget {
  final String? title;
  const GameCardCategoriesAppBar({ this.title});

  @override
  _GameCardCategoriesAppBarState createState() => _GameCardCategoriesAppBarState();
}

class _GameCardCategoriesAppBarState extends State<GameCardCategoriesAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameCardCategoryProvider>(
      builder: (context, gameCardCategoryProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if (gameCardCategoryProvider.inSearchMode) {
              gameCardCategoryProvider.onSeachModeChange(!gameCardCategoryProvider.inSearchMode);
              return false;
            } else {
              return true;
            }
          },
          child: Column(
            children: [
              if (!gameCardCategoryProvider.inSearchMode)
                globalHeader(
                  context,
                  "${widget.title}",
                  showCart: true,
              
                  onSearchTap: () {
                    gameCardCategoryProvider.onSeachModeChange(!gameCardCategoryProvider.inSearchMode);
                  },
                  showSearch: true,
                ),
              //fade in animation for search bar

              if (gameCardCategoryProvider.inSearchMode)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      InkWell(
                          child: Container(
                            padding: EdgeInsets.all(6),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            if (gameCardCategoryProvider.searchQuery.isNotEmpty || gameCardCategoryProvider.searchController.text.isNotEmpty) {
                              gameCardCategoryProvider.onSearchQueryChange("");
                              gameCardCategoryProvider.searchController.text = "";
                              setState(() {});
                            } else {
                              gameCardCategoryProvider.onSeachModeChange(!gameCardCategoryProvider.inSearchMode);
                            }
                          }),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: EditTextSearch(
                                textEditingController: gameCardCategoryProvider.searchController,
                                hint: translate("store.search"),
                                updateFunc: (value) {
                                  gameCardCategoryProvider.onSearchQueryChange(value);
                                },
                                onFieldSubmitted: (value) {
                                  gameCardCategoryProvider.onSearchQueryChange(value);
                                  gameCardCategoryProvider.performSearch();
                                },
                              ),
                            ),
                            if (gameCardCategoryProvider.isSearching)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  child: LinearProgressIndicator(),
                                ),
                              )
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          color: Colors.transparent,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: appColor,
                          ),
                        ),
                        onTap: () {
                          if (gameCardCategoryProvider.inSearchMode) {
                            gameCardCategoryProvider.onSeachModeChange(!gameCardCategoryProvider.inSearchMode);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
