import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, TextInputFormatter, rootBundle;
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../elements/PermissionDeniedWidget.dart';
import '../../helper/getlocation.dart';
import '../../helper/showtoast.dart';
import '../../models/Constant.dart';
import '../../multi_image/multi_image_picker_view.dart';
import '../../provider/edit_product._provider.dart';
import '../../provider/loading_provider.dart';
import '../../repository/auth_user.dart';
import '../../repository/categories.dart';
import '../show_on_map.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);
  @override
  _AddProductPageState createState() => _AddProductPageState();
}
class _AddProductPageState extends State<AddProductPage> {
  ScrollController? scrollController;
  CategoriesProvider? categoryProvider;
  @override
  void initState() {
    scrollController = new ScrollController();
    _dropDownMenuItemsCityKind = _getDropDownMenuItemsCityKind();
    _dropDownMenuItemsDeptKind = _getDropDownMenuItemsDeptKind();
    super.initState();
  }

 final controller = MultiImagePickerController(
  maxImages: 300,
  picker: (allowMultiple) async {
  return await pickImagesUsingImagePicker(allowMultiple);
  });
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (categoryProvider == null) {
      categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
      categoryProvider!.getCategories();
    }
    var userProvider = Provider.of<UserAuth>(context, listen: false);
    userProvider.getCities();
    userProvider.getStates(1);
    return
      Consumer<EditProductProvider>(builder: (context ,c,child){
        return  Scaffold(
            backgroundColor: backGround,
            body:
            Constant.token != null && Constant.token.toString() != "null" && Constant.token.toString() != ""
                ?
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ChangeNotifierProvider.value(
                  value: LoadingProvider(),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Column(
                      children: [
                        Container(
                            height: height * 0.7 - 30,
                            child: Scrollbar(
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
                                          SizedBox(height: 10),
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
                                      height: height * 0.3,
                                      width: width,
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: colorWhite,
                                      ),
                                      child: SingleChildScrollView(
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
                                            //////////////////////////
                                            Align(
                                              alignment: Alignment.center,
                                              child:
                                              Container(
                                                height: 360,
                                                child: MultiImagePickerView(
                                                  controller: controller,
                                                  padding: const EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                                translate("store.choose_category"),
                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Container(
                                            width: width * 0.9,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(width: 1, color: backGround), color: colorWhite),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                style: new TextStyle(color: appColor, fontSize: width * 0.03 + 4),
                                                value: _statusSelDeptKind,
                                                items: _dropDownMenuItemsDeptKind,
                                                hint: Text(
                                                  translate("store.dept"),
                                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 4),
                                                ),
                                                onChanged: _changeDrownItemDeptKind,
                                                icon: new Icon(Icons.keyboard_arrow_down),
                                              ),
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
                                                translate("store.price"),
                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              width: width * 0.9,
                                              height: height * 0.1 - 30,
                                              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
                                              child: TextFormField(
                                                controller: priceTextController,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
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
                                      height: height * 0.1 + 30,
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
                                                translate("store.kind"),
                                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black54),
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
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: old == false ? appColor : backGround),
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
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: old == true ? appColor : backGround),
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
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                  height: 100,
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
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: width * 0.9,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(width: 1, color: backGround), color: colorWhite),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  style: new TextStyle(color: appColor, fontSize: width * 0.03 + 4),
                                                  value: _statusSelCityKind,
                                                  items: _dropDownMenuItemsCityKind,
                                                  hint: Text(
                                                    translate("store.city"),
                                                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: width * 0.03 + 4),
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
                                    categoryProvider!.lat != null
                                        ? GestureDetector(
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
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                                          margin: EdgeInsets.only(right: width * 0.03, left: width * 0.03, top: 5),
                                          child: Text(
                                            translate("signup.map_done"),
                                            textAlign: TextAlign.center,
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
                                    Consumer<LoadingProvider>(builder: (context, value, child) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: value.isLoading
                                              ? null
                                              : () async {
                                            setState(() {
                                              images =controller.images;
                                            });
                                            print('ya yehya el images length = : ${images!.length}*************************');
                                            value.isLoading = true;
                                            // if(Constant.subscribe==true) {
                                              if (imageFileUploadOne != null ||
                                                  imageFileUploadTwo != null ||
                                                  descriptionTextController.text.toString().trim().isNotEmpty && priceTextController.text.toString().trim().isNotEmpty &&
                                                      titleTextController.text.toString().trim().isNotEmpty) {
                                                List<File> images_file = [];
                                                if (images != null) {
                                                  for (var asset in images!) {
                                                    print(
                                                        "asset===============================================> ${asset.name}");
                                                    print(
                                                        "path===============================================> ${asset.path}");
                                                    var path = asset.path;
                                                    final file = File('$path');
                                                    images_file.add(file);

                                                    // var path2 = await FlutterAbsolutePath.getAbsolutePath(asset.);
                                                    // print(path.toString());
                                                    // var file3 = await getImageFileFromAsset(
                                                    //     path!);
                                                    // final byteData = await rootBundle.load('$file3');
                                                    //
                                                    // // print(file.toString());
                                                    //  print("file=====***==========${byteData.toString()}================================> ${asset.path}");
                                                    // final file2 = File('${(await getTemporaryDirectory()).path}/$path');
                                                    // await file2.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                                                  }
                                                }
                                                print('------> addProduct');
                                                await categoryProvider!
                                                    .addProduct(
                                                    context: context,
                                                    country: "${Constant
                                                        .country}",
                                                    price: priceTextController
                                                        .text.toString().trim(),
                                                    text: descriptionTextController
                                                        .text.toString().trim(),
                                                    title: titleTextController
                                                        .text.toString().trim(),
                                                    images: images_file,
                                                    catID: _statusSelDeptKind
                                                        .toString(),
                                                    cityID: _statusSelCityKind
                                                        .toString(),
                                                    type: old == false
                                                        ? "0"
                                                        : "1");
                                                print(
                                                    '------> finish addProduct');
                                                value.isLoading = false;
                                              }
                                            // }
                                            else {
                                              showToast(translate("toast.must_be_subscribe"));
                                            }
                                          },
                                          child: value.isLoading
                                              ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                              : Container(
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
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ))
                : PermissionDeniedWidget());
      });

  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }
  Iterable<ImageFile>? images = [];
  // List<Asset> images = [];
  bool old = false;
  final TextEditingController titleTextController = new TextEditingController();
  final TextEditingController descriptionTextController = new TextEditingController();
  final TextEditingController priceTextController = new TextEditingController();
  File? imageFileUploadOne, imageFileUploadTwo;
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

  void _changeDrownItemMarketKind(String? selectedItem) {
    setState(() {
      _statusSelCityKind = selectedItem!;
      print(_statusSelCityKind);
    });
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItemsDeptKind;
  String? _statusSelDeptKind;
  List<DropdownMenuItem<String>> _getDropDownMenuItemsDeptKind() {
    List<DropdownMenuItem<String>> itemsMarketKind =[];
    for (int i = 0; i < Constant.categories.value.length; i++) {
      if(Constant.categories.value[i].name != 'كروت الالعاب' &&
      Constant.categories.value[i].name != 'Games Card')
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

  void _changeDrownItemDeptKind(String? selectedItem) {
    setState(() {
      _statusSelDeptKind = selectedItem!;
      print(_statusSelDeptKind);
    });
  }


  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }




}
