import 'package:flutter/material.dart';
import 'package:tragnambo/components/dashboard_card/gradient_text.dart';
import 'package:tragnambo/components/dashboard_card/neon_card.dart';

class NeonGradientCardDemo extends StatelessWidget {
  const NeonGradientCardDemo({super.key, this.onTap, required this.label});

  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 300,
        height: 200,
        child: Center(
          child: NeonCard(
            intensity: 0.5,
            glowSpread: .8,
            child: SizedBox(
              width: 300,
              height: 200,
              child: Center(
                child: GradientText(
                  text: label,
                  fontSize: 44,
                  gradientColors: const [
                    // Pink
                    Color.fromARGB(255, 255, 41, 117),
                    Color.fromARGB(255, 255, 41, 117),
                    Color.fromARGB(255, 9, 221, 222), // Cyan
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
