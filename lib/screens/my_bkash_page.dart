import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/format.dart';
import '../state/wallet_state.dart';
import 'statement_page.dart';

class MyBkashPage extends StatelessWidget {
  const MyBkashPage({super.key});
  @override
  Widget build(BuildContext c) {
    final w = c.watch<WalletState>();
    return Scaffold(
      appBar: AppBar(title: const Text('মাই বিকাশ')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Center(child: CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/icons/avatar.png'))),
        const SizedBox(height: 8),
        const Center(child: Text('Jamil Mahmud', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 16),
        Card(child: ListTile(title: const Text('বর্তমান ব্যালেন্স'), trailing: Text(taka(w.balance)))),
        Card(child: ListTile(title: const Text('স্টেটমেন্ট'), trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const StatementPage())))),
        Card(child: ListTile(title: const Text('সেভিংস'), trailing: Text(taka(w.savings)))),
        Card(child: ListTile(title: const Text('লোন (বকেয়া)'), trailing: Text(taka(w.loan)))),
      ]),
    );
  }
}
