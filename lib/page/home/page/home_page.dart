import 'package:flutter/material.dart';
import 'package:flutter_two_test/ad/inline_adaptive_ad_widget.dart';
import 'package:flutter_two_test/common_widget/carousel_slider_banner.dart';
import 'package:flutter_two_test/page/home/page/home_page_view_model.dart';
import 'package:flutter_two_test/page/home/ui/home_page_info_cell.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomePageViewModel viewModel = HomePageViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: FutureBuilder(
        future: viewModel.getData(),
        builder: (context, snapshot) {
          return _build();
        },
      ),
    );
  }

  Widget _build() {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return _buildRefresher();
      },
    );
  }

  Widget _buildRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropMaterialHeader(),
      controller: viewModel.refreshController,
      onRefresh: () => _onRefresh(),
      child: _buildScrollView(),
    );
  }

  Widget _buildScrollView() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            CarouselSliderBanner(viewModel.mData.isEmpty),
            _buildGridViewUI(),
          ],
        ),
      ),
      floatingActionButton: _buildToTopBtn(),
    );
  }

  Widget _buildToTopBtn() {
    return (!viewModel.showToTopBtn)
        ? Container()
        : FloatingActionButton(
            child: const Icon(Icons.arrow_upward),
            mini: true,
            backgroundColor: Colors.teal.shade300,
            onPressed: () {
              viewModel.scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.linear);
            },
          );
  }

  Widget _buildGridViewUI() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int position) {
            final AttractionsInfo? model =
            viewModel.mData.isNotEmpty ? viewModel.mData[position] : null;
            return position == 9 ? const InlineAdaptiveAdWidget() : _buildCellWidget(model);
          },
          childCount: viewModel.mData.isNotEmpty ? viewModel.mData.length : 9,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (325/3)/150,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      ),
    );
  }

  Widget _buildCellWidget(AttractionsInfo? model) {
    return model == null
        ? Shimmer.fromColors(
            period: const Duration(milliseconds: 700),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: HomePageInfoCell(
              infoModel: model,
            ),
          )
        : HomePageInfoCell(
            infoModel: model,
          );
  }

  void _onRefresh() async {
    final RequestState requestState;
    requestState = await viewModel.getData();
    switch (requestState) {
      case RequestState.LOAD_COMPLETE:
        viewModel.refreshController.refreshCompleted();
        break;
      case RequestState.LOAD_NO_MORE_DATA:
        viewModel.refreshController.refreshCompleted();
        break;
      case RequestState.LOAD_FAILED:
        viewModel.refreshController.refreshFailed();
        break;
    }
  }
}
