import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/services_data.dart';
import '../state/wallet_state.dart';
import 'flow_pages.dart';
import 'send_money/contacts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show = false;

  @override
  Widget build(BuildContext c) {
    final w = c.watch<WalletState>();
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 150, width: double.infinity, color: kPink,
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/icons/avatar.png')),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Jamil Mahmud', style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() => show = true);
                  Future.delayed(const Duration(seconds: 4), () {
                    if (mounted) setState(() => show = false);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Text(show ? taka(w.balance) : 'ব্যালেন্স জানতে ট্যাপ করুন',
                      style: const TextStyle(fontSize: 13)),
                ),
              ),
            ]),
          ]),
        ),
        Transform.translate(
          offset: const Offset(0, -16),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
            padding: const EdgeInsets.fromLTRB(6, 22, 6, 12),
            child: GridView.count(
              crossAxisCount: 4, childAspectRatio: .82,
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final s in services)
                  InkWell(
                    onTap: () => Navigator.push(c, MaterialPageRoute(
    builder: (_) => s.id == 'send'
        ? const ContactsPage()
        : ServiceFormPage(def: s))),
                    child: Column(children: [
                      Image.asset('assets/icons/${s.icon}.png', width: 52),
                      const SizedBox(height: 6),
                      Text(s.nameBn, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    ]),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
