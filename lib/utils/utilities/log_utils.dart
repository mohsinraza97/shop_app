import 'package:f_logs/f_logs.dart';

class LogUtils {
  const LogUtils._internal();

  static void init() {
    LogsConfig config = FLog.getDefaultConfigurations()
      ..activeLogLevel = LogLevel.ALL
      ..formatType = FormatType.FORMAT_CUSTOM
      ..fieldOrderFormatCustom = [
        FieldName.TIMESTAMP,
        FieldName.LOG_LEVEL,
        FieldName.CLASSNAME,
        FieldName.METHOD_NAME,
        FieldName.TEXT,
        FieldName.EXCEPTION,
        FieldName.STACKTRACE
      ]
      ..customOpeningDivider = '['
      ..customClosingDivider = ']';
    FLog.applyConfigurations(config);
  }

  static void debug(String className, String methodName, String? message) {
    try {
      FLog.debug(
        className: className,
        methodName: methodName,
        text: message ?? 'null',
      );
    } on Exception catch (e) {
      print('[LogUtils] [debug] [${e.toString()}]');
    }
  }

  static void error(String className, String methodName, dynamic exception) {
    try {
      FLog.error(
        className: className,
        methodName: methodName,
        text: exception == null ? 'null' : exception.toString(),
      );
    } on Exception catch (e) {
      print('[LogUtils] [error] [${e.toString()}]');
    }
  }

  static void _printLogs() {
    FLog.printLogs();
  }

  static Future<void> _export() async {
    await FLog.exportLogs();
  }

  static Future<void> _clear() async {
    await FLog.clearLogs();
  }
}
