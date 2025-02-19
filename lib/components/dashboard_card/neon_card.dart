import 'package:flutter/material.dart';
import 'package:tragnambo/components/dashboard_card/glow_rectangle_painter.dart';

class NeonCard extends StatefulWidget {
  final Widget child;
  final double intensity;
  final double glowSpread;

  const NeonCard({
    super.key,
    required this.child,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  @override
  _NeonCardState createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowRectanglePainter(
            progress: _controller.value,
            intensity: widget.intensity,
            glowSpread: widget.glowSpread,
          ),
          child: widget.child,
        );
      },
    );
  }
}
