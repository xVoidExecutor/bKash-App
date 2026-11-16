import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/format.dart';
import '../state/wallet_state.dart';
import 'receipt_page.dart';

class StatementPage extends StatelessWidget {
  const StatementPage({super.key});
  @override
  Widget build(BuildContext c) {
    final txns = c.watch<WalletState>().txns;
    return Scaffold(
      appBar: AppBar(title: const Text('স্টেটমেন্ট')),
      body: txns.isEmpty
          ? const Center(child: Text('এখনো কোনো লেনদেন নেই'))
          : ListView(children: [
              for (final t in txns)
                ListTile(
                  title: Text(t.title),
                  subtitle: Text('${stamp(t.at)} · ${t.id}'),
                  trailing: Text('${t.credit ? '+' : '−'}${taka(t.credit ? t.amount : t.amount + t.fee)}',
                      style: TextStyle(color: t.credit ? Colors.green : Colors.red)),
                  onTap: t.isSend
                      ? () => Navigator.push(c, MaterialPageRoute(builder: (_) => ReceiptPage(t: t)))
                      : null,
                ),
            ]),
    );
  }
}
