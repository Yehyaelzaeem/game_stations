import 'package:flutter/material.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/pages.dart';
import '../../repository/aboutPagesProvider.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_translate/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatefulWidget {
  String title,value;
  AboutUsPage(this.title,this.value);
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var aboutProvider = Provider.of<About>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        iconTheme: IconThemeData(color: appColor),
        title: Text(widget.title.toString(),
          style: GoogleFonts.cairo(color: appColor,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
      ),
      body:FutureBuilder(
          future: aboutProvider.getAbout(widget.value),
          builder: (context,AsyncSnapshot<List<PagesModel>> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Directionality(
                textDirection: Constant.lang=="ar"?TextDirection.rtl:
                TextDirection.ltr,
                child: Container(
                    alignment: Alignment.topCenter,
                    width:width,
                    height: height,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appColor,width: 1)),
                    padding: EdgeInsets.all(10),
                    child:SingleChildScrollView(
                      child: Html(data: snapshot.data!.first.description.toString()),
                    )
                ),);
            }
          }),
    );
  }
}
