import 'package:flutter/material.dart';

class Contact {
  final String name, phone;
  final Color color;
  final bool fav;
  final List<String> numbers;
  const Contact(this.name, this.phone, this.color,
      {this.fav = false, this.numbers = const []});
}

const recent = [
  Contact('Mohammad Limon', '01352925918', Color(0xFFE0A890), fav: true),
  Contact('Mazba Kayes', '01315626059', Color(0xFFBFD9A0), fav: true),
  Contact('01312198787', '01312198787', Color(0xFFCD9BDB)),
];

const allContacts = [
  Contact('Abbu', '', Color(0xFFDC8FCF), numbers: ['01711000001', '01811000002']),
  Contact('Ainul', '01740188469', Color(0xFF8FD9C8)),
  Contact('Alamgir', '01712304051', Color(0xFF95D494)),
];
