
import 'package:logger/logger.dart';

class LogUtil {
  LogUtil._();
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void logD(String msg) {
    _logger.d('$msg 🐛');
  }

  static void logI(String msg) {
    _logger.i('$msg 💡');
  }

  static void logW(String msg) {
    _logger.w('$msg ⚠️');
  }

  static void logE(String msg) {
    _logger.e('$msg ⛔');
  }

  static void logV(String key, String msg) {
    _logger.v({'key': key, 'value': msg});
  }
}