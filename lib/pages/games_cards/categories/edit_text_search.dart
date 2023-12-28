import 'package:flutter/material.dart';

class EditTextSearch extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hint;
  final bool? removeBorder;
  final Function? updateFunc;
  final Function? validateFunc;
  final Function? onFieldSubmitted;
  final double? fontSize;
  final double? radius;
  final double? contentPadding;

  EditTextSearch({
    @required this.hint,
    @required this.textEditingController,
    this.removeBorder = false,
    this.fontSize = 14,
    this.updateFunc,
    this.validateFunc,
    this.onFieldSubmitted,
    this.radius = 10,
    this.contentPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextFormField(
        controller: textEditingController,
        style: TextStyle(
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
            border: removeBorder!
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius!),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 0.3),
                  ),
            disabledBorder: removeBorder!
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius!),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 0.3),
                  ),
            focusedBorder: removeBorder!
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius!),
                    borderSide: BorderSide(color: Color(0xff264BAE), width: 1),
                  ),
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: fontSize),
            hintStyle: TextStyle(fontSize: fontSize, color: Colors.grey, fontWeight: FontWeight.w300),
            hintText: hint,
            counterStyle: TextStyle(color: Colors.green),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: contentPadding!)),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        
        onFieldSubmitted: (value) {
          if (onFieldSubmitted != null) onFieldSubmitted!(value);
        },
        validator: (text) {
          if (validateFunc != null) return validateFunc!(text);
          return null;
        },
        onChanged: (newValue) {
          if (updateFunc != null) return updateFunc!(newValue);
          return null;
        },
        onSaved: (newValue) {
          if (updateFunc != null) return updateFunc!(newValue);
          return null;
        },
        
     
      ),
    );
  }
}
