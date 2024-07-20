import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_two_test/help_object/app_config_singleton.dart';

class MemberDataPage extends StatelessWidget {
  const MemberDataPage({Key? key}) : super(key: key);

  static void start(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MemberDataPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会员资料'),
      ),
      body: _stackUI(),
    );
  }

  /// 容器
  Widget _stackUI() {
    return Stack(
      fit: StackFit.expand,
      children: [_backgroundImageUI(), _mainColumnUI()],
    );
  }

  /// 背景圖片
  Widget _backgroundImageUI() {
    return Opacity(
      opacity: 0.3,
      child: Image.asset(
        'assets/image/bg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  /// 上而下排序
  Widget _mainColumnUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        _memberImageUI(),
        const SizedBox(height: 20),
        _dataTextUI('名称：', AppConfigSingleton.instance.mUserName),
        const SizedBox(height: 20),
        _dataTextUI('帐号：', AppConfigSingleton.instance.mEmail),
        const SizedBox(height: 20),
        _dataTextUI('密码：', AppConfigSingleton.instance.mPassword)
      ],
    );
  }

  /// 會員圖片
  Widget _memberImageUI() {
    return const CircleAvatar(
      backgroundColor: Colors.blue,
      backgroundImage: AssetImage('assets/image/btn_cat2.png'),
      radius: 90,
    );
  }

  /// 字串標籤
  Widget _dataTextUI(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 30, color: Colors.teal),
        ),
        Text(
          data,
          style: const TextStyle(fontSize: 25, color: Colors.teal),
        ),
      ],
    );
  }
}
