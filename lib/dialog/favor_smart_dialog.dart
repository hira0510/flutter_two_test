import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/help_object/router_set.dart';

class FavorSmartDialog extends StatelessWidget {
  FavorSmartDialog({Key? key, required this.mText}) : super(key: key);
  String mText;

  static void show(String text) {
    RouterSet.showSmartDialog(FavorSmartDialog(mText: text), color: Colors.black26);
    closeDialog();
  }

  static void closeDialog() {
    Timer(const Duration(seconds: 1), () {
      RouterSet.smartDialogClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.r,
      height: 80.r,
      alignment: Alignment.center,
      child: Text(
        mText,
        style: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
