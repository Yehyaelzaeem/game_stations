import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/chat_model.dart';
import '../chat/chat.dart';
import '../../repository/chat/chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var chatProvider = Provider.of<ChatProvider>(context);
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          return Future.value(false);
        } ,
        child: Scaffold(
            body:
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: height*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height*0.05,),
                  globalHeader(context, translate("profile.chat_list")),
                  // SizedBox(height: height*0.03,),
                  // Card(
                  //     color: colorWhite,
                  //     margin: EdgeInsets.symmetric(horizontal: width*0.1),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       side: BorderSide(color: appColor,width: 1)
                  //     ),
                  //     child:Container(
                  //       width: width ,
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.only(right: 5,),
                  //       child: TextField(
                  //         autocorrect: true,
                  //         controller: _searchEditingController,
                  //         decoration: InputDecoration(
                  //           hintText: translate("home.search"),
                  //           counterStyle: GoogleFonts.cairo(
                  //               fontWeight: FontWeight.bold
                  //           ),
                  //           prefixIcon: Icon(Icons.search_rounded,
                  //             color: Colors.grey,size: width*0.06,),
                  //           hintStyle: TextStyle(color: Colors.black45),
                  //           filled: true,
                  //           fillColor: colorWhite,
                  //           contentPadding: EdgeInsets.only(top: 0),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  //             borderSide: BorderSide(color: colorWhite, width: 2),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //             borderSide: BorderSide(color: colorWhite, width: 2),
                  //           ),
                  //         ),
                  //         onSubmitted: (_){
                  //
                  //         },
                  //       ),
                  //     ),
                  // ),
                  SizedBox(height: height*0.02,),
                  Constant.token!=null&&Constant.token.toString()!="null"
                      &&Constant.token.toString()!=""?
                  Container(
                    alignment: Alignment.topCenter,
                    width:width,
                    height: height*0.8,
                    child: FutureBuilder(
                      future: chatProvider.getRooms(),
                      builder: (context,AsyncSnapshot<List<ChatModel>> snapshot) {
                        if (snapshot.data == null) {
                          return Center(child: CircularProgressIndicator(backgroundColor: appColor,));
                        } else {
                          return ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return  GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder:
                                        (context)=>ChatPage(
                                      chatRoomId: "${snapshot.data![index].id}",
                                      saller_id: "${snapshot.data![index].saller_id}",
                                      kind_room: "room_id",
                                      saller_name: "${snapshot.data![index].to}",
                                    )));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    color: appColorTwo.withOpacity(0.2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            snapshot.data![index].saller_image.toString()
                                                =="null"?
                                            Container(
                                              height: height*0.06,
                                              width: width*0.1+10,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage("assets/images/home.png"),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(width: 1),
                                              ),
                                            ):  Container(
                                              child:  FadeInImage(
                                                image:
                                                NetworkImage("${snapshot.data![index].saller_image}"),
                                                placeholder: AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                imageErrorBuilder:
                                                    (context, error, stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/error.jpg',
                                                      fit: BoxFit.fitWidth);
                                                },
                                                fit: BoxFit.fitWidth,
                                              ),
                                              height: height*0.06,
                                              width: width*0.1+10,
                                              decoration: BoxDecoration(
                                                // image: DecorationImage(
                                                //   image:
                                                //
                                                //   NetworkImage("${snapshot.data![index].saller_image}"),
                                                //   fit: BoxFit.cover,
                                                // ),
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(width: 1),
                                              ),

                                            ),
                                            SizedBox(width: width*0.05,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width*0.3,
                                                  child: Text("${snapshot.data![index].to}",
                                                    style: GoogleFonts.cairo(color: appColor,
                                                        fontWeight: FontWeight.bold,fontSize: width*0.05),
                                                    overflow: TextOverflow.ellipsis,),
                                                ),
                                                Text("  ..",style: GoogleFonts.cairo(color: Colors.black54,
                                                    fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text("${snapshot.data![index].time}",style: GoogleFonts.cairo(color: Colors.black54,
                                            fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                );
                              }, separatorBuilder: (context, index) {
                            return SizedBox(height: height*0.02,);
                          }, itemCount: snapshot.data!.length);
                        }
                      },
                    ),
                  ):
                  PermissionDeniedWidget(),

                ],
              ),
            )
        )
    );

  }
  TextEditingController _searchEditingController = new TextEditingController();

}
