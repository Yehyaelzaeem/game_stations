import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../helper/getCitiesProvider.dart';
import '../models/game_card_category_model.dart';
import '../pages/games_cards/cart/cart_provider.dart';
import '../pages/games_cards/data/game_card_category_provider.dart';
import '../pages/games_cards/data/game_card_provider.dart';
import '../provider/edit_product._provider.dart';
import '../repository/aboutPagesProvider.dart';
import '../repository/auth_user.dart';
import '../repository/categories.dart';
import '../repository/chat/chat.dart';
import '../repository/fav_cart.dart';
import '../repository/messageCountProvider.dart';
import '../repository/order.dart';
import '../repository/update_fmc_token_provider.dart';

class ProvidersList {
  static List<SingleChildWidget> getProviders = [
    ChangeNotifierProvider(create: (context) => UserAuth()),
    ChangeNotifierProvider(create: (context) => FavAndCart()),
    ChangeNotifierProvider(create: (context) => CategoriesProvider()),
    ChangeNotifierProvider(create: (context) => Order()),
    ChangeNotifierProvider(create: (context) => About()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => MassageCountProvider()),
    ChangeNotifierProvider(create: (context) => CitiesProvider()),
    ChangeNotifierProvider.value(value: EditProductProvider()),
    ChangeNotifierProvider.value(value: GameCardCategoryProvider()),
    ChangeNotifierProvider.value(value: GameCardProvider()),
    ChangeNotifierProvider.value(value: CartProvider()),
    ChangeNotifierProvider.value(value: UpdateFMCTokenProvider()),
    ChangeNotifierProvider.value(value: GameCardCategoryModel())
  ];
}
