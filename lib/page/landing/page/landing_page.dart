import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_two_test/help_object/app_config_singleton.dart';
import 'package:flutter_two_test/page/landing/page/landing_page_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  LandingPage({Key? key}) : super(key: key);
  late final viewModel = LandingPageViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: FutureBuilder(
        future: viewModel.setupAppConfig(),
        builder: (context, snapshot) {
          return _consumerUI(context);
        },
      ),
    );
  }

  Widget _consumerUI(BuildContext context) {
    viewModel.timer ??= Timer(const Duration(seconds: 2), () {
      goToMain(context);
    });

    return Scaffold(
      body: Stack(
        children: [
          _backgroundImageUI(),
          _titleTextUI(context),
        ],
        fit: StackFit.expand,
      ),
    );
  }

  /// 背景圖片
  Widget _backgroundImageUI() {
    return Opacity(
      opacity: 0.5,
      child: Image.asset(
        'assets/image/bg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  /// 標題標籤
  Widget _titleTextUI(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: Consumer<LandingPageViewModel>(
        builder: (key, model, child) {
          return Text(
            AppConfigSingleton.instance.appDisplayName,
            style: const TextStyle(
                fontSize: 70, color: Colors.teal, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }

  void goToMain(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }
}
