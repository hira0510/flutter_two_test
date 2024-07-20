import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/ad/anchored_adaptive_ad_widget.dart';
import 'package:flutter_two_test/database/manager/attractions_manager.dart';
import 'package:flutter_two_test/page/favor/page/favor_page_view_model.dart';
import 'package:flutter_two_test/page/home/ui/home_page_info_cell.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavorPage extends StatelessWidget {
  FavorPage({Key? key}) : super(key: key);

  final FavorPageViewModel viewModel = FavorPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttractionsManager>(
      builder: (context, attractionsManager, child) {
        return FutureBuilder(
          future: viewModel.getData(),
          builder: (context, snapshot) {
            viewModel.stateDone =
                snapshot.connectionState == ConnectionState.done;
            return _build();
          },
        );
      },
    );
  }

  Widget _build() {
    return Stack(
      children: [
        SizedBox(
          width: 375.r,
          height: 530.r,
          child: CustomScrollView(
            slivers: [
              _gridViewUI(),
            ],
          ),
        ),
        _buildAnchoredAdaptive(),
      ],
    );
  }

  Widget _gridViewUI() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20, bottom: 75, left: 15, right: 15),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int position) {
            final AttractionsInfo? model =
                viewModel.mData.isNotEmpty ? viewModel.mData[position] : null;
            return _buildCellWidget(model);
          },
          childCount: viewModel.mData.isNotEmpty || viewModel.stateDone
              ? viewModel.mData.length
              : 9,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
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
}
