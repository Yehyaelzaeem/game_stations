import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geocoding/geocoding.dart';
import '../helper/getlocation.dart';
import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../repository/categories.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ShowOnMapPage extends StatefulWidget{
  String? longitude,latitude;
  bool? justDisPlay;
  ShowOnMapPage({
    this.longitude,
    this.latitude,
    this.justDisPlay
  });
  @override
  State<StatefulWidget> createState() {
    return _ShowOnMapPageState();
  }
}
class _ShowOnMapPageState extends State<ShowOnMapPage>{
  LatLng? lastlocation;
  LatLng? latLng;
  String? lat,lng;
  @override
   void initState() {
    latLng=LatLng(double.parse(widget.latitude.toString()).toDouble(),
    double.parse(widget.longitude.toString()).toDouble());
    if(widget.latitude==null||widget.latitude==""&&widget.justDisPlay!=true){
      getLocation(context).then((value) {
        value.getLocation().then((value) {
          if(value!=null){
            setState(() {
              latLng=LatLng(value.latitude!,
                  value.longitude!);
            });
          }
        });
      });
    }
    Marker marker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng!,
      infoWindow: InfoWindow(
        title: "",
      ),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    markers[MarkerId(latLng.toString())] = marker;
    super.initState();
   }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var categoryProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        centerTitle: true,
        title: Text(translate("profile.map_selection"),
          style: GoogleFonts.cairo(color: appColor),),
        iconTheme: IconThemeData(color: appColor),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          widget.justDisPlay==true?
          GoogleMap(
            initialCameraPosition: CameraPosition(target:
            latLng!, zoom: 10),
            onMapCreated: onMapCreated,
            onCameraMove: _onCameraMoved,
            myLocationEnabled: true,
            mapType: MapType.normal,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onTap: _handleTap,
          ):
         GoogleMap(
            initialCameraPosition: CameraPosition(target:categoryProvider.latLngProvider==null?
            latLng!:categoryProvider.latLngProvider!, zoom: 10),
            onMapCreated: onMapCreated,
            onCameraMove: _onCameraMoved,
            myLocationEnabled: true,
            mapType: MapType.normal,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onTap: _handleTap,
          ),
         widget.justDisPlay!=true?
         Visibility(
              visible:selectedLocation==""?false:true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: MaterialButton(
                    color: appColor,
                    padding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(translate("button.ok"),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold,
                          color: colorWhite,fontSize: width*0.05),),
                    onPressed: () async{
                      setState(() {
                        categoryProvider.lat=lat!;
                        categoryProvider.lng=lng!;
                      });
                        Navigator.of(context).pop();

                      },

                  ),
                )
              ),
          ):SizedBox(),

        ],
      ),
    );
  }
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }
  void _onCameraMoved(CameraPosition position) {
    lastlocation = position.target;
  }
  //start set up map
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String selectedLocation="";
  final Geolocator geolocator = Geolocator();
    // ..forceAndroidLocationManager;
  _handleTap(LatLng point) async {
    markers.clear();

    try {
      List<Placemark> p = await placemarkFromCoordinates(
          double.parse(point.latitude.toString()),
          double.parse(point.longitude.toString()));
      Placemark place = p[0];
      setState(() {
        lat=point.latitude.toString();
        lng=point.longitude.toString();

        selectedLocation= place.country!+place.name!+place.locality!+place.subLocality!;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      Marker marker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: "",
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      markers[MarkerId(point.toString())] = marker;
    });
  }
  TextEditingController la= new TextEditingController();
  TextEditingController lg= new TextEditingController();

}
