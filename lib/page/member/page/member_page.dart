import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/ad/anchored_adaptive_ad_widget.dart';
import 'package:flutter_two_test/page/member/page/member_login_page.dart';
import 'package:provider/provider.dart';
import 'member_data_page.dart';
import 'member_page_view_model.dart';

// ignore: camel_case_types, must_be_immutable
class MemberPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final didClickBtmNav;

  // ignore: prefer_const_constructors_in_immutables
  MemberPage({Key? key, this.didClickBtmNav}) : super(key: key);
  MemberPageViewModel viewModel = MemberPageViewModel();

  @override
  Widget build(BuildContext context) {
    viewModel.setupIsLoginUI();
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: _bgContainerUI(context),
    );
  }

  /// 背景容器
  Widget _bgContainerUI(BuildContext context) {
    return Consumer<MemberPageViewModel>(builder: (key, model, child) {
      return Container(
        padding: const EdgeInsets.only(top: 50),
        height: 300,
        child: Stack(
          children: [
            Column(
              children: [
                _memberImageUI(),
                _memberNameTextUI(model.userName),
                _listViewContainUI(context)
              ],
            ),
            _buildAnchoredAdaptive()
          ],
        ),
      );
    });
  }

  /// 會員圖片
  Widget _memberImageUI() {
    return const CircleAvatar(
      backgroundColor: Colors.blue,
      backgroundImage: AssetImage('assets/image/btn_cat2.png'),
      radius: 70,
    );
  }

  /// 會員名稱
  Widget _memberNameTextUI(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 25, color: Colors.indigo),
    );
  }

  /// 包ListView的View
  Widget _listViewContainUI(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        color: const Color.fromRGBO(255, 255, 255, 0.8),
        child: _listViewUI(context),
      ),
    );
  }

  /// 列表
  Widget _listViewUI(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.mListType.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: _listViewCellUI(index),
            onTap: () => didClickItem(context, index));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.indigo);
      },
    );
  }

  /// 列表Cell
  Widget _listViewCellUI(int index) {
    return ListTile(
      leading: Icon(
        viewModel.mListType[index].pageIcon,
        color: Colors.teal,
      ),
      title: Text(viewModel.mListType[index].pageName),
      tileColor: Colors.white,
    );
  }

  ///锚定自适应横幅廣告
  Widget _buildAnchoredAdaptive() {
    return Positioned(
      left: 15,
      right: 15,
      bottom: 5,
      child: SizedBox(
        width: 345.r,
        height: 50.r,
        child: const AnchoredAdaptiveAdWidget(),
      ),
    );
  }

  void didClickItem(BuildContext context, int index) async {
    switch (viewModel.mListType[index].mIndex) {
      case 0:
        MemberDataPage.start(context);
        break;
      case 1:
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => MemberLoginPage()));
        viewModel.setupIsLoginUI();
        break;
      default:
        didClickBtmNav(1);
    }
  }
}
