import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/chat_model.dart';
import '../../repository/chat/chat.dart';
import 'package:provider/provider.dart';

import '../../repository/messageCountProvider.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String? kind_room,
      user_id,
      user_name,
      message_to,
      saller_name,
      saller_id,
      message_from,
      chatRoomId;
  // ignore: non_constant_identifier_names
  bool? saller_page;
  // ignore: non_constant_identifier_names
  ChatPage(
      {this.saller_page,
      this.kind_room,
      this.user_id,
      // ignore: non_constant_identifier_names
      this.user_name,
      this.message_to,
      this.saller_name,
      this.saller_id,
      this.message_from,
      this.chatRoomId});
  @override
  _ChatState createState() => _ChatState();
}

List<int> listunseen = [];

class _ChatState extends State<ChatPage> {
  // ignore: non_constant_identifier_names
  String order_id = "";
  TextEditingController messageEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: appColor,
        automaticallyImplyLeading: false,
        title: Text(
          translate("chat.title"),
          style: TextStyle(color: colorWhite),
        ),
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorWhite, opacity: 12, size: 25),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // widget.saller_page==true?
            // Expanded(
            //     child: FutureBuilder(
            //       future: chatProvider.getChatMessages("${widget.chatRoomId}"),
            //       builder: (context,AsyncSnapshot<List<ChatModel>> snapshot){
            //         return snapshot.hasData ?  ListView.builder(
            //             itemCount: snapshot.data.length,
            //             reverse: true,
            //             itemBuilder: (context, index){
            //               return MessageTile(
            //                 message: snapshot.data[index].message.toString(),
            //                 sendByMe: Constant.id == snapshot.data[index].from.toString(),
            //                 timeshow: snapshot.data[index].time.toString(),
            //               );
            //             }) : Container();
            //       },
            //     )
            // ):
            Expanded(
                child: FutureBuilder(
              future: widget.kind_room == "room_id"
                  ? chatProvider.getChatMessages("${widget.chatRoomId}")
                  : chatProvider.getChatMessagesByID(
                      "${widget.saller_id}", "${Constant.id}"),
              builder: (context, AsyncSnapshot<List<ChatModel>> snapshot) {
                Provider.of<MassageCountProvider>(context, listen: false)
                    .messageCount();

                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            message: snapshot.data![index].message.toString(),
                            sendByMe: Constant.id !=
                                snapshot.data![index].to.toString(),
                            timeshow: snapshot.data![index].time.toString(),
                          );
                        })
                    : Container();
              },
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.black45,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                            hintText: translate("chat.type_message"),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (widget.saller_page == true) {
                            await chatProvider
                                .sendMessage(
                              message: messageEditingController.text
                                  .toString()
                                  .trim(),
                              messageTo: "${widget.saller_id}",
                            )
                                .then((value) {
                              if (value == "yes") {
                                setState(() {
                                  messageEditingController.text = "";
                                });
                              }
                            });
                          } else {
                            await chatProvider
                                .sendMessage(
                              message: messageEditingController.text
                                  .toString()
                                  .trim(),
                              messageTo: "${widget.saller_id}",
                            )
                                .then((value) {
                              if (value == "yes") {
                                setState(() {
                                  messageEditingController.text = "";
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40)),
                            child: Icon(
                              Icons.send,
                              color: appColor,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String? message;
  final bool? sendByMe;
  final String? timeshow;
  MessageTile({ this.message,  this.sendByMe, this.timeshow});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 5, bottom: 5, left: sendByMe! ? 0 : 24, right: sendByMe! ? 24 : 0),
      alignment: sendByMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe! ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe!
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: sendByMe! ? appColor : Theme.of(context).primaryColorLight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$message",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: sendByMe! ? colorWhite : Theme.of(context).hintColor,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 3,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${timeshow.toString().split("&").last.toString()}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color:
                          sendByMe! ? colorWhite : Theme.of(context).hintColor,
                      fontSize: 10,
                      fontFamily: 'OverpassRegular',
                    )),
                //   Visibility(
                //    visible: (DateTime.now().year.toString()+":"+DateTime.now().month.toString()
                //       +":"+DateTime.now().day.toString()).toString() ==timeshow.toString().split("&").first.toString()?false:true,
                //     child:Text("${timeshow.toString().split("&").first.toString()}",
                //       textAlign: TextAlign.start,
                //       style: TextStyle(
                //         color: sendByMe?Theme.of(context).primaryColor:Theme.of(context).hintColor,
                //         fontSize: 9,
                //         fontFamily: 'OverpassRegular',
                //       )),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
