import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class SliderItemModel{
  final String? title;
  final String? description;
  final String? pathImage;
  final String? backgroundImage;
  final Color? backgroundColor;
  final TextStyle? styleTitle;
  final TextStyle? styleDescription;

  SliderItemModel(
  {   this.title,
    this.description,
    this.pathImage,
    this.backgroundImage,
    this.backgroundColor,
    this.styleTitle,
    this.styleDescription});
}