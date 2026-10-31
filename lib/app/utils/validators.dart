class Validators {
  Validators._();

  static bool isName(String? v) {
    if (v == null) return false;
    final t = v.trim();
    return t.length >= 2 && t.length <= 40;
  }

  static bool isAge(int? v) {
    if (v == null) return false;
    return v >= 5 && v <= 99;
  }

  static bool isEmail(String? v) {
    if (v == null) return false;
    return RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(v.trim());
  }

  static bool notEmpty(String? v) => (v ?? '').trim().isNotEmpty;
}