import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';

class Util{

   static Widget inputField2({
    String? hint,
    IconData? icon,
    IconData? prefixIcon,
    bool isIcon = false,
    bool isPrefix = false,
    bool isExternalLabel = true,
    bool readOnly = false,
    bool enable = true,
    double? size,
    double fontSize = 13,
    double fontSizeExternal = 14,
    TextEditingController? controller,
    TextInputType inputType = TextInputType.text,
    double borderRadius = 5,
    bool isPassword = false,
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
    bool isCompulsory = false,
    String compulsoryText = "*",
    Color compulsoryColor = Colors.red,
    double compulsoryFontSize = 16,
    bool isDropDown = false,
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
                            style: TextStyle(
                              color: externalTextColor,
                              fontSize: fontSizeExternal,
                            ),
                          )),
                    ),
                    isCompulsory
                        ? Text(
                            compulsoryText,
                            style: TextStyle(
                              color: compulsoryColor,
                              fontSize: compulsoryFontSize,
                            ),
                          )
                        : const SizedBox(height: 0, width: 0)
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        isExternalLabel
            ? SizedBox(
                height: externalTextBottomMargin,
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        Container(
          decoration: hasBorder
              ? BoxDecoration(
                  border: Border.all(color: borderColor, width: 0.3),
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: bgColor,
                )
              : const BoxDecoration(),
          child: Padding(
            padding: EdgeInsets.all(inputFieldPadding),
            child: Material(
              elevation: elevation,
              borderRadius: BorderRadius.circular(borderRadius),
              color: bgColor,
              child: Row(
                children: [
                  isPrefix
                      ? InkWell(
                          onTap: onClick,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            //color: bgColor,
                            child: InkWell(
                              onTap: onClick,
                              child: Icon(
                                prefixIcon,
                                color: prefixIconColor,
                                size: prefixIconSize,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 5,
                        ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: paddingLeft, right: paddingRight),
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1, color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(borderRadius),
                          //color: bgColor,
                        ),
                        child: SizedBox(
                          width: size,
                          child: TextFormField(
                            // onTap: onTap,
                            enabled: enable,
                            obscureText: isPassword,
                            controller: controller,
                            keyboardType: inputType,
                            textAlign: textAlign,
                            readOnly: readOnly,
                            onChanged: onChanged,
                            validator: validator,
                            maxLines: max,
                            style: TextStyle(
                                fontSize: fontSize, color: Colors.black87),
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
                              suffixIconConstraints: isIcon
                                  ? const BoxConstraints(
                                      maxWidth: 50,
                                    )
                                  : const BoxConstraints(maxWidth: 26),
                              suffixIcon: InkWell(
                                onTap: onSuffixIconClick,
                                child: isIcon
                                    ? Icon(
                                        icon,
                                        color: suffixIconColor,
                                        size: suffixIconSize,
                                      )
                                    : const SizedBox(
                                        width: 0,
                                        height: 0,
                                      ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: suffixWidget ??
                        const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}