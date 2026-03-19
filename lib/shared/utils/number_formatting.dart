String formatMax2Decimals(num value) {
  // Round to 2 decimals, then remove trailing zeros and decimal separator if unnecessary.
  final formatted = value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  return formatted == '-0' ? '0' : formatted;
}

