import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String date(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat.yMMMd().format(d);
  }

  static String year(String? iso) {
    if (iso == null || iso.length < 4) return '';
    return iso.substring(0, 4);
  }

  static String runtime(int? minutes) {
    if (minutes == null || minutes <= 0) return '';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  static String money(int? value) {
    if (value == null || value <= 0) return '';
    final f = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1);
    return f.format(value);
  }

  static String compact(int? value) {
    if (value == null || value <= 0) return '';
    final f = NumberFormat.compact();
    return f.format(value);
  }
}