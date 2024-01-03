import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../core/shared_preference/shared_preference.dart';
import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../models/sliderModel.dart';
import 'root_pages.dart';
import '../repository/auth_user.dart';
import '../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChooseCountryPage extends StatefulWidget {
  const ChooseCountryPage({ Key? key}) : super(key: key);

  @override
  _ChooseCountryPageState createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  @override
  void initState() {
    l();
    // TODO: implement initState
    super.initState();
  }
  l()async{
    var res =await CacheHelper.saveDate(key: 'country', value: country);
  }
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var countryProvider = Provider.of<UserAuth>(context,listen: false);
    var countryP = Provider.of<CategoriesProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: height * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " " + translate("activity_setting.choose_country") + " ",
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              height: height * 0.7 + 10,
              child: FutureBuilder(
                  future: countryProvider.getCountries(true, context),
                  builder: (context, AsyncSnapshot<List<SliderModel>> snapshots) {
                    if (snapshots.data == null) {
                      return Container(
                        width: width,
                        height: height * 0.2,
                        child: Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (snapshots.hasData) {
                      return ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return s(index, width, height, "${snapshots.data![index].name}", "${snapshots.data![index].image}", "${snapshots.data![index].id}");
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: height * 0.02,
                            );
                          },
                          itemCount: snapshots.data!.length);
                    } else {
                      return Container(
                        width: width,
                        height: height * 0.2,
                        child: Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    countryProvider.country = country;
                    countryProvider.countryImage = countryImage;
                    countryP.country = country;
                    Constant.country = country;
                  });
                  Constant.cities.value.clear();
                  Constant.states.value.clear();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootPages()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: width * 0.3,
                  height: height * 0.07,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    translate("activity_setting.done"),
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColorTwo),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String country = "1";
  String countryName = "";
  String countryImage = "";
  Widget s(int index, double width, double height, String title, String image, String id) {
    return GestureDetector(
      onTap: () async{
        await CacheHelper.saveDate(key: 'isLog', value: true);
        setState(() {
          _index = index;
          country = id;
          Constant.country = id;
          countryImage = image;
          print("countryChoosed: " + Constant.country.toString());
          print("countryChoosed: " + countryImage.toString());
        });
      },
      child: Container(
        width: width,
        height: height * 0.08,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: colorWhite, border: index == _index ? Border.all(width: 1, color: appColor) : Border()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            m(index, width, height, "$title", "$image"),
            index == _index
                ? Icon(
                    Icons.check_circle_outline,
                    size: width * 0.1,
                    color: appColor,
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  Widget m(int index, double width, double height, String title, String image) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.02,
        ),
        image != null && image.toString().trim() != "null" && image.toString().trim().isNotEmpty
            ? Image.network(
                "$image",
                height: height * 0.06,
                width: width * 0.1 + 4,
                fit: BoxFit.cover,
              )
            : Image.asset("assets/images/home_1.png"),
        SizedBox(
          width: width * 0.05,
        ),
        Text(
          "$title",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  // Widget m(int index,double width,double height){
  //   if(index==0){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/egypt.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //          "مصر",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else if (index ==1 ){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/800px-Flag_of_Saudi_Arabia.svg.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "السعودية",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else if (index ==2 ){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/syria.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "سوريا",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else if (index ==3 ){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/lebanon.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "لبنان",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else if (index ==4 ){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/palestine.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "فلسطين",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else if (index ==5 ){
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/kuwait.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "الكويت",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }else {
  //     return Row(
  //       children: [
  //         SizedBox(
  //           width: width * 0.02,
  //         ),
  //         Image.asset(
  //           "assets/images/jordan.png",
  //           height: height * 0.06,
  //           width: width * 0.1 + 4,
  //           fit: BoxFit.cover,
  //         ),
  //         SizedBox(
  //           width: width * 0.05,
  //         ),
  //
  //         Text(
  //           "الاردن",
  //           style: GoogleFonts.cairo(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     );
  //   }
  // }

}
