import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../elements/small_Widgets.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/ProductDetails.dart';
import '../../models/sliderModel.dart';
import '../root_pages.dart';
import '../user/edit_ads.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({ Key? key}) : super(key: key);
  @override
  _SubscriptionPagePageState createState() => _SubscriptionPagePageState();
}

class _SubscriptionPagePageState extends State<SubscriptionPage> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      body: Constant.id!=null?
      SingleChildScrollView(
        padding: EdgeInsets.only(top: height*0.06),
        child: Column(
          children: [
            globalHeader(context,  translate("drawer.subscribe")),
            SizedBox(height: height*0.04,),
            Container(
              width: width ,
              height: height*0.06+4,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical:height*0.01 ),
              color: colorWhite,
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: new TabBar(
                  controller: _tabController,
                  tabs: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(translate("drawer.subscribe_now"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(translate("drawer.subscribe_old"),
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),),
                    ),
                  ],
                  isScrollable: true,
                  indicatorColor: appColor,
                  labelColor: appColor,
                  unselectedLabelColor:Colors.black54 ,
                  unselectedLabelStyle:
                  TextStyle(color: colorDark, fontSize: 18),
                  labelStyle: TextStyle(color: colorDark, fontSize: 18),
                  labelPadding: EdgeInsets.only(left: 4.5,right: 4.5),
                ),
              ),
            ),
            SizedBox(height: height*0.02,),
            Container(
              height: height*0.7,
              width: width,
              color: backGround,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  setSubscriptionKindWidget(height, width,context,"new_ads"),
                  setSubscriptionKindWidget(height, width,context,"old_ads"),
                ],
              ),
            ),
          ],
        ),
      ):
      PermissionDeniedWidget(),
    );
  }
  Widget setSubscriptionKindWidget(double height,double width,BuildContext context,String adsKind){
    var categoryProvider = Provider.of<CategoriesProvider>(context,listen: false);
    return Container(
      alignment: Alignment.topCenter,
      child: adsKind=="new_ads"?
      FutureBuilder(
        future: categoryProvider.mySubscriptions(),
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
                          height: height*0.2,
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${snapshot.data![index].name}",
                              style: GoogleFonts.cairo(
                                color: appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: width*0.04
                              ),),
                              SizedBox(height: height*0.01,),
                              Row(
                                children: [
                                  Text("${translate("drawer.subscribe_time")}",
                                  style: GoogleFonts.cairo(color: Colors.black45,
                                  ),),
                                  SizedBox(width: width*0.02,),
                                  Text("${translate("drawer.subscribe_price")} "
                                      "${snapshot.data![index].price}",
                                  style: GoogleFonts.cairo(color: Colors.black45,
                                  ),),
                                ],
                              ),
                              SizedBox(height: height*0.02,),
                              Text(translate("drawer.subscribe_date"),
                                style: GoogleFonts.cairo(
                                    color: appColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: width*0.04
                                ),),
                              SizedBox(width: width*0.02,),
                              Text("${snapshot.data![index].date}",
                                style: GoogleFonts.cairo(color: Colors.black45,
                                ),),
                            ],
                          ),
                        )
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height*0.03,);
                  },
                  itemCount: snapshot.data!.length),
            );
          }
        },
      ):SizedBox(),
    );
  }

}
