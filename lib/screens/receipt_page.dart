import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/models.dart';

class ReceiptPage extends StatefulWidget {
  final Txn t;
  const ReceiptPage({super.key, required this.t});
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool show = true;
  static const green = Color(0xFF1A8F3C), line = Color(0xFFE6E6E6);

  Widget cell(String l, Widget v) => Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        constraints: const BoxConstraints(minHeight: 78),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: const TextStyle(color: Colors.black54, fontSize: 15)), v]),
      );

  @override
  Widget build(BuildContext c) {
    final t = widget.t;
    final b = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 0), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text.rich(TextSpan(style: const TextStyle(fontSize: 20, color: kPink), children: [
            const TextSpan(text: 'আপনার '),
            const TextSpan(text: 'সেন্ড মানি ', style: TextStyle(fontWeight: FontWeight.w600)),
            const TextSpan(text: 'সফল হয়েছে', style: TextStyle(fontWeight: FontWeight.w600, color: green)),
          ])),
          Container(width: 44, height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: green, width: 2)),
              child: const Icon(Icons.check, color: green)),
        ]),
        const SizedBox(height: 36),
        Row(children: [
          const CircleAvatar(radius: 30, backgroundColor: Color(0xFFD9899F),
              child: Icon(Icons.person, color: Colors.white, size: 32)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.phone, style: const TextStyle(fontSize: 18)),
            const Text('বিকাশ অ্যাকাউন্ট', style: TextStyle(color: Colors.black54))])),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.call), label: const Text('কল')),
        ]),
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
          child: Column(children: [
            Row(children: [
              Expanded(child: cell('সময়', Text(stamp(t.at), style: b))),
              Expanded(child: cell('ট্রানজেকশন আইডি', Row(children: [
                Text(t.id, style: b),
                IconButton(icon: const Icon(Icons.copy, size: 18, color: kPink),
                    onPressed: () => Clipboard.setData(ClipboardData(text: t.id)))]))),
            ]),
            Row(children: [
              Expanded(child: cell('সর্বমোট', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(taka(t.amount + t.fee), style: b),
                Text('${taka(t.amount)} + ${taka(t.fee)}', style: const TextStyle(color: Colors.black45))]))),
              Expanded(child: cell('নতুন ব্যালেন্স', Row(children: [
                Text(show ? taka(t.balanceAfter) : '৳ ••••', style: b),
                IconButton(icon: Icon(show ? Icons.visibility : Icons.visibility_off, color: kPink),
                    onPressed: () => setState(() => show = !show))]))),
            ]),
            cell('রেফারেন্স', Text(t.ref, style: b)),
          ]),
        ),
        const Spacer(),
        SizedBox(height: 62, width: double.infinity, child: FilledButton(
          style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)))),
          onPressed: () => Navigator.popUntil(c, (r) => r.isFirst),
          child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('হোম-এ ফিরে যাই', style: TextStyle(fontSize: 20)), Icon(Icons.arrow_forward)]))),
      ]))),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final Txn t;
  const SuccessPage({super.key, required this.t});
  @override
  Widget build(BuildContext c) => Scaffold(
        body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
          mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, color: Color(0xFF2FB26A), size: 90),
            const SizedBox(height: 12),
            Text('${t.title} সফল হয়েছে', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('${taka(t.amount)} · TrxID ${t.id}'),
            Text('নতুন ব্যালেন্স ${taka(t.balanceAfter)}'),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => Navigator.popUntil(c, (r) => r.isFirst), child: const Text('সম্পন্ন')),
          ]))),
      );
}
