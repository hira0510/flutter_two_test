import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget(
    this.url, {
    Key? key,
    this.fit = BoxFit.cover,
    this.placeholder = 'assets/image/700049拷貝.png',
  }) : super(key: key);

  final String url;
  final String? placeholder;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return (url.contains('http')) ? CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Image.asset(
        placeholder!,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    ): _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          placeholder!,
          fit: BoxFit.cover,
        ),
        Center(
          child: Text(
            '尚無圖片',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
