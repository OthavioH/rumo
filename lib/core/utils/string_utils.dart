
extension StringUtils on String {
  double toDouble() {
    try {
      return double.tryParse(this) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}