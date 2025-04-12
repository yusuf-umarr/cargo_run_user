import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Util {
  static Widget inputField2({
    String? hint,
    IconData? icon,
    IconData? prefixIcon,
    bool isExternalLabel = true,
    bool readOnly = false,
    bool enable = true,
    double? size,
    double fontSize = 13,
    double fontSizeExternal = 14,
    TextEditingController? controller,
    TextInputType inputType = TextInputType.text,
    double borderRadius = 5,
    double marginLeft = 5,
    double paddingLeft = 10,
    double paddingRight = 15,
    TextAlign textAlign = TextAlign.start,
    double prefixIconSize = 20,
    double suffixIconSize = 20,
    Color prefixIconColor = primaryColor1,
    Color suffixIconColor = const Color(0xff22004E),
    bool isInputFrame = true,
    int max = 1,
    bool useExternalText = true,
    String externalText = "",
    String readOnlyText = "",
    double externalTextBottomMargin = 5,
    double inputFieldPadding = 0,
    Function(String val)? onChanged,
    Function()? onSuffixIconClick,
    Function()? onTap,
    bool hasBorder = true,
    Color borderColor = const Color(0xffD9D9D9),
    double elevation = 0,
    Color bgColor = Colors.white,
    Color externalTextColor = Colors.black,
    String compulsoryText = "*",
    Color compulsoryColor = Colors.red,
    double compulsoryFontSize = 16,
    List<String> dropDownList = const ['Select'],
    Color readOnlyTextColor = Colors.black54,
    FontWeight readOnlyFontWeight = FontWeight.w400,
    EdgeInsets readOnlyPadding =
        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    Widget? suffixWidget,
    Color hintColor = Colors.grey,
    FontWeight hintFont = FontWeight.w400,
    double hintFontSize = 13,
    dynamic validator,
    void Function(dynamic)? dropDownOnChanged,
    Function()? onClick,
    bool isDropDownSearch = true,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isExternalLabel
            ? Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: marginLeft),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            useExternalText ? externalText : hint!,
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: blackText,
                            ),
                          )),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: size,
            child: TextFormField(
              // onTap: onTap,
              enabled: enable,
              controller: controller,
              keyboardType: inputType,
              textAlign: textAlign,
              readOnly: readOnly,
              onChanged: onChanged,
              validator: validator,
              maxLines: max,
              style: TextStyle(fontSize: fontSize, color: Colors.black87),
              decoration: InputDecoration(
                hintText: isExternalLabel
                    ? useExternalText
                        ? hint
                        : ""
                    : hint,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontWeight: hintFont,
                  fontSize: hintFontSize,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: greyText),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<File> myUploadImage() async {
  final imagePicker = ImagePicker();
  XFile? image;

  var file = File("");

  image = await imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 25);

  if (image != null) {
    file = File(image.path);
  }

  try {
    return file;
  } catch (e) {
    return File("");
  }
}

String formatAmount(String input) {
  try {
    String integerPart = input.split('.').first;
    int value = int.parse(integerPart.replaceAll(',', ''));
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  } catch (e) {
    return input;
  }
}

 void showSnackBar(context, {required String message ,Color color =Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:color
      ),
    );
  }

  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    DateFormat formatter = DateFormat('d MMM. yyyy');
    return formatter.format(parsedDate);
  }

  String formatTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(parsedDate);
  }