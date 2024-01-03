import 'package:flutter/material.dart';
import 'package:introduction_slider/source/presentation/pages/introduction_slider.dart';
import 'package:introduction_slider/source/presentation/widgets/background_decoration.dart';
import 'package:introduction_slider/source/presentation/widgets/buttons.dart';
import 'package:introduction_slider/source/presentation/widgets/dot_indicator.dart';
import 'package:introduction_slider/source/presentation/widgets/introduction_slider_item.dart';
import 'package:provider/provider.dart';
import '../helper/showtoast.dart';
import '../models/silde_model.dart';
import '../models/sliderModel.dart';
import '../repository/categories.dart';
import 'choose_country.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import 'home.dart';
class SliderPage extends StatefulWidget {
  const SliderPage({ Key? key}) : super(key: key);
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  List slides = [];

  @override
  void initState() {
    _loading();
    super.initState();
    //
    // slides.add(
    //   SliderItemModel(
    //     title: "Game Station",
    //     description:
    //     "Never Play Alone",
    //     pathImage: "assets/images/home_1.png",
    //     backgroundImage: "assets/images/1-2.png",
    //     backgroundColor: backGround,
    //   //   styleTitle: GoogleFonts.cairo(
    //   //       fontWeight: FontWeight.bold, color: appColor, fontSize: 24),
    //   //   styleDescription: GoogleFonts.cairo(
    //   //       fontWeight: FontWeight.bold, color: appColorTwo, fontSize: 21),
    //   // ),
    // ),);
    // slides.add(
    //   SliderItemModel(
    //     title: "Game Station",
    //     description:
    //     "Never Play Alone",
    //     pathImage: "assets/images/home_1.png",
    //     backgroundColor: backGround,
    //     backgroundImage: "assets/images/1 – 3.png",
    //     // styleTitle: GoogleFonts.cairo(
    //     //     fontWeight: FontWeight.bold, color: appColor, fontSize: 24),
    //     // styleDescription: GoogleFonts.cairo(
    //     //     fontWeight: FontWeight.bold, color: appColorTwo, fontSize: 21),
    //   ),
    // );
    // slides.add(
    //   SliderItemModel(
    //     title: "Game Station",
    //     description:
    //     "Never Play Alone",
    //     pathImage: "assets/images/home_1.png",
    //     backgroundImage: "assets/images/1-2.png",
    //     backgroundColor: backGround,
    //     // styleTitle: GoogleFonts.cairo(
    //     //     fontWeight: FontWeight.bold, color: appColor, fontSize: 24),
    //     // styleDescription: GoogleFonts.cairo(
    //     //     fontWeight: FontWeight.bold, color: appColorTwo, fontSize: 21),
    //   ),
    // );
  }

  void onDonePress() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseCountryPage()));
  }
  _loading()async{
    Provider.of<CategoriesProvider>(context, listen: false).getSlider();
    await getFreeAds();
  }
  int i =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           body:Stack(
             children: [
               IntroductionSlider(
                 initialPage: i,
                 items: [
                   IntroductionSliderItem(
                     backgroundImageDecoration: BackgroundImageDecoration(
                       image: AssetImage('assets/images/1-2.png'),
                       fit: BoxFit.cover,
                     ),
                     backgroundColor: backGround,
                   ),
                   IntroductionSliderItem(
                     backgroundImageDecoration: BackgroundImageDecoration(
                       image: AssetImage('assets/images/1 – 3.png'),
                       fit: BoxFit.cover,
                     ),
                     backgroundColor: backGround,
                   ),
                   IntroductionSliderItem(
                     backgroundImageDecoration: BackgroundImageDecoration(
                       image: AssetImage('assets/images/1 – 4.png'),
                       fit: BoxFit.cover,
                     ),
                     backgroundColor: Colors.blue,
                   ),
                 ],
                 done: Done(
                   child: Text('DONE',
                     style: GoogleFonts.cairo(
                         fontWeight: FontWeight.w700, color: colorWhite, fontSize: 20),
                   ),
                   home: ChooseCountryPage(),
                 ),
                 next: Next(child: Text('NEXT',
                   style: GoogleFonts.cairo(
                       fontWeight: FontWeight.bold, color: colorWhite, fontSize: 20),
                 )),
                 // back: Back(child:  Text('SKIP', style: GoogleFonts.cairo(
                 //     fontWeight: FontWeight.bold, color: colorWhite, fontSize: 20),
                 // )),
                 dotIndicator: DotIndicator(size: 10,selectedColor:Colors.blue.shade900,unselectedColor: Colors.blue.shade900),
               ),
               Positioned(
                   bottom:MediaQuery.of(context).size.height*0.05,
                   right: 15,
                   left: MediaQuery.of(context).size.width*0.8,
                   child:InkWell(
                     onTap: (){
                       Navigator.of(context)
                           .push(MaterialPageRoute(builder: (context) => ChooseCountryPage()));
                       // setState(() {
                       //   i=2;
                       // });
                     },
                     child: Text('SKIP', style: GoogleFonts.cairo(
                         fontWeight: FontWeight.bold, color: colorWhite, fontSize: 25),
                     ),
                   ))
             ],
           )
        );
            // return  IntroSlider(
    //   listContentConfig: this.slides,
    //   onDonePress: this.onDonePress,
    //   stylePrevBtn: GoogleFonts.cairo(
    //       fontWeight: FontWeight.bold, color: colorWhite, fontSize: 20),
    //   styleSkipBtn: GoogleFonts.cairo(
    //       fontWeight: FontWeight.bold, color: colorWhite, fontSize: 20),
    //   styleDoneBtn: TextStyle(color: colorWhite),
    //   scrollPhysics: BouncingScrollPhysics(),
    //   colorActiveDot: appColor,
    //   colorDot: appColor,
    // );
  }
}
