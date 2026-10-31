import 'dart:math';

import 'package:flutter/material.dart';

import '../brain/maxine_brain.dart';

/// Animated na mukha ni Maxine. Gumagalaw ang bibig kapag nagsasalita,
/// at kumukurap ang mata.
class MaxineFace extends StatefulWidget {
  final Face face;
  final bool talking;
  final double size;
  const MaxineFace({super.key, required this.face, required this.talking, this.size = 120});

  @override
  State<MaxineFace> createState() => _MaxineFaceState();
}

class _MaxineFaceState extends State<MaxineFace> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => CustomPaint(
        size: Size.square(widget.size),
        painter: _FacePainter(widget.face, widget.talking, _c.value),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  final Face face;
  final bool talking;
  final double t; // 0..1 loop
  _FacePainter(this.face, this.talking, this.t);

  Color get _skin => switch (face) {
        Face.concerned => const Color(0xFFB9D7FF),
        Face.love => const Color(0xFFFFC2DA),
        Face.excited => const Color(0xFFFFE08A),
        Face.thinking => const Color(0xFFD9C8FF),
        Face.calm => const Color(0xFFBFF0D4),
        Face.happy => const Color(0xFFFFD6A5),
      };

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final c = Offset(w / 2, w / 2);
    final bob = sin(t * 2 * pi) * w * 0.015;
    canvas.translate(0, bob);

    // ulo
    canvas.drawCircle(c, w * 0.46, Paint()..color = _skin);
    canvas.drawCircle(
        c,
        w * 0.46,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.02);

    // pisngi
    final blush = Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.45);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.27, w * 0.6), width: w * 0.14, height: w * 0.08), blush);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.73, w * 0.6), width: w * 0.14, height: w * 0.08), blush);

    // mata (kumukurap)
    final blink = (t > 0.48 && t < 0.52);
    final ink = Paint()..color = const Color(0xFF2B2B3A);
    final le = Offset(w * 0.35, w * 0.43), re = Offset(w * 0.65, w * 0.43);
    if (face == Face.love) {
      _heart(canvas, le, w * 0.09, Paint()..color = const Color(0xFFE63E6D));
      _heart(canvas, re, w * 0.09, Paint()..color = const Color(0xFFE63E6D));
    } else if (blink) {
      final p = Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round;
      for (final e in [le, re]) {
        canvas.drawArc(Rect.fromCenter(center: e, width: w * 0.1, height: w * 0.07), pi, -pi, false, p);
      }
    } else {
      final eh = face == Face.excited ? w * 0.13 : w * 0.11;
      for (final e in [le, re]) {
        canvas.drawOval(Rect.fromCenter(center: e, width: w * 0.085, height: eh), ink);
        canvas.drawCircle(e.translate(w * 0.015, -w * 0.025), w * 0.017, Paint()..color = Colors.white);
      }
    }

    // kilay kapag nag-aalala o nag-iisip
    if (face == Face.concerned || face == Face.thinking) {
      final p = Paint()
        ..color = ink.color
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(w * 0.28, w * 0.31), Offset(w * 0.4, w * 0.28), p);
      if (face == Face.concerned) {
        canvas.drawLine(Offset(w * 0.72, w * 0.31), Offset(w * 0.6, w * 0.28), p);
      } else {
        canvas.drawLine(Offset(w * 0.6, w * 0.26), Offset(w * 0.72, w * 0.26), p);
      }
    }

    // bibig
    final mouthC = Offset(w / 2, w * 0.68);
    if (talking) {
      final open = (sin(t * 2 * pi * 18).abs() * 0.6 + 0.4) * w * 0.12;
      canvas.drawOval(Rect.fromCenter(center: mouthC, width: w * 0.16, height: open), Paint()..color = const Color(0xFF8E2C48));
    } else {
      final p = Paint()
        ..color = ink.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round;
      switch (face) {
        case Face.concerned:
          canvas.drawArc(Rect.fromCenter(center: mouthC.translate(0, w * 0.04), width: w * 0.16, height: w * 0.08), pi, pi, false, p);
        case Face.thinking:
          canvas.drawLine(mouthC.translate(-w * 0.06, 0), mouthC.translate(w * 0.06, -w * 0.02), p);
        case Face.excited:
          final path = Path()
            ..moveTo(mouthC.dx - w * 0.11, mouthC.dy - w * 0.02)
            ..quadraticBezierTo(mouthC.dx, mouthC.dy + w * 0.16, mouthC.dx + w * 0.11, mouthC.dy - w * 0.02)
            ..close();
          canvas.drawPath(path, Paint()..color = const Color(0xFF8E2C48));
        default:
          canvas.drawArc(Rect.fromCenter(center: mouthC.translate(0, -w * 0.03), width: w * 0.2, height: w * 0.12), 0.15, pi - 0.3, false, p);
      }
    }
  }

  void _heart(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path()
      ..moveTo(c.dx, c.dy + r * 0.8)
      ..cubicTo(c.dx - r * 1.4, c.dy - r * 0.2, c.dx - r * 0.5, c.dy - r * 1.2, c.dx, c.dy - r * 0.4)
      ..cubicTo(c.dx + r * 0.5, c.dy - r * 1.2, c.dx + r * 1.4, c.dy - r * 0.2, c.dx, c.dy + r * 0.8);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_FacePainter o) => o.t != t || o.face != face || o.talking != talking;
}
