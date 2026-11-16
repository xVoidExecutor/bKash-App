import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'my_bkash_page.dart';
import 'scan_page.dart';
import 'inbox_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int i = 0;
  Widget _ic(String f) => SvgPicture.asset('assets/nav/$f.svg', width: 24);

  @override
  Widget build(BuildContext c) => Scaffold(
        body: IndexedStack(index: i, children: const [
          HomePage(), MyBkashPage(), ScanPage(), InboxPage()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (x) => setState(() => i = x),
          destinations: [
            NavigationDestination(icon: _ic('home'), selectedIcon: _ic('home_active'), label: 'হোম'),
            NavigationDestination(icon: _ic('my_bkash'), selectedIcon: _ic('my_bkash_active'), label: 'মাই বিকাশ'),
            NavigationDestination(icon: _ic('global_qr'), label: 'স্ক্যান কিউআর'),
            NavigationDestination(icon: _ic('inbox'), selectedIcon: _ic('inbox_active'), label: 'ইনবক্স'),
          ],
        ),
      );
}
