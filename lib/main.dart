import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'state/wallet_state.dart';
import 'screens/root_shell.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (_) => WalletState(), child: const BkashApp()));

class BkashApp extends StatelessWidget {
  const BkashApp({super.key});
  @override
  Widget build(BuildContext c) => MaterialApp(
      title: 'bKash',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const RootShell());
}
