import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:provider/provider.dart';

import '../core/shared_preference/shared_preference.dart';
import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../repository/categories.dart';
import 'root_pages.dart';
import 'slider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();
    _loadWidget();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = Tween<Offset>(
      begin: Offset(0.0, 0.9),
      end: Offset.zero,
    ).animate(_animationController!);
    _animationController!.forward().whenComplete(() {
      // when animation completes, put your code here
    });
  }

  final splashDelay = 2550;
  _loadWidget() async {
    // try {
    //   Provider.of<CategoriesProvider>(context, listen: false).getSlider();
    // } catch (e) {
    //   print(e.toString());
    // }
    var _duration = Duration(milliseconds: splashDelay);
    Provider.of<CategoriesProvider>(context, listen: false).getSlider();
    return Timer(_duration, navigationPage);
  }


   navigationPage() async{
     var res =await CacheHelper.getDate(key: 'country');
     Constant.country = res;
     if(res !=null){
       if (Platform.isIOS) FlutterAppBadger.removeBadge();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
   RootPages()));
     }
     else{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
       SliderPage() ));
     }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backGround,
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                "assets/images/splash_bk.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: height * 0.2,
                left: width * 0.1,
                child: SlideTransition(
                  position: _animation!,
                  child: AnimatedContainer(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    duration: Duration(seconds: 0),
                    child: Image(
                      height: height * 0.2 + 20,
                      width: width * 0.8 + 10,
                      fit: BoxFit.contain,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         width: width*0.6,
              //         child: TextLiquidFill(
              //           text: 'Game Station',
              //           waveColor: appColor,
              //           waveDuration: Duration(seconds: 2),
              //           boxBackgroundColor: Colors.white,
              //           textStyle: TextStyle(
              //               fontSize: width*0.07+2,
              //               fontWeight: FontWeight.bold,
              //               color: colorWhite
              //           ),
              //           boxHeight: height*0.09,
              //         ),
              //       ),
              //       SizedBox(height: height*0.03,),
              //       Container(
              //         width: width*0.6,
              //         alignment: Alignment.center,
              //         child: DefaultTextStyle(
              //           style: const TextStyle(
              //             fontSize: 16.0,
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           child: AnimatedTextKit(
              //             animatedTexts: [
              //               WavyAnimatedText('Never Play Alone'),
              //             ],
              //             isRepeatingAnimation: false,
              //             onTap: () {
              //               print("Tap Event");
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          )),
    );
  }
}
