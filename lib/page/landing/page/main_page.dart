import 'package:flutter/material.dart';
import 'package:flutter_two_test/dialog/open_system_dialog.dart';
import 'package:flutter_two_test/page/favor/page/favor_page.dart';
import 'package:flutter_two_test/page/home/page/home_page.dart';
import 'package:flutter_two_test/page/landing/page/main_page_view_model.dart';
import 'package:flutter_two_test/page/member/page/member_page.dart';

import '../../../ad/ad_provider_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MainPageViewModel viewModel = MainPageViewModel();

  List<Widget> pages = [];

  @override
  void initState() {
    // AdProviderManager.instance.showInterstitialAd(() {
    //   viewModel.isDisplaySystemDialog.add(true);
    // });
    super.initState();

    pages = [
      HomePage(),
      FavorPage(),
      MemberPage(didClickBtmNav: (index) => _didClickBtmNav(index))
    ];

    viewModel.isDisplaySystemDialog.stream.listen((display) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const OpenSystemDialog();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _setupAppBarUI(viewModel),
      bottomNavigationBar: _setupTabBarUI(viewModel),
      body: setupBackgroundImagesUI(viewModel),
    );
  }

  /// Navigation
  PreferredSizeWidget? _setupAppBarUI(MainPageViewModel viewModel) {
    return AppBar(
      title: Text(viewModel.mListType[viewModel.mCurrentIndex].pageName),
      backgroundColor: Colors.teal,
    );
  }

  /// TabBar
  Widget _setupTabBarUI(MainPageViewModel viewModel) {
    final listType = viewModel.mListType;
    List<BottomNavigationBarItem> item = [];
    for (MainPageListModel value in listType) {
      item.add(
          BottomNavigationBarItem(
            icon: value.pageIcon,
            activeIcon: value.pageSelectIcon,
            label: value.pageName,
          )
      );
    }

    return BottomNavigationBar(
      currentIndex: viewModel.mCurrentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.blueGrey,
      onTap: _didClickBtmNav,
      items: item,
    );
  }

  /// 背景圖
  Widget setupBackgroundImagesUI(MainPageViewModel viewModel) {
    return Stack(
      children: [
        Opacity(
          child: Image.asset(
            'assets/image/bg.png',
            fit: BoxFit.cover,
          ),
          opacity: 0.5,
        ),
        pages[viewModel.mCurrentIndex],
      ],
      fit: StackFit.expand,
    );
  }

  void _didClickBtmNav(int index) {
    setState(() {
      viewModel.mCurrentIndex = index;
    });
  }
}
