import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/format.dart';
import '../data/models.dart';
import '../state/wallet_state.dart';
import 'receipt_page.dart';

class ServiceFormPage extends StatefulWidget {
  final ServiceDef def;
  const ServiceFormPage({super.key, required this.def});
  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final v = <String, String>{};
  String? err;

  @override
  void initState() {
    super.initState();
    for (final f in widget.def.fields) {
      if (f.type == FieldType.select) v[f.key] = f.options.first;
    }
  }

  Widget _field(Field f) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: f.type == FieldType.select
            ? DropdownButtonFormField<String>(
                value: v[f.key],
                decoration: InputDecoration(labelText: f.label),
                items: [for (final o in f.options) DropdownMenuItem(value: o, child: Text(o))],
                onChanged: (x) => v[f.key] = x!)
            : TextField(
                keyboardType: f.type == FieldType.text ? TextInputType.text : TextInputType.number,
                decoration: InputDecoration(labelText: f.label),
                onChanged: (x) => v[f.key] = x.trim()),
      );

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: Text(widget.def.nameBn)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          for (final f in widget.def.fields) _field(f),
          if (err != null) Text(err!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              final e = c.read<WalletState>().validate(widget.def, v);
              if (e != null) return setState(() => err = e);
              Navigator.push(c, MaterialPageRoute(
                  builder: (_) => ConfirmPage(def: widget.def, v: Map.of(v))));
            },
            child: const Text('পরবর্তী'),
          ),
        ]),
      );
}

class ConfirmPage extends StatelessWidget {
  final ServiceDef def;
  final Map<String, String> v;
  const ConfirmPage({super.key, required this.def, required this.v});

  @override
  Widget build(BuildContext c) {
    final a = c.read<WalletState>().amountOf(v), fee = def.fee(a);
    Widget row(String l, String r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l), Text(r)]));
    return Scaffold(
      appBar: AppBar(title: const Text('নিশ্চিত করুন')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Text(taka(a), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
        const Divider(),
        for (final f in def.fields.where((f) => f.type != FieldType.amount))
          if ((v[f.key] ?? '').isNotEmpty) row(f.label, v[f.key]!),
        row('চার্জ', taka(fee)),
        row(def.credit ? 'মোট যোগ হবে' : 'মোট কাটা হবে', taka(def.credit ? a : a + fee)),
        const Spacer(),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () => Navigator.push(c, MaterialPageRoute(builder: (_) => PinPage(def: def, v: v))),
          child: const Text('নিশ্চিত করুন'))),
      ])),
    );
  }
}

class PinPage extends StatefulWidget {
  final ServiceDef def;
  final Map<String, String> v;
  const PinPage({super.key, required this.def, required this.v});
  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String pin = '';
  bool busy = false;

  Future<void> _submit() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final t = context.read<WalletState>().pay(widget.def, widget.v);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => t.isSend ? ReceiptPage(t: t) : SuccessPage(t: t)),
        (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('পিন দিন')),
        body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          const Text('আপনার বিকাশ পিন দিন (ডেমো: যেকোনো ৫ ডিজিট)'),
          const SizedBox(height: 16),
          TextField(
            obscureText: true, maxLength: 5, textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 28, letterSpacing: 12),
            onChanged: (x) => setState(() => pin = x)),
          const Spacer(),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: pin.length == 5 && !busy ? _submit : null,
            child: busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('নিশ্চিত করুন'))),
        ])),
      );
}
