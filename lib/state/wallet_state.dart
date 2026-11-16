import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/format.dart';
import '../data/models.dart';

class WalletState extends ChangeNotifier {
  double balance = 1250, savings = 0, loan = 0;
  final txns = <Txn>[];
  final inbox = <InboxMsg>[
    InboxMsg('৫% ক্যাশব্যাক', 'অ্যাড মানিতে ৳৫০ পর্যন্ত ক্যাশব্যাক', 'offer', DateTime.now()),
  ];

  double amountOf(Map<String, String> v) => double.tryParse(v['amt'] ?? '') ?? 0;

  String? validate(ServiceDef s, Map<String, String> v) {
    for (final f in s.fields) {
      final x = (v[f.key] ?? '').trim();
      if (f.optional) continue;
      if (x.isEmpty) return '${f.label} দিন';
      if (f.type == FieldType.phone && !RegExp(r'^01\d{9}$').hasMatch(x)) {
        return 'সঠিক ১১ ডিজিটের নম্বর দিন';
      }
      if (f.type == FieldType.amount && !((double.tryParse(x) ?? 0) > 0)) {
        return 'সঠিক পরিমাণ দিন';
      }
    }
    final a = amountOf(v);
    if (!s.credit && !s.noBalance && a + s.fee(a) > balance) {
      return 'ব্যালেন্স যথেষ্ট নয় (${taka(balance)})';
    }
    if (s.id == 'loan' && a > 20000) return 'সর্বোচ্চ লোন ৳20,000';
    return null;
  }

  Txn pay(ServiceDef s, Map<String, String> v) {
    final a = amountOf(v), fee = s.fee(a);
    if (!s.noBalance) balance += s.credit ? a : -(a + fee);
    if (s.id == 'savings') savings += a;
    if (s.id == 'loan') loan += a * 1.015;
    const ch = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    final t = Txn(
      id: List.generate(10, (_) => ch[r.nextInt(ch.length)]).join(),
      title: s.nameBn,
      phone: v['acc'] ?? v['accno'] ?? '',
      ref: v['ref'] ?? '',
      amount: a, fee: fee, balanceAfter: balance,
      at: DateTime.now(), credit: s.credit, isSend: s.id == 'send',
    );
    if (!s.noBalance) txns.insert(0, t);
    inbox.insert(0, InboxMsg('${s.nameBn} সফল',
        '${taka(a)} · TrxID ${t.id} · ব্যালেন্স ${taka(balance)}', 'txn', t.at));
    notifyListeners();
    return t;
  }
}
