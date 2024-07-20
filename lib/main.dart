import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_two_test/help_object/app_config_singleton.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:flutter_two_test/help_object/user_defaults_manager.dart';
import 'package:flutter_two_test/page/landing/page/landing_page.dart';
import 'package:flutter_two_test/page/landing/page/main_page.dart';
import 'package:flutter_two_test/page/member/page/member_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'ad/ad_provider_manager.dart';
import 'database/manager/attractions_manager.dart';

Future<void> main() async {
  /// 要先init path_provider才能拿到getApplicationDocumentsDirectory
  WidgetsFlutterBinding.ensureInitialized();

  /// google廣告初始化
  await MobileAds.instance.initialize().then((InitializationStatus status) {
    LogUtil.logI('Initialization done: ${status.adapterStatuses}');
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
          tagForChildDirectedTreatment:
          TagForChildDirectedTreatment.unspecified,
          testDeviceIds: <String>['358240051111110']),//when you run first time you will get your test id in logs then update it here <String>["test id"]
    );
    ///AdManager初始化 創建廣告
    AdProviderManager.instance.loadAd();
  });

  /// UserDefaults init 要在run之前
  await UserDefaultsManager.instance.initUserDefaults();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => myAppState();
}

// ignore: camel_case_types
class myAppState extends State<MyApp> {
  final smartDialogInit = FlutterSmartDialog.init();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => AttractionsManager.instance),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConfigSingleton.instance.appDisplayName,
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: LandingPage(),
          /// 註冊SmartDialog -1
          navigatorObservers: [FlutterSmartDialog.observer],
          /// 註冊SmartDialog -2、註冊OneContext -1
          builder: (context, child) {
            child = smartDialogInit(context,child);
            child = OneContext().builder(context, child);
            return child;
          },
          /// 註冊OneContext -2
          key: OneContext().key,
          /// 註冊route
          routes: {
            "/main": (context) => const MainPage(),
            "/member": (context) => MemberPage(),
          },
        ),
      ),
    );
  }
}
