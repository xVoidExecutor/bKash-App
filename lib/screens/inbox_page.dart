import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_state.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  @override
  Widget build(BuildContext c) {
    final msgs = c.watch<WalletState>().inbox;
    return Scaffold(
      appBar: AppBar(title: const Text('ইনবক্স')),
      body: ListView(children: [
        for (final m in msgs)
          ListTile(
            leading: CircleAvatar(child: Text(m.kind == 'txn' ? '৳' : '%')),
            title: Text(m.title), subtitle: Text(m.body)),
      ]),
    );
  }
}
