import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberAlertDialog extends StatefulWidget {
  MemberAlertDialog({Key? key, required this.closeDialog}) : super(key: key);
  VoidCallback closeDialog;

  @override
  State<MemberAlertDialog> createState() => _MemberAlertDialogState();
}

class _MemberAlertDialogState extends State<MemberAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: AlertDialog(
        title: const Text(
          '已成功登入！',
          style: TextStyle(color: Colors.teal),
        ),
        content: ElevatedButton(
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(120.r, 40.r))),
          child: const Text(
            '关闭',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _onConfirmClick(),
        ),
      ),
    );
  }

  void _onConfirmClick() {
    Navigator.pop(context);
    widget.closeDialog();
  }
}
