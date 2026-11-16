import 'package:flutter/material.dart';
import '../data/services_data.dart';
import 'flow_pages.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('স্ক্যান কিউআর')),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 240, height: 240,
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(16))),
          const SizedBox(height: 16),
          const Text('মার্চেন্টের কিউআর কোড স্ক্যান করুন'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.push(c, MaterialPageRoute(
                builder: (_) => ServiceFormPage(def: services.firstWhere((s) => s.id == 'payment')))),
            child: const Text('কিউআর স্ক্যান (ডেমো)')),
        ])),
      );
}
