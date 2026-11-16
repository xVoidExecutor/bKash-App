import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/contacts_data.dart';
import '../../data/send_money_api.dart';
import '../../state/wallet_state.dart';
import '../../widgets/bkash_loader.dart';
import '../../widgets/send_money_widgets.dart';
import '../receipt_page.dart';

class AmountPage extends StatefulWidget {
  final Contact contact;
  final String phone;
  const AmountPage({super.key, required this.contact, required this.phone});
  @override
  State<AmountPage> createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  final ctl = TextEditingController();
  bool charge = false;
  int card = 0;
  static const names = ['সেন্ড মানি', 'অভিনন্দন', 'জন্মদিন', 'বিয়ে'];
  static const imgs = ['send_card', 'greet_congrats', 'greet_birthday', 'greet_wedding'];

  double get a => double.tryParse(ctl.text) ?? 0;
  double get fee => charge ? double.parse((a * 0.0185).toStringAsFixed(2)) : 0;

  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nav = Navigator.of(context);
    final wallet = context.read<WalletState>();
    final msg = ScaffoldMessenger.of(context);
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) => const BkashLoader());

    final raw = await SendMoneyApi.send(
      phone: widget.phone,
      name: widget.contact.name,
      amount: a,
      fee: fee,
      balance: wallet.balance,
      card: names[card],
    );
    final json = jsonDecode(raw) as Map<String, dynamic>; // JSON থেকে স্টেটমেন্ট
    nav.pop(); // লোডার বন্ধ
    if (json['status'] != 'success') {
      msg.showSnackBar(SnackBar(content: Text(json['message'])));
      return;
    }
    final t = wallet.applySend(json);
    nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ReceiptPage(t: t)), (r) => r.isFirst);
  }

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Text(t, style: const TextStyle(color: Colors.black54, fontSize: 14)));

  @override
  Widget build(BuildContext context) {
    final bal = context.watch<WalletState>().balance;
    final over = a > 0 && a + fee > bal;
    final ok = a > 0 && !over;
    final c = widget.contact;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('সেন্ড মানি'), centerTitle: true),
      body: ListView(children: [
        _label('প্রাপক'),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
          child: Row(children: [
            ContactAvatar(c, r: 27),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.name, style: const TextStyle(fontSize: 18)),
              Text(widget.phone, style: const TextStyle(color: Colors.black54)),
            ]),
          ]),
        ),
        const Sep(),
        _label('পরিমাণ'),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: TextField(
            controller: ctl,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 54),
            decoration: const InputDecoration(
              prefixText: '৳',
              prefixStyle: TextStyle(fontSize: 54, color: Colors.black26),
              hintText: '0',
              hintStyle: TextStyle(fontSize: 54, color: Colors.black26),
              border: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text.rich(
            TextSpan(text: 'ব্যবহারযোগ্য ব্যালেন্স: ', children: [
              TextSpan(text: taka(bal), style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 36,
          child: Center(
            child: Text(
              over ? 'ব্যালেন্স যথেষ্ট নয়' : (a > 0 && charge ? 'চার্জ ${taka(fee)} · মোট ${taka(a + fee)}' : ''),
              style: TextStyle(color: over ? Colors.red : Colors.black54, fontSize: 13),
            ),
          ),
        ),
        const Sep(),
        SwitchListTile(
          value: charge,
          activeColor: Colors.white,
          activeTrackColor: kPink,
          onChanged: (v) => setState(() => charge = v),
          title: const Text('ক্যাশ আউট চার্জ যোগ করুন'),
          subtitle: const Text('প্রাপককে চার্জসহ পাঠানোর জন্য'),
        ),
        const Sep(),
        ListTile(
          leading: Image.asset('assets/icons/fav_row.png', width: 28),
          title: const Text('ফ্রি সেন্ড মানি করতে প্রিয় তালিকায় যোগ করুন',
              style: TextStyle(color: kPink, fontWeight: FontWeight.w500, fontSize: 15)),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('প্রিয় তালিকায় যোগ হয়েছে'))),
        ),
        const Sep(),
        _label('শুভেচ্ছা কার্ড সিলেক্ট করুন'),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            itemCount: names.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => card = i),
              child: Container(
                width: 88,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: card == i ? kPink : const Color(0xFFEEEEEE))),
                child: Column(children: [
                  Stack(children: [
                    Container(
                      height: 62, width: double.infinity, color: const Color(0xFFF4F4F4),
                      child: Image.asset('assets/icons/${imgs[i]}.png',
                          fit: i == 0 ? BoxFit.scaleDown : BoxFit.cover),
                    ),
                    if (card == i)
                      const Positioned(right: 4, top: 4,
                          child: CircleAvatar(radius: 10, backgroundColor: kPink,
                              child: Icon(Icons.check, size: 12, color: Colors.white))),
                  ]),
                  Expanded(child: Center(child: Text(names[i], style: const TextStyle(fontSize: 13)))),
                ]),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Material(
        color: ok ? kPink : const Color(0xFFA0A0A0),
        child: SafeArea(
          top: false,
          child: InkWell(
            onTap: ok ? _submit : null,
            child: const SizedBox(
              height: 56,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('এগিয়ে যান', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
