import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../helper/getCitiesProvider.dart';
import '../../helper/getlocation.dart';
import '../../helper/labeled_bottom_sheet.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/sliderModel.dart';
import '../../repository/categories.dart';
import '../show_on_map.dart';
import '../store/game_store.dart';

class EditGameClubPage extends StatefulWidget {
  String? id, title, imageOne, imageTwo, description, price, catID, lat, lng, country_id, city_id, state_id, address, phone, imgID;
  List<SliderModel>? images;
  EditGameClubPage(
      {this.id,
      this.title,
      this.imageOne,
      this.imageTwo,
      this.description,
      this.price,
      this.catID,
      this.lat,
      this.lng,
      this.city_id,
      this.country_id,
      this.address,
      this.state_id,
      this.phone,
      this.imgID,
      this.images});
  @override
  _EditGameClubPageState createState() => _EditGameClubPageState();
}

class _EditGameClubPageState extends State<EditGameClubPage> {
  ScrollController? scrollController;
  bool enableUpdate = false;
  @override
  void initState() {
    scrollController = new ScrollController();
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsDeptKind = _getDropDownMenuItemsDeptKind();
    titleTextController.text = widget.title.toString().replaceAll("null", "").toString().trim();
    descriptionTextController.text = widget.description.toString().replaceAll("null", "").toString().trim();
    locationTextController.text = widget.address.toString().replaceAll("null", "").toString().trim();
    phoneTextController.text = widget.phone.toString().replaceAll("null", "").toString().trim();
    _statusSelState = widget.state_id!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
        backgroundColor: backGround,
        appBar: AppBar(
          iconTheme: IconThemeData(color: appColor, opacity: 12, size: 25),
          backgroundColor: colorWhite,
          title: Text(
            translate("store.edit_game"),
            style: GoogleFonts.cairo(color: appColor, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: [
            Visibility(
              visible: enableUpdate == false ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: appColor,
                          ),
                          onPressed: () {
                            if (enableUpdate == true) {
                              setState(() {
                                enableUpdate = false;
                              });
                            } else {
                              setState(() {
                                enableUpdate = true;
                                titleTextController.text = widget.title.toString();
                                descriptionTextController.text = widget.description.toString();
                                locationTextController.text = widget.address.toString().replaceAll("null", "").toString();
                                phoneTextController.text = widget.phone.toString();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: Scrollbar(
          thickness: width * 0.02,
          thumbVisibility: true,
          radius: Radius.circular(10),
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: height * 0.1 + 43,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: backGround,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            translate("store.product_name"),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                          width: width * 0.9,
                          height: height * 0.1 - 40,
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: titleTextController,
                            textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: backGround),
                                ),
                                hintText: "${widget.title}",
                                focusColor: backGround,
                                focusedBorder: InputBorder.none,
                                enabled: enableUpdate == true ? true : false),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2 - 10,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Icon(Icons.circle,color: backGround,),
                      //     SizedBox(width: width*0.02,),
                      //     Text(translate("store.add_image"),style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                      //         color: Colors.black54),),
                      //   ],
                      // ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        height: height * 0.09,
                        width: width,
                        child: ListView.separated(
                          itemCount: widget.images!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.center,
                              child: enableUpdate == true
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                          onTap: () async {
                                            await selectImage().then((value) {
                                              setState(() {
                                                imageFileUpload!.add(value.absolute);
                                              });
                                            });
                                          },
                                          child: imageFileUpload == null || imageFileUpload!.length == 0
                                              ? Image.asset(
                                                  "assets/images/photo.png",
                                                  width: width * 0.2,
                                                  height: height * 0.09,
                                                  fit: BoxFit.fill,
                                                )
                                              : imageFileUpload!.length > index && imageFileUpload != null
                                                  ? Image.file(
                                                      imageFileUpload![index] == null ? imageFileUpload![index + 1] : imageFileUpload![index],
                                                      width: width * 0.2,
                                                      height: height * 0.09,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.network(
                                                      widget.images![index].image.toString(),
                                                      width: width * 0.2,
                                                      height: height * 0.09,
                                                      fit: BoxFit.fill,
                                                    )))
                                  : Image.network(
                                      widget.images![index].image.toString(),
                                      width: width * 0.2,
                                      height: height * 0.09,
                                      fit: BoxFit.fill,
                                    ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: width * 0.04,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.1 + 43,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: backGround,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            translate("store.phone"),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Container(
                          width: width * 0.9,
                          height: height * 0.1 - 40,
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: phoneTextController,
                            textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backGround),
                              ),
                              focusColor: backGround,
                              focusedBorder: InputBorder.none,
                            ),
                            keyboardType: TextInputType.phone,
                          )),
                    ],
                  ),
                ),
                // SizedBox(height: height*0.02,),
                // Container(
                //   height: height*0.1+43,
                //   width:width,
                //   padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.02),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     color: colorWhite,
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Icon(Icons.circle,color: backGround,),
                //           SizedBox(width: width*0.02,),
                //           Text(translate("store.location"),style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                //               color: Colors.black54),),
                //         ],
                //       ),
                //       SizedBox(height: height*0.02,),
                //       Container(
                //           width: width * 0.9,
                //           height: height*0.1-30,
                //           decoration: BoxDecoration(
                //               color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
                //           child: TextFormField(
                //             controller: locationTextController,
                //             textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                //             decoration: InputDecoration(
                //                 contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                //                 border: OutlineInputBorder(
                //                   borderRadius: BorderRadius.circular(10),
                //                   borderSide: BorderSide(color: backGround),
                //                 ),
                //                 focusColor: backGround,
                //                 focusedBorder: InputBorder.none,
                //                 hintText: "${widget.address}",
                //                 enabled: enableUpdate==true?true:false
                //             ),
                //           )),
                //
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2 - 10,
                  width: width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: backGround,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            translate("store.description"),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: width - 60,
                            height: height * 0.1,
                            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              controller: descriptionTextController,
                              textAlign: Constant.lang == "ar" ? TextAlign.right : TextAlign.left,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: backGround),
                                  ),
                                  focusColor: backGround,
                                  focusedBorder: InputBorder.none,
                                  hintText: "${widget.title}",
                                  enabled: enableUpdate == true ? true : false),
                              minLines: 5,
                              maxLines: 7,
                            )),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: height*0.02,),
                // Container(
                //   height: height*0.2-25,
                //   width:width,
                //   padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.02),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     color: colorWhite,
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         children: [
                //           Icon(Icons.circle,color: backGround,),
                //           SizedBox(width: width*0.02,),
                //           Text(translate("store.location"),style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                //               color: Colors.black54),),
                //         ],
                //       ),
                //       SizedBox(height: height*0.02,),
                //       Opacity(
                //         opacity: enableUpdate?1:0.2,
                //         child: Container(
                //           width: width * 0.9,
                //           alignment: Alignment.center,
                //           padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(15),
                //               border: Border.all(width: 1,color: backGround),
                //               color:colorWhite ),
                //           child: DropdownButtonHideUnderline(
                //             child: DropdownButton(
                //               isExpanded: true,
                //               style: new TextStyle(
                //                   color: appColor, fontSize: width * 0.03+4),
                //               value: _statusSelCityKind,
                //               items: _dropDownMenuItemsCityKind,
                //               hint: Text(translate("store.city"),
                //                 style: GoogleFonts.cairo(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: width * 0.03 + 4),
                //               ),
                //               onChanged: _changeDrownItemMarketKind,
                //               icon: new Icon(Icons.keyboard_arrow_down),
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: height * 0.03,
                ),
                if (enableUpdate)
                  Container(
                    height: height * 0.2 - 25,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: backGround,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              translate("store.city"),
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                        Consumer<CitiesProvider>(builder: (context, state, child) {
                          return LabeledBottomSheet(
                            label: "${translate("store.city")}",
                            data: state.cities,
                            onChange: (v) {
                              _statusSelCityKind = v.id.toString();
                              state.getStates(v.id!);
                            },
                            ontap: true,
                          );
                        }),
                      ],
                    ),
                  ),
                if (enableUpdate) SizedBox(height: height * 0.02),
                if (enableUpdate)
                  Container(
                    height: height * 0.2 - 25,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: backGround,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              translate("store.state"),
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: height * 0.02,
                        // ),
                        Consumer<CitiesProvider>(builder: (context, state, child) {
                          return LabeledBottomSheet(
                            label: "${translate("store.state")}",
                            data: state.states,
                            onChange: (v) {
                              _statusSelState = v.id.toString();
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                if (enableUpdate)
                  GestureDetector(
                    onTap: () async {
                      String latitude = "30.1309082", longitude = "30.8959127";
                      await getLocation(context).then((value) {
                        value.getLocation().then((value) {
                          if (value != null) {
                            latitude = value.latitude.toString();
                            longitude = value.longitude.toString();
                          }
                        });
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowOnMapPage(
                                latitude: latitude,
                                longitude: longitude,
                              )));
                    },
                    child: Container(
                        width: width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appColor,
                        ),
                        padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                        margin: EdgeInsets.only(right: width * 0.03, left: width * 0.03, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              translate("signup.map_market"),
                              style: GoogleFonts.cairo(color: appColorTwo, fontSize: width * 0.04, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.add_location,
                              color: appColorTwo,
                            )
                          ],
                        )),
                  ),
                SizedBox(height: 20),
                Visibility(
                    visible: enableUpdate == true ? true : false,
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          // if (descriptionTextController.text.toString().trim().isNotEmpty||
                          //     priceTextController.text.toString().trim().isNotEmpty||
                          //     titleTextController.text.toString().trim().isNotEmpty) {
                          await categoryProvider
                              .updateGameCLub(
                            context: context,
                            productID: widget.id.toString(),
                            title: titleTextController.text.toString().trim(),
                            text: descriptionTextController.text.toString().trim(),
                            company_name: "${Constant.userName}",
                            lat: "${widget.lat}",
                            lng: "${widget.lng}",
                            country: "${widget.country_id}",
                            cityID: "${widget.city_id}",
                            address: "${locationTextController.text.toString()}",
                            state: "$_statusSelState",
                            image: imageFileUpload!.length != 0 ? imageFileUpload![0] : null,
                            phone: phoneTextController.text.toString().trim(),
                          )
                              .then((value) {
                            showToast(translate("toast.update_user_data"));
                            showToast(translate("toast.update_admin"));
                          });

                          if (imageFileUpload != null) {
                            for (int i = 0; i < imageFileUpload!.length; i++) {
                              print("----- " + widget.images![i].id.toString());
                              await categoryProvider.updateImage(image: imageFileUpload![i].absolute, context: context, gamesClub: true, imageID: "${widget.images![i].id.toString()}").then((value) {
                                if (value == "true") {
                                  showToast(translate("toast.update_admin"));
                                }
                              });
                            }
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameStorePage()));
                          // }
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
                    )),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  List<File>? imageFileUpload = [];
  final TextEditingController phoneTextController = new TextEditingController();
  final TextEditingController titleTextController = new TextEditingController();
  final TextEditingController descriptionTextController = new TextEditingController();
  final TextEditingController locationTextController = new TextEditingController();

  static Future<File> selectImage() async {
    File? image;
    final _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_imagePicker != null && pickedImage != null && pickedImage.path != null) {
      image = File(pickedImage.path);
      print("imagePath\n" + image.path);
    } else {
      print("No Image Selected");
    }
    return image!;
  }

  //drop down
  List<DropdownMenuItem<String>>? _dropDownMenuItemsCityKind;
  String? _statusSelCityKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsCityKind() {
    List<DropdownMenuItem<String>> itemsCityKind = [];
    for (int i = 0; i < Constant.cities.value.length; i++) {
      itemsCityKind.add(new DropdownMenuItem(
        child: new Text(
          "${Constant.cities.value[i].name}",
          style: GoogleFonts.cairo(
            color: appColor,
          ),
        ),
        value: "${Constant.cities.value[i].id}",
      ));
    }
    return itemsCityKind;
  }

  String? _statusSelState;

  void _changeDrownItemMarketKind(String selectedItem) {
    setState(() {
      _statusSelCityKind = selectedItem;
      print(_statusSelCityKind);
    });
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsDeptKind;
  String? _statusSelDeptKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsDeptKind() {
    List<DropdownMenuItem<String>> itemsMarketKind = [];
    for (int i = 0; i < Constant.categories.value.length; i++) {
      itemsMarketKind.add(new DropdownMenuItem(
        child: new Text(
          "${Constant.categories.value[i].name}",
          style: GoogleFonts.cairo(
            color: appColor,
          ),
        ),
        value: "${Constant.categories.value[i].id}",
      ));
    }
    return itemsMarketKind;
  }

  void _changeDrownItemDeptKind(String selectedItem) {
    setState(() {
      _statusSelDeptKind = selectedItem;
      print(_statusSelDeptKind);
    });
  }
}
