import 'package:flutter/cupertino.dart';
import '../repository/categories.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

Future<Location>getLocation(BuildContext context) async {
  var categoryProvider = Provider.of<CategoriesProvider>(context,listen: false);

  var location = new Location();
  try {
    await location.getLocation().then((onValue) {
      print("latitude:" + onValue.latitude.toString() +"\n"
          "longitude:" + onValue.longitude.toString());
      categoryProvider.latLngProvider = LatLng(onValue.latitude!,
          onValue.longitude!);
    });
  } catch (e) {
    print(e);
    if (e == 'PERMISSION_DENIED') {
      print('PERMISSION_DENIED');
    }
  }

  return location;
}


// var location = new Location();
// await location.getLocation().then((value) {
//   try {
//     if (lattitude.toString().isEmpty) {
//       getLocation().then((value) {
//         value.getLocation().then((value){
//           lattitude=value.latitude.toString();
//           longitude=value.longitude.toString();
//         });
//       });
//     } else {
//       lattitude = value.latitude.toString();
//       longitude = value.longitude.toString();
//     }
//   } catch (e) {
//     print(e);
//   }
// });