import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/drawer.dart';
import '../../elements/review.dart';
import '../../helper/showtoast.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllMerchantProducts extends StatefulWidget {
  const AllMerchantProducts({Key? key}) : super(key: key);

  @override
  _AllMerchantProductsState createState() => _AllMerchantProductsState();
}

class _AllMerchantProductsState extends State<AllMerchantProducts> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      backgroundColor: backGround,
      drawer: drawerWidget(context),
      appBar: PreferredSize(
        child: Container(
          height: height*0.2,
          alignment: Alignment.center,
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).padding.top
          ),
          child: new Padding(
            padding:  EdgeInsets.only(
                top: height*0.01,
                right: width*0.06,
                left: width*0.06,
                bottom: height*0.01
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap:(){
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Image.asset("assets/images/drawer.png",height: height*0.05,
                    width: width*0.05,),
                ),
                SizedBox(width: 2,),
                IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: appColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ),
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    backGround,
                    backGround
                  ]
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(height*0.08),
                bottomLeft: Radius.circular(height*0.08),
              ),

              boxShadow: [
                new BoxShadow(
                  color: backGround,
                  blurRadius: 50.0,
                  spreadRadius: 1.0,
                )
              ]
          ),
        ),
        preferredSize: new Size(
            MediaQuery.of(context).size.width,
            height*0.06
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: width,
                height: height*0.1+20,
                color: colorWhite,
                padding: EdgeInsets.symmetric(horizontal: width*0.04,
                    vertical: height*0.01),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height*0.05,
                          width: width*0.1,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/home_1.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 1),
                          ),
                        ),
                        SizedBox(width: width*0.05,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("جيمز",
                              style: GoogleFonts.cairo(color: Colors.black54,
                                  fontWeight: FontWeight.bold,fontSize: width*0.05),),
                            Text(" 35 "+translate("store.product"),
                              style: GoogleFonts.cairo(color: appColor,
                                  fontSize: width*0.04),),
                            reView(140,context),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_pin,color: appColor,
                              size: width*0.05,),
                            Text("الجيزة",style: GoogleFonts.cairo(
                              color: Colors.grey,
                            ),),
                          ],
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: appColor,
                            ),
                            padding: EdgeInsets.only(right: 12,left: 12,top: 5,bottom: 5),
                            child: Text(translate("store.follow"),
                              style: GoogleFonts.cairo(color: appColorTwo,
                                  fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height*0.02,),
            Container(
              height: height*0.8-34,
              width: width - 30,
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                                height: height*0.3-10,
                                color: backGround,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height*0.1+20,
                                      decoration: BoxDecoration(
                                        color: backGround,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(width*0.1+20),
                                            topLeft: Radius.circular(width*0.1+20)),
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/card_three.png"),
                                            fit: BoxFit.cover,alignment: Alignment.center),
                                      ),
                                    ),
                                    Container(
                                      height: height*0.1+30,
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))
                                      ),
                                      padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
                                      child: Column(
                                        children: [
                                          SizedBox(height: height*0.02,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("جهاز ps4 بضمان سنة",
                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                                    color: Colors.grey,fontSize: width*0.04),),
                                              Text("4600"+translate("store.bound"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                                color: appColor,),)
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.person,color: appColor,),
                                                  Text("جيمز",style: GoogleFonts.cairo(
                                                    color: Colors.grey,
                                                  ),)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_pin,color: appColor,
                                                    size: width*0.05,),
                                                  Text("الجيزة",style: GoogleFonts.cairo(
                                                    color: Colors.grey,
                                                  ),)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                )
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: appColor,
                                      ),
                                      padding: EdgeInsets.only(right: 12,left: 12,top: 5,bottom: 5),
                                      child: Text(translate("store.contact_with_seller"),
                                        style: GoogleFonts.cairo(color: appColorTwo,
                                            fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: appColor,
                                      ),
                                      padding: EdgeInsets.only(right: 12,left: 12,top: 5,bottom: 5),
                                      child: Icon(Icons.favorite_border,color: appColorTwo,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height*0.02,);
                  },
                  itemCount: 3),
            ),
          ],
        ),
      ),
    );
  }
}
