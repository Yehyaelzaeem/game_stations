import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper/showtoast.dart';

Widget cardHome(BuildContext context,String kind,String title,String imgPath){
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Container(
    width: width,
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: height*0.01),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            color: appColorTwo.withOpacity(0.2),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: width*0.2+20,
                        height: height*0.1+15,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:Image.asset("$imgPath"),
                      ),
                      onTap: (){
                      },
                    ),
                    SizedBox(height: height*0.02,),
                    Text("$title",
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                          color: appColor,fontSize: width*0.04),),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("قميص",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: appColor ),),
                        ),
                        SizedBox(width: width*0.03,),
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("قميص",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: appColor ),),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("قميص",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: appColor ),),
                        ),
                        SizedBox(width: width*0.03,),
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("قميص",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: appColor ),),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("جاكيت",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: colorWhite ),),
                        ),
                        SizedBox(width: width*0.03,),
                        Container(
                          padding: EdgeInsets.only(left: 17,right: 17,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("قميص",style:
                          GoogleFonts.cairo(fontSize:width*0.04,color: appColor ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:2,),
          Container(
            height: height*0.2+30,
            width: width,
            child:ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    color: colorWhite,
                    child: Container(
                      width: width-67,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: width*0.02,),
                          Container(
                            height: height*0.2+10,width: width*0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/summer-collection-sale-banner-style_23-2148520739.png"
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(width: width*0.04,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("جاكيت نبيتى ",
                                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                                        fontSize: width*0.05,color: Colors.black45),),
                                  SizedBox(width: width*0.02,),
                                  IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.favorite_border,color: appColor,),),
                                ],
                              ),
                              Text("450${translate("store.bound")}",style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  color: appColor,fontSize: width*0.04
                              ),),
                              Row(
                                children: [
                                  Text("490${translate("store.bound")}",
                                    style: GoogleFonts.cairo(decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold,color: Colors.black38),),
                                  SizedBox(width: width*0.02,),
                                  Text("خصم 10%"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  Text("محمد ياسر"),
                                ],
                              ),
                              SizedBox(height: height*0.01,),
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: appColor
                                  ),
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  child: Text(translate("activity_cart.add_cart"),
                                    style: GoogleFonts.cairo(color: colorWhite),),
                                ),
                              ),
                              SizedBox(height: 3,),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: width*0.03,);
                }, itemCount: 4),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {

                },
                child: Text(
                  'عرض الكل',
                  style: TextStyle(
                      color: appColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: appColor,
                size: width*0.06,
              )
            ],
          ),
          SizedBox(height: height*0.01,),
        ],
      ),
    ),
  );
}