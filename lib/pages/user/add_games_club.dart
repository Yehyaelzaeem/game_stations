import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../elements/widget_store_header.dart';
import '../../helper/getCitiesProvider.dart';
import '../../helper/getlocation.dart';
import '../../helper/labeled_bottom_sheet.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../show_on_map.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddGamesClubPage extends StatefulWidget {
  const AddGamesClubPage({Key? key}) : super(key: key);

  @override
  _AddGamesClubPageState createState() => _AddGamesClubPageState();
}

class _AddGamesClubPageState extends State<AddGamesClubPage> {
  ScrollController? scrollController;
  @override
  void initState() {
    scrollController = new ScrollController();
    Provider.of<CitiesProvider>(context, listen: false).getCities(Constant.country!);
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsState = _getDropDownMenuItemsState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: backGround,
        body: Constant.id != null
            ? InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.04,
                      ),
                      globalHeader(context, translate("store.add_club_games")),
                      SizedBox(height: height * 0.01),
                      Container(
                          height: height * 0.9 - 10,
                          child: Scrollbar(
                            thickness: width * 0.02,
                            thumbVisibility: true,
                            radius: Radius.circular(10),
                            controller: scrollController,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    // height: height * 0.1 + 43,
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
                                              translate("store.club_title"),
                                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Container(
                                            width: width * 0.9,
                                            height: height * 0.1 - 30,
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
                                                focusColor: backGround,
                                                focusedBorder: InputBorder.none,
                                              ),
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
                                              translate("store.add_image"),
                                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        // Align(
                                        //     alignment: Alignment.center,
                                        //     child: GestureDetector(
                                        //         onTap: () async {
                                        //           List<Asset> resultList = [];
                                        //           try {
                                        //             resultList = await MultipleImagesPicker.pickImages(
                                        //               maxImages: 300,
                                        //               enableCamera: true,
                                        //               selectedAssets: images,
                                        //               materialOptions: MaterialOptions(
                                        //                 actionBarTitle: "FlutterCorner.com",
                                        //               ),
                                        //             );
                                        //           } on Exception catch (e) {
                                        //             print("Error: " + e.toString());
                                        //           }
                                        //           setState(() {
                                        //             images = resultList;
                                        //           });
                                        //         },
                                        //         child: images.length == 0
                                        //             ? Image.asset(
                                        //                 "assets/images/photo.png",
                                        //                 width: width * 0.2,
                                        //                 height: height * 0.09,
                                        //                 fit: BoxFit.fill,
                                        //               )
                                        //             : Container(
                                        //                 height: height * 0.1,
                                        //                 width: width * 0.4,
                                        //                 child: GridView.count(
                                        //                   crossAxisCount: 3,
                                        //                   children: List.generate(images.length, (index) {
                                        //                     Asset asset = images[index];
                                        //                     return AssetThumb(
                                        //                       asset: asset,
                                        //                       width: 40,
                                        //                       height: 30,
                                        //                     );
                                        //                   }),
                                        //                 ))
                                        //         // Image.file(imageFileUploadOne,width: width*0.2,
                                        //         //   height: height*0.09,fit: BoxFit.fill,),
                                        //         )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    // height: height * 0.1 + 43,
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
                                            SizedBox(width: width * 0.02),
                                            Text(
                                              translate("store.phone"),
                                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Container(
                                            width: width * 0.9,
                                            height: height * 0.1 - 30,
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
                                                ),
                                                minLines: 5,
                                                maxLines: 7,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
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
                                        // SizedBox(
                                        //   height: height * 0.02,
                                        // ),
                                        // Container(
                                        //   width: width * 0.9,
                                        //   alignment: Alignment.center,
                                        //   padding: EdgeInsets.only(
                                        //       left: width * 0.03,
                                        //       right: width * 0.03),
                                        //   decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(15),
                                        //       border: Border.all(
                                        //           width: 1, color: backGround),
                                        //       color: colorWhite),
                                        //   child: DropdownButtonHideUnderline(
                                        //     child: DropdownButton(
                                        //       isExpanded: true,
                                        //       style: new TextStyle(
                                        //           color: appColor,
                                        //           fontSize: width * 0.03 + 4),
                                        //       value: _statusSelCityKind,
                                        //       items: _dropDownMenuItemsCityKind,
                                        //       hint: Text(
                                        //         translate("store.city"),
                                        //         style: GoogleFonts.cairo(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: width * 0.03 + 4),
                                        //       ),
                                        //       onTap: () {},
                                        //       onChanged: _changeDrownItemCityKind,
                                        //       icon: new Icon(
                                        //           Icons.keyboard_arrow_down),
                                        //     ),
                                        //   ),
                                        // ),
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
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
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
                                        // Container(
                                        //   width: width * 0.9,
                                        //   alignment: Alignment.center,
                                        //   padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                                        //   decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.circular(15),
                                        //       border: Border.all(width: 1,color: backGround),
                                        //       color:colorWhite ),
                                        //   child: DropdownButtonHideUnderline(
                                        //     child: DropdownButton(
                                        //       isExpanded: true,
                                        //       style: new TextStyle(
                                        //           color: appColor, fontSize: width * 0.03+4),
                                        //       value: _statusSelState,
                                        //       items: _dropDownMenuItemsState,
                                        //       hint: Text(translate("store.state"),
                                        //         style: GoogleFonts.cairo(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: width * 0.03 + 4),
                                        //       ),
                                        //       onChanged: _changeDrownItemState,
                                        //       icon: new Icon(Icons.keyboard_arrow_down),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  categoryProvider.lat != null
                                      ? GestureDetector(
                                          onTap: () async {
                                            String latitude = "30.1309082", longitude = "30.8959127";
                                            await getLocation( context).then((value) {
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
                                              ),
                                              padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                                              margin: EdgeInsets.only(right: width * 0.03, left: width * 0.03, top: 5),
                                              child: Text(
                                                translate("signup.map_done"),
                                              )),
                                        )
                                      : GestureDetector(
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
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () async {
                                        // if(Constant.subscribe==true){
                                        if (categoryProvider.lat != null || categoryProvider.lng != null) {
                                          if (imageFileUploadOne != null ||
                                              descriptionTextController.text.toString().trim().isNotEmpty ||
                                              phoneTextController.text.toString().trim().isNotEmpty ||
                                              titleTextController.text.toString().trim().isNotEmpty) {
                                            List<MultipartFile> multipartImageList =[];
                                            List<File> images_file = [];
                                        //     if (null != images) {
                                        //       for (Asset asset in images) {
                                        //         var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
                                        //         print(path.toString());
                                        //         // final byteData = await rootBundle.load('$path');
                                        //         var file = await getImageFileFromAsset(path);
                                        //         print(file.toString());
                                        //         // final file = File('${(await getTemporaryDirectory()).path}/$path');
                                        //         // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                                        //         images_file.add(file);
                                        //       }
                                        //     }
                                        //     await categoryProvider.addGamesClub(
                                        //       context: context,
                                        //       country: "${Constant.country}",
                                        //       phone: phoneTextController.text.toString().trim(),
                                        //       text: descriptionTextController.text.toString().trim(),
                                        //       title: titleTextController.text.toString().trim(),
                                        //       images: images_file,
                                        //       cityID: _statusSelCityKind.toString(),
                                        //       stateID: _statusSelState.toString(),
                                        //     );
                                        //   } else {
                                        //     showToast(translate("toast.field_empty"));
                                        //   }
                                        // } else {
                                        //   showToast(translate("signup.map_error"));
                                        }
                                        }
                                        // else{
                                        //   showToast(translate("toast.must_be_subscribe"));
                                        // }
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: width * 0.3,
                                          height: height * 0.07,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(100)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                translate("activity_setting.done"),
                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: appColorTwo),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            : PermissionDeniedWidget());
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  // List<Asset> images = [];
  List images = [];
  bool old = false;
  final TextEditingController titleTextController = new TextEditingController();
  final TextEditingController descriptionTextController = new TextEditingController();
  final TextEditingController phoneTextController = new TextEditingController();
  File? imageFileUploadOne, imageFileUploadTwo;
  static Future<File> selectImage() async {
    File? image;
    final _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage (source: ImageSource.gallery);
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

  void _changeDrownItemCityKind(String selectedItem) {
    setState(() {
      _dropDownMenuItemsState!.clear();
      _statusSelCityKind = selectedItem;
      print(_statusSelCityKind);
    });
    try {
      for (int i = 0; i < Constant.states.value.length; i++) {
        if (Constant.states.value[i].main_category_id == "$_statusSelCityKind") {
          print("selected Main_category_id: ${Constant.states.value[i].main_category_id.toString()}");
          setState(() {
            _statusSelState = Constant.states.value[i].id.toString();
            _dropDownMenuItemsState = _getDropDownMenuItemsState(cityID: Constant.states.value[i].main_category_id.toString());
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsState;
  String? _statusSelState;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsState({String? cityID}) {
    List<DropdownMenuItem<String>> itemsState = [];
    for (int i = 0; i < Constant.states.value.length; i++) {
      itemsState.add(new DropdownMenuItem(
        child: new Text(
          "${Constant.states.value[i].name}",
          style: GoogleFonts.cairo(
            color: appColor,
          ),
        ),
        value: "${Constant.states.value[i].id}",
      ));
    }
    return itemsState;
  }

  void _changeDrownItemState(String selectedItem) {
    setState(() {
      _statusSelState = selectedItem;
      print(_statusSelState);
    });
  }
}
