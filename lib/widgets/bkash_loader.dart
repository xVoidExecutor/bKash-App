import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme.dart';

class BkashLoader extends StatefulWidget {
  const BkashLoader({super.key});
  @override
  State<BkashLoader> createState() => _BkashLoaderState();
}

class _BkashLoaderState extends State<BkashLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1900))
    ..repeat();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  Widget _ring(double t, double off) {
    final v = (t + off) % 1;
    return Opacity(
      opacity: .55 * (1 - v),
      child: Transform.scale(
        scale: .55 + v * .95,
        child: Container(
          width: 110, height: 110,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: kPink, width: 3)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 140, height: 140,
              child: AnimatedBuilder(
                animation: c,
                builder: (_, __) {
                  final t = c.value;
                  final pop = Curves.elasticOut.transform((t * 2.2).clamp(0.0, 1.0));
                  final fade = t < .85 ? 1.0 : 1 - (t - .85) / .15;
                  return Stack(alignment: Alignment.center, children: [
                    _ring(t, 0),
                    _ring(t, .33),
                    Transform.scale(
                      scale: .5 + .5 * pop,
                      child: Opacity(
                        opacity: fade,
                        child: SvgPicture.asset('assets/nav/bkash_bird.svg', width: 92),
                      ),
                    ),
                  ]);
                },
              ),
            ),
            const SizedBox(height: 28),
            const Text('আপনার সেন্ড মানি প্রক্রিয়া হচ্ছে…',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          ]),
        ),
      );
}
