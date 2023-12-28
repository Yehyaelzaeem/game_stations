import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../models/sliderModel.dart';
import '../../provider/edit_product._provider.dart';
import '../root_pages.dart';
import '../../repository/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditAdsPage extends StatefulWidget {
  String? id, title, imageOne, imageTwo, description, price, catID;
  bool? old;
  List<SliderModel>? images;

  EditAdsPage(
      {this.id,
      this.title,
      this.imageOne,
      this.imageTwo,
      this.description,
      this.price,
      this.catID,
      this.old,
      this.images});

  @override
  _EditAdsPagePageState createState() => _EditAdsPagePageState();
}

class _EditAdsPagePageState extends State<EditAdsPage> {
  ScrollController? scrollController;
  bool enableUpdate = false;
  // List<Asset> newImages = [];
  List newImages = [];

  @override
  void initState() {
    scrollController = new ScrollController();
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsDeptKind = _getDropDownMenuItemsDeptKind();
    if (widget.old == true) {
      setState(() {
        old = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        iconTheme: IconThemeData(color: appColor, opacity: 12, size: 25),
        backgroundColor: colorWhite,
        title: Text(
          translate("store.edit_ads"),
          style: GoogleFonts.cairo(
              color: appColor, fontWeight: FontWeight.bold, fontSize: 18),
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
                              titleTextController.text =
                                  widget.title.toString();
                              priceTextController.text =
                                  widget.price.toString();
                              descriptionTextController.text =
                                  widget.description.toString();
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
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        width: width * 0.9,
                        height: height * 0.1 - 30,
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          controller: titleTextController,
                          textAlign: Constant.lang == "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                    /////////////
                    // Container(
                    //   height: height * 0.09,
                    //   width: width,
                    //   child: ListView.separated(
                    //     itemCount: enableUpdate == true
                    //         ? widget.images!.length + 1
                    //         : widget.images!.length,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       if (index == widget.images!.length) {
                    //         if (enableUpdate == true) {
                    //           return InkWell(
                    //             onTap: () async {
                    //               // List<Asset> resultList = [];
                    //               List resultList = [];
                    //               try {
                    //                 resultList =
                    //                     await MultipleImagesPicker.pickImages(
                    //                   maxImages: 300,
                    //                   enableCamera: true,
                    //                   materialOptions: MaterialOptions(
                    //                     actionBarTitle: "FlutterCorner.com",
                    //                   ),
                    //                 );
                    //               } on Exception catch (e) {
                    //                 print("Error: " + e.toString());
                    //               }
                    //
                    //               for (Asset asset in resultList) {
                    //                 // print(
                    //                 //     "ESSAMPATH===============================================>${asset.identifier} ${asset.name}");
                    //                 //
                    //                 // var path = await FlutterAbsolutePath
                    //                 //     .getAbsolutePath(asset.identifier);
                    //                 // print(path.toString());
                    //                 // // final byteData = await rootBundle.load('$path');
                    //                 // var file = getImageFileFromAsset(path);
                    //                 // print(file.toString());
                    //                 // // final file = File('${(await getTemporaryDirectory()).path}/$path');
                    //                 // // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                    //                 // SliderModel slide =
                    //                 //     SliderModel.addNewImage(file.path);
                    //                 // widget.images!.add(slide);
                    //               }
                    //
                    //               setState(() {
                    //                 newImages = resultList;
                    //               });
                    //             },
                    //             child: Image.asset(
                    //               "assets/images/photo.png",
                    //               width: width * 0.2,
                    //               height: height * 0.09,
                    //               fit: BoxFit.fill,
                    //             ),
                    //           );
                    //         }
                    //       }
                    //
                    //       return enableUpdate == true
                    //           ? Align(
                    //               alignment: Alignment.center,
                    //               child: GestureDetector(
                    //                   onTap: () async {
                    //                     await selectImage().then((value) {
                    //                       setState(() {
                    //                         widget.images![index].image =
                    //                             value.path;
                    //                         widget.images![index].isEdit = true;
                    //                         debugPrint(
                    //                             "ESSAMPath=====>${value.path}");
                    //
                    //                         //imageFileUpload.add(value.absolute);
                    //                       });
                    //                     });
                    //                   },
                    //                   child: !widget.images![index].isEdit! &&
                    //                           !widget.images![index].isNew!
                    //                       ? Image.network(
                    //                           widget.images![index].image
                    //                               .toString(),
                    //                           width: width * 0.2,
                    //                           height: height * 0.09,
                    //                           fit: BoxFit.fill,
                    //                         )
                    //                       : Image.file(
                    //                           File(widget.images![index].image!),
                    //                           width: width * 0.2,
                    //                           height: height * 0.09,
                    //                           fit: BoxFit.fill,
                    //                         )),
                    //             )
                    //           : Image.network(
                    //               widget.images![index].image.toString(),
                    //               width: width * 0.2,
                    //               height: height * 0.09,
                    //               fit: BoxFit.fill,
                    //             );
                    //     },
                    //     separatorBuilder: (BuildContext context, int index) {
                    //       return SizedBox(
                    //         width: width * 0.04,
                    //       );
                    //     },
                    //   ),
                    // ),
                  ///////////////////
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.1 + 43,
                width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                          translate("store.price"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        width: width * 0.9,
                        height: height * 0.1 - 30,
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          controller: priceTextController,
                          textAlign: Constant.lang == "ar"
                              ? TextAlign.right
                              : TextAlign.left,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backGround),
                              ),
                              focusColor: backGround,
                              focusedBorder: InputBorder.none,
                              hintText: "${widget.price}",
                              enabled: enableUpdate == true ? true : false),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.1 + 30,
                width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                          translate("store.kind"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              old = false;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        old == false ? appColor : backGround),
                                padding: EdgeInsets.all(10.0),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(translate("store.new")),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              old = true;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: old == true ? appColor : backGround),
                                padding: EdgeInsets.all(10.0),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(translate("store.old")),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
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
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: descriptionTextController,
                            textAlign: Constant.lang == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: backGround),
                                ),
                                focusColor: backGround,
                                focusedBorder: InputBorder.none,
                                hintText: "${widget.description}",
                                enabled: enableUpdate == true ? true : false),
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
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
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
                          translate("store.location"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Opacity(
                      opacity: enableUpdate ? 1 : 0.2,
                      child: Container(
                        width: width * 0.9,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: width * 0.03, right: width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: backGround),
                            color: colorWhite),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            style: new TextStyle(
                                color: appColor, fontSize: width * 0.03 + 4),
                            value: _statusSelCityKind,
                            items: _dropDownMenuItemsCityKind,
                            hint: Text(
                              translate("store.city"),
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.03 + 4),
                            ),
                            onChanged: _changeDrownItemMarketKind,
                            icon: new Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
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
                            .updateProduct(
                          context: context,
                          productID: widget.id.toString(),
                          title: titleTextController.text.toString().trim(),
                          price: priceTextController.text.toString().trim(),
                          text:
                              descriptionTextController.text.toString().trim(),
                          catID: widget.catID.toString(),
                          type: old == true ? "1" : "0",
                        )
                            .then((value) {
                          showToast(translate("toast.update_user_data"));
                          showToast(translate("toast.update_admin"));
                        });
                        List<SliderModel> editImagesList = widget.images!
                            .where((element) => element.isEdit!)
                            .toList();
                        List<SliderModel> newImages = widget.images!
                            .where((element) => element.isNew!)
                            .toList();
                        await categoryProvider
                            .getProductDetails(widget.id.toString())
                            .then((value) async {});

                        if (newImages != null) {
                          await Provider.of<EditProductProvider>(context,
                                  listen: false)
                              .updateImage(
                                  images: newImages,
                                  context: context,
                                  product_id: widget.id!)
                              .then((value) {
                            if (value == "true") {
                              showToast(translate("toast.update_admin"));
                            }
                          });
                          for (int i = 0; i < newImages.length; i++) {}
                        }
                        if (editImagesList != null) {
                          for (int i = 0; i < editImagesList.length; i++) {
                            await categoryProvider
                                .updateImage(
                                    image: File(editImagesList[i].image!),
                                    context: context,
                                    imageID: editImagesList[i].id!)
                                .then((value) {
                              if (value == "true") {
                                showToast(translate("toast.update_admin"));
                              }
                            });
                          }
                        }
                        /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RootPages(
                                  checkPage: "3",
                                )));*/
                        // }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.3,
                        height: height * 0.07,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          translate("activity_setting.done"),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, color: appColorTwo),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  File getImageFileFromAsset(String path) {
    final file = File(path);
    return file;
  }

  bool old = false;
  final TextEditingController titleTextController = new TextEditingController();
  final TextEditingController descriptionTextController =
      new TextEditingController();
  final TextEditingController priceTextController = new TextEditingController();
  //List<File> imageFileUpload = List<File>();
  static Future<File> selectImage() async {
    File? image;
    final _imagePicker = ImagePicker();
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_imagePicker != null &&
        pickedImage != null &&
        pickedImage.path != null) {
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
    List<DropdownMenuItem<String>> itemsCityKind =[];
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

  void _changeDrownItemMarketKind(String? selectedItem) {
    setState(() {
      _statusSelCityKind = selectedItem!;
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
