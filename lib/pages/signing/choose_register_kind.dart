import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../root_pages.dart';
import 'login_screen.dart';

class ChooseRegisterKind extends StatefulWidget {
  const ChooseRegisterKind({Key? key}) : super(key: key);

  @override
  _ChooseRegisterKindState createState() => _ChooseRegisterKindState();
}

class _ChooseRegisterKindState extends State<ChooseRegisterKind> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
          )
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: height*0.06,left: width*0.05,
              right:width*0.05 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Text("عربى",style: GoogleFonts.cairo(fontSize: width*0.05,
                        fontWeight: FontWeight.bold,
                        color: colorWhite)),
                    onTap: (){

                    },
                  ),
                  GestureDetector(
                    child: Text("EN",style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,fontSize: width*0.05,
                        color: colorWhite)),
                    onTap: (){

                    },
                  ),
                ],
              ),
              SizedBox(height: height*0.2-10,),
              Image.asset("assets/images/summer-collection-sale-banner-style_23-2148520739.png",
                alignment: Alignment.topCenter,
                height: height*0.4-30,fit: BoxFit.contain,),
              SizedBox(height: height*0.01,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: width*0.2+20,
                          height: height*0.1+10,
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Image.asset("assets/images/seller.png"),
                        ),
                        onTap: (){
                          setState(() {
                            Constant.userName="market";
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder:
                              (context)=>LoginScreen()));
                        },
                      ),
                      SizedBox(height: height*0.02,),
                      Text(translate("store.market"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                            color: colorWhite,fontSize: width*0.05),),
                    ],
                  ),
                  SizedBox(width: width*0.07,),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: width*0.2+20,
                          height: height*0.1+10,
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Image.asset("assets/images/buyer.png"),
                        ),
                        onTap: (){
                          setState(() {
                            Constant.userName="consumer";
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder:
                              (context)=>LoginScreen()));
                        },
                      ),
                      SizedBox(height: height*0.02,),
                      Text(translate("store.consumer"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                      color: colorWhite,fontSize: width*0.05),),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height*0.04,),
              GestureDetector(
                child: Text(translate("button.skip"),style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                    color: colorWhite,fontSize: width*0.06,decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder:
                      (context)=>RootPages()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
