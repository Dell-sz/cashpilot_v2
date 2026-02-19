import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy', 'pt_BR').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }
}
