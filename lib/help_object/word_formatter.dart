
class WordFormatter  {
  ///郵箱驗證
  static bool isEmail(String str) {
    return RegExp(
        r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }
  ///密碼驗證
  static bool isPassword(String str) {
    return RegExp(
        r"^[ZA-ZZa-z0-9_]+$")
        .hasMatch(str);
  }
}
