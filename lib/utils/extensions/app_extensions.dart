extension PrecisionExt on double? {
  String format({int fractionDigits = 2}) {
    return this?.toStringAsFixed(fractionDigits) ?? '0.00';
  }
}
