import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_two_test/dialog/member_alert_dialog.dart';
import 'package:flutter_two_test/page/member/page/member_login_page_view_model.dart';
import 'package:flutter_two_test/page/member/ui/member_login_custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberLoginPage extends StatelessWidget {
  MemberLoginPage({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MemberLoginPageViewModel viewModel = MemberLoginPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///🟢鍵盤出現時UI不要跟著動🟢
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('会员登入/注册'),
      ),
      body: _MemberLoginPageUI(context),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _MemberLoginPageUI(BuildContext context) {
    return Center(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _backgroundImageUI(),
          Column(
            children: [
              const SizedBox(height: 20),
              inputTextField(TextInputType.text, nameController, '请输入名称',
                  const Icon(Icons.account_box_rounded), false),
              inputTextField(TextInputType.emailAddress, emailController,
                  '请输入帐号', const Icon(Icons.email), false),
              inputTextField(TextInputType.name, passwordController, '请输入密码',
                  const Icon(Icons.lock), true),
              _checkBtnUI(context)
            ],
          ),
        ],
      ),
    );
  }

  /// 輸入匡
  Widget inputTextField(TextInputType type, TextEditingController controller,
      String text, Icon icon, bool obscure) {
    return customInputTextField(
        mBoardType: type,
        mController: controller,
        mInputText: text,
        mInputIcon: icon,
        mIsObscure: obscure);
  }

  /// 背景圖
  Widget _backgroundImageUI() {
    return Opacity(
      opacity: 0.3,
      child: Image.asset(
        'assets/image/bg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  /// 確認按鈕
  Widget _checkBtnUI(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: MaterialButton(
        child: const Text('登入/注册'),
        color: Colors.tealAccent,
        minWidth: 150,
        onPressed: () {
          ///🟢關閉鍵盤🟢
          FocusScope.of(context).unfocus();
          bool success = viewModel.didClickSend(nameController.text,
              emailController.text, passwordController.text);
          success ? canLogin(context) : canNotLogin(context);
        },
      ),
    );
  }

  void canLogin(BuildContext contexts) {
    showDialog(
      context: contexts,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MemberAlertDialog(
          closeDialog: () {
            Navigator.pop(contexts);
          },
        );
      },
    );
  }

  void canNotLogin(BuildContext context) {
    Fluttertoast.showToast(msg: '名称帐号密码长度或格式不符');
  }
}
