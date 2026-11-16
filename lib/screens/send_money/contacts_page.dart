import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/contacts_data.dart';
import '../../widgets/send_money_widgets.dart';
import '../flow_pages.dart';
import '../../data/services_data.dart';
import 'amount_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String q = '';

  bool _m(Contact c) =>
      q.isEmpty ||
      c.name.toLowerCase().contains(q) ||
      c.phone.contains(q) ||
      c.numbers.any((n) => n.contains(q));

  void _go(Contact c, String phone) => Navigator.push(context,
      MaterialPageRoute(builder: (_) => AmountPage(contact: c, phone: phone)));

  void _soon() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('এই ফিচারটি ডেমোতে নেই')));

  Widget _h(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
      child: Text(t, style: const TextStyle(color: Colors.black54, fontSize: 13)));

  Widget _tile(Contact c) {
    if (c.numbers.isEmpty) {
      return ListTile(
        leading: ContactAvatar(c),
        title: Text(c.name, style: const TextStyle(fontSize: 17)),
        subtitle: Text(c.phone),
        onTap: () => _go(c, c.phone),
      );
    }
    return ExpansionTile(
      leading: ContactAvatar(c),
      title: Text(c.name, style: const TextStyle(fontSize: 17)),
      subtitle: Text('${c.numbers.length} টি সেভ করা নাম্বার'),
      shape: const Border(),
      children: [
        for (final n in c.numbers)
          ListTile(
              contentPadding: const EdgeInsets.only(left: 84),
              title: Text(n),
              onTap: () => _go(c, n)),
      ],
    );
  }

  Widget _card(Widget icon, String label, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 97, height: 118,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0E4EA)),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 4)],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [icon, Text(label, style: const TextStyle(fontSize: 14))]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final typed = RegExp(r'^01\d{9}$').hasMatch(q)
        ? Contact(q, q, const Color(0xFFCD9BDB))
        : null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('সেন্ড মানি'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: SvgPicture.asset('assets/nav/bkash_bird.svg', width: 28,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (x) => setState(() => q = x.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'নাম বা নাম্বার দিন',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const Sep(),
        SizedBox(
          height: 146,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            children: [
              _card(Image.asset('assets/icons/fav.png', width: 30), 'প্রিয় নাম্বার (4)', _soon),
              const SizedBox(width: 12),
              _card(Image.asset('assets/icons/bundle.png', width: 30), 'বিকাশ বান্ডেল', _soon),
              const SizedBox(width: 12),
              _card(Image.asset('assets/icons/request.png', width: 30), 'রিকোয়েস্ট মানি', () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ServiceFormPage(
                        def: services.firstWhere((s) => s.id == 'request'))));
              }),
              const SizedBox(width: 12),
              _card(const Icon(Icons.history, color: Color(0xFFE2136E), size: 30), 'অটো পে', _soon),
            ],
          ),
        ),
        const Sep(),
        if (typed != null) ...[_h('নাম্বারে পাঠান'), _tile(typed), const Sep()],
        if (recent.any(_m)) ...[_h('সাম্প্রতিক'), ...recent.where(_m).map(_tile), const Sep()],
        if (allContacts.any(_m)) ...[_h('সব কন্ট্যাক্টস'), ...allContacts.where(_m).map(_tile)],
      ]),
    );
  }
}
