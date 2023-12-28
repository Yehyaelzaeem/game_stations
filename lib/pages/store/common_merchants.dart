import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/review.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/showtoast.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommonMerchantsPage extends StatefulWidget {
  const CommonMerchantsPage({Key? key}) : super(key: key);

  @override
  _CommonMerchantsPageState createState() => _CommonMerchantsPageState();
}

class _CommonMerchantsPageState extends State<CommonMerchantsPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Column(
          children: [
            globalHeader(context, translate("store.common_merchants")),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.6 + 50,
              width: width,
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        width: width,
                        height: height * 0.1 + 20,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: colorWhite),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.1,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/home_1.png"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(width: 1),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "جيمز",
                                      style: GoogleFonts.cairo(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: width * 0.05),
                                    ),
                                    Text(
                                      " 35 " + translate("store.product"),
                                      style: GoogleFonts.cairo(color: appColor, fontSize: width * 0.04),
                                    ),
                                    reView(140, context),
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
                                    Icon(
                                      Icons.location_pin,
                                      color: appColor,
                                      size: width * 0.05,
                                    ),
                                    Text(
                                      "الجيزة",
                                      style: GoogleFonts.cairo(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColor,
                                    ),
                                    padding: EdgeInsets.only(right: 12, left: 12, top: 5, bottom: 5),
                                    child: Text(
                                      translate("store.contact"),
                                      style: GoogleFonts.cairo(color: appColorTwo, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.02,
                    );
                  },
                  itemCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
