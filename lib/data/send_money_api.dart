import 'dart:convert';
import 'dart:math';

class SendMoneyApi {
  static Future<String> send({
    required String phone,
    required String name,
    required double amount,
    required double fee,
    required double balance,
    required String card,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2400));
    final nb = balance - (amount + fee);
    if (nb < 0) {
      return jsonEncode({'status': 'error', 'message': 'ব্যালেন্স যথেষ্ট নয়'});
    }
    const ch = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    return jsonEncode({
      'status': 'success',
      'message': 'Send Money successful',
      'data': {
        'trxId': List.generate(10, (_) => ch[r.nextInt(ch.length)]).join(),
        'type': 'SEND_MONEY',
        'receiver': {'name': name, 'msisdn': phone},
        'amount': amount,
        'fee': fee,
        'total': amount + fee,
        'newBalance': nb,
        'reference': '',
        'greetingCard': card,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      },
    });
  }
}
