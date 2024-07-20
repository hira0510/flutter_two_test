import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class customInputTextField extends StatelessWidget {
  const customInputTextField(
      {Key? key,
      required this.mBoardType,
      required this.mController,
      required this.mInputText,
      required this.mInputIcon,
      required this.mIsObscure})
      : super(key: key);
  final TextInputType mBoardType;
  final TextEditingController mController;
  final String mInputText;
  final Icon mInputIcon;
  final bool mIsObscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: TextField(
        textAlign: TextAlign.left,
        maxLength: 15,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        keyboardType: mBoardType,
        controller: mController,
        style: const TextStyle(fontSize: 25, color: Colors.teal),
        obscureText: mIsObscure,
        decoration: InputDecoration(
          fillColor: const Color.fromRGBO(240, 255, 255, 1),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          isCollapsed: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          hintText: mInputText,
          prefixIcon: mInputIcon,
          hintStyle: const TextStyle(fontSize: 20, color: Colors.greenAccent),
        ),
      ),
    );
  }
}
