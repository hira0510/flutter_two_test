import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class RouterSet {
  RouterSet._();

  static void showSmartDialog(Widget dialog, {bool backDismiss = false, String? tag, Color color = Colors.transparent}) {
    SmartDialog.show(
      backDismiss: backDismiss,
      clickBgDismissTemp: backDismiss,
      isLoadingTemp: false,
      tag: tag,
      isUseAnimationTemp: true,
      maskColorTemp: color,
      widget: dialog,
    );
  }

  static void smartDialogClose() {
    SmartDialog.dismiss();
  }
}
