import 'package:flutter_two_test/help_object/app_config_singleton.dart';
import 'package:flutter_two_test/help_object/user_defaults_manager.dart';
import 'package:flutter_two_test/help_object/word_formatter.dart';

class MemberLoginPageViewModel {

  /// 比對是否是正確的格式
  bool didClickSend(String name, String email, String password) {
    final bool nameIsOk =
        name.isNotEmpty && name.length <= 15;
    final bool emailIsOk = email.isNotEmpty &&
        email.length <= 15 &&
        WordFormatter.isEmail(email);
    final bool passwordIsOk = password.isNotEmpty &&
        password.length <= 15 &&
        WordFormatter.isPassword(password);
    if (nameIsOk && emailIsOk && passwordIsOk) {
      AppConfigSingleton.instance.mUserName = name;
      AppConfigSingleton.instance.mEmail = email;
      AppConfigSingleton.instance.mPassword = password;
      AppConfigSingleton.instance.isLogin = true;
      saveData(name, email, password);
      return true;
    } else {
      return false;
    }
  }

  /// 儲存檔案
  void saveData(String name, String email, String password) async {
    UserDefaultsManager.instance.userEmail = email;
    UserDefaultsManager.instance.userPassword = password;
    UserDefaultsManager.instance.userName = name;
    UserDefaultsManager.instance.userIsLogin = true;
  }
}