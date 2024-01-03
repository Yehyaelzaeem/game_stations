import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gamestation/pages/games_cards/categories/games_cards_main_categories.dart';
import 'package:gamestation/pages/games_cards/products/game_card_details.dart';
import 'package:gamestation/pages/games_cards/screens/orders_screen.dart';
import 'package:gamestation/pages/games_cards/sub_categories/games_cards_sub_categories.dart';
import 'package:gamestation/pages/home.dart';
import 'package:gamestation/pages/slider.dart';
import 'package:gamestation/pages/user/add_games_club.dart';
import 'package:gamestation/pages/user/edit_ads.dart';
import 'package:gamestation/pages/user/edit_game_club.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_config/providers.dart';
import 'core/network/dio.dart';
import 'core/shared_preference/shared_preference.dart';
import 'helper/checkUser.dart';
import 'models/Constant.dart';
import 'pages/games_cards/cart/cart_screen.dart';
import 'pages/games_cards/products/games_cards_list_screen.dart';
import 'pages/root_pages.dart';
import 'pages/splash.dart';
import 'repository/firebaseNotifications.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await DioHelper.init();
  await GlobalConfiguration().loadFromAsset("configurations");
  await checkUser();
  await checkUser();
  if (Constant.lang == null || Constant.lang == "null") Constant.lang = "ar";
  var delegate = await LocalizationDelegate.create(fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ar']);
  await FirebaseNotifications().setUpFirebase();

  runApp(LocalizedApp(delegate, MyApp()));
  Eraser.clearAllAppNotifications();
}

class MyApp extends StatelessWidget {
  final String? check;
  MyApp({this.check});
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return MultiProvider(
      providers: ProvidersList.getProviders,
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Game Station',
            theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
                bodyText1: GoogleFonts.cairo(textStyle: Theme.of(context).textTheme.bodyText1, fontWeight: FontWeight.bold),
              ),
            ),
          localizationsDelegates:  [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate
          ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: Constant.lang == "ar" ? Locale("ar") : Locale("en_US"),
            routes: {
              GamesCardMainCategoriesScreen.routeName: (context) => GamesCardMainCategoriesScreen(),
              GamesCardSubCategoriesScreen.routeName: (context) => GamesCardSubCategoriesScreen(),
              GamesCardsListScreen.routeName: (context) => GamesCardsListScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              // GameCardDetailsScreen.routeName: (context) => GameCardDetailsScreen(),
            },
          home:
          SplashPage(),
          // SplashPage(),
          //   home: this.check != null
          //       ? RootPages(
          //           checkPage: this.check,
          //         )
          //       : SplashPage()
            // SplashScreen(
            //   seconds: 5,
            //   navigateAfterSeconds:Constant.token==null?
            //   SliderPage(): RootPages(checkPage: this.check,),
            //   backgroundColor: colorWhite,
            //   styleTextUnderTheLoader: new TextStyle(),
            //   photoSize: 150,
            //   onClick: ()=>print("gamestation"),
            //   loaderColor: appColor,
            //   title: Text("Game Station",style: GoogleFonts.cairo(
            //     fontWeight: FontWeight.bold,color: colorDark,fontSize: 20
            //   ),),
            //   image: Image.asset("assets/images/home_1.png",
            //     alignment: Alignment.center,
            //     height: 150,fit: BoxFit.contain,),
            // ),

            ),
      ),
    );
  }
}
