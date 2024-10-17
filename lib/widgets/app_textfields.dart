import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final bool? noLabel;
  final bool? isEmail;
  final bool? isPhone;
  final bool? isNumber;
  final String labelText;
  final bool? isSuffix;
  final String? hintText;
  const AppTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.isPassword,
    this.isEmail,
    this.isSuffix,
    this.isPhone,
    this.noLabel,
    this.hintText,
    this.isNumber,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.noLabel != true)
            ? Text(
                widget.labelText,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                  color: blackText,
                ),
              )
            : const SizedBox(),
        SizedBox(
          height: 65,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword == true ? obscure : false,
            keyboardType: widget.keyboardType,
            maxLength: (widget.isPhone == true) ? 10 : null,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: greyText),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              constraints: BoxConstraints.tight(const Size.fromHeight(60.0)),
              suffixIcon: (widget.isSuffix != null)
                  ? const Icon(
                      Icons.edit,
                      color: primaryColor1,
                    )
                  : widget.isPassword == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility,
                            color: greyText,
                          ),
                        )
                      : null,
            ),
            validator: (value) => value!.isEmpty ? '*Field is required' : null,
          ),
        ),
      ],
    );
  }
}

class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;

  const PhoneTextField({super.key, this.controller});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            color: blackText,
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: greyText),
            ),
            prefixIcon: Container(
              width: 82.0,
              margin: const EdgeInsets.only(right: 10.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              decoration: BoxDecoration(
                  color: const Color(0xffF3F3F3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  border: Border.all(color: greyText)),
              child: const Center(
                child: Row(
                  children: [
                    Text(
                      '+234',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: blackText,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
          maxLength: 10,
        ),
      ],
    );
  }
}
