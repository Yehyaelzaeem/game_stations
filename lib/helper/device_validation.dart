//For ios hide some features in drawer and in home page
//TODO important check this before release ios
 import 'dart:io';

final  canView = Platform.isIOS ? DateTime.now().isAfter(DateTime(2023, 06, 02)) : true;