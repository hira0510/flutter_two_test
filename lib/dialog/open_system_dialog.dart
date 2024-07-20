import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/help_object/link_factory.dart';
import 'package:one_context/one_context.dart';

class OpenSystemDialog extends StatelessWidget {
  const OpenSystemDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          width: 250.r,
          height: 300.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildTitleText(),
              _buildScrollText(),
              _buildConfirmBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return SizedBox(
      height: 50.r,
      child: Center(
        child: Text(
          '系統公告',
          style: TextStyle(
            color: Colors.indigoAccent,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScrollText() {
    return Container(
      height: 200.r,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Html(
          style: {
            "p": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
            "body": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
          },
          data: testText(),
          onLinkTap: (url, _, __, ___) {
            LinkFactory.launchUrl(url);
          },
        ),
      ),
    );
  }

  Widget _buildConfirmBtn() {
    return Expanded(
      child: Center(
        child: MaterialButton(
          color: Colors.indigoAccent,
          highlightColor: Colors.indigo,
          splashColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '確認',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 16.sp,
            ),
          ),
          onPressed: () {
            /// OneContext
            final context = OneContext.instance.context;
            if (context != null) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  String testText() {
    return "<p><span style=\"color: #ff0000;\">ขณะนี้เราได้ตรวจพบข้อความการเชิญชวนให้ลงทุน ซึ่งขอเรียนแจ้งว่า บริษัทฯ ไม่มีนโยบายหรือการกระทำดังกล่าว จึงขอเรียนแจ้งมาให้ทราบและโปรดระมัดระวัง<br /></span><br /><span style=\"color: #ff6600;\">我用</span><span style=\"text-decoration: underline;\">shift+enter</span><em>跳三行</em>，<strong>中間打</strong><span style=\"text-decoration: line-through;\">這串</span><br /><br />❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️<br />❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️<br />❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️<br /><br /><br />❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️</p>";
  }
}
