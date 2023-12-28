import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/sliderModel.dart';
import '../../repository/auth_user.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MarketSubscriptionPage extends StatefulWidget {
  const MarketSubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<MarketSubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context,listen: false);
    var userProvider = Provider.of<UserAuth>(context,listen: false);
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: height*0.05),
        child: Column(
          children: [
            globalHeader(context, translate("store.packages_merchants")),
            SizedBox(height: height*0.04,),
            Container(
              height: height*0.8,
              alignment: Alignment.topCenter,
              child:  FutureBuilder(
                future: categoryProvider.getSubscriptions(),
                builder: (context,AsyncSnapshot<List<SliderModel>> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator(backgroundColor: appColor,));
                  } else {
                    return  snapshot.data!.length==0?
                    Center(child:Text(translate("drawer.no_subscribe",),
                      style: TextStyle(color: appColor),)):
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                child:Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: colorWhite
                                  ),
                                  height: Constant.subscribe==true?height*0.3-20:height*0.4-20,
                                  width: width-100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                                              topRight:Radius.circular(20) ),
                                          color: appColor.withOpacity(0.6),
                                        ),
                                        height: height*0.06,
                                        width: width-100,
                                        alignment: Alignment.center,
                                        child: Text("${snapshot.data![index].name}",style: GoogleFonts.cairo(fontSize: width*0.04+3,
                                            color:appColorTwo,fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: height*0.01,),
                                      Column(
                                        children: [
                                          Text("${snapshot.data![index].time} ${translate("drawer.days")}",style: GoogleFonts.cairo(fontSize: width*0.04+3,
                                              color:colorDark,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height*0.01,),
                                          Text("اعلانات مثبتة",style: GoogleFonts.cairo(fontSize: width*0.03+3,
                                            color:Colors.grey,),),
                                        ],
                                      ),
                                      SizedBox(height: height*0.01,),
                                      Divider(color: backGround,thickness: height*0.01-2,),
                                      SizedBox(height: height*0.02,),
                                      Column(
                                        children: [
                                          Text("${snapshot.data![index].price}"+translate("store.bound"),style: GoogleFonts.cairo(fontSize: width*0.04+5,
                                              color:appColor,fontWeight: FontWeight.bold),),
                                          Constant.subscribe!=true?
                                          SizedBox(height: height*0.02,):SizedBox(),
                                          Constant.subscribe!=true?
                                          GestureDetector(
                                            onTap: ()async{
                                              if(Constant.subscribe!=true) {
                                                await categoryProvider
                                                    .addSubscribe(
                                                    context: context,
                                                    backageID: "${snapshot
                                                        .data![index].id}"
                                                ).then((value) async{
                                                  await userProvider.userProfile().then((value) {
                                                    setState(() {
                                                      Constant.subscribe = true;
                                                    });
                                                  });
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: appColor,
                                              ),
                                              width: width*0.4,
                                              height: height*0.05,
                                              alignment: Alignment.center,
                                              child: Text(translate("drawer.add_subscribe"),style: GoogleFonts.cairo(
                                                  color: appColorTwo,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width*0.05
                                              ),),
                                            ),
                                          ):SizedBox(),
                                          Constant.subscribe!=true?
                                          SizedBox(height: height*0.01,):SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: height*0.03,);
                          },
                          itemCount: snapshot.data!.length),
                    );
                  }
                },
              ),
            )


          ],
        ),
      ),
    );
  }
}
