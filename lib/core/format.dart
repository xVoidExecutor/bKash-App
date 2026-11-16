import 'package:intl/intl.dart';

String taka(double v) => '৳${NumberFormat('#,##0.00').format(v)}';
String stamp(DateTime d) => DateFormat('hh:mma dd/MM/yy').format(d).toLowerCase();
