import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/contacts_data.dart';

class ContactAvatar extends StatelessWidget {
  final Contact c;
  final double r;
  const ContactAvatar(this.c, {super.key, this.r = 25});

  @override
  Widget build(BuildContext context) => Stack(clipBehavior: Clip.none, children: [
        CircleAvatar(
          radius: r,
          backgroundColor: c.color,
          child: Text(c.name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 22)),
        ),
        if (c.fav)
          Positioned(
            right: -4, top: -4,
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                  color: kPink, shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.star, size: 11, color: Colors.white),
            ),
          ),
      ]);
}

class Sep extends StatelessWidget {
  const Sep({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(height: 7, color: const Color(0xFFF2F2F4));
}
