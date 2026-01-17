import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG Background Widget
/// Displays themed SVG background that adapts to light/dark theme
class SvgBackground extends StatelessWidget {
  final Widget? child;
  final BoxFit fit;
  final Alignment alignment;

  const SvgBackground({
    super.key,
    this.child,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundPath = isDark
        ? 'svg/background_dark.svg'
        : 'svg/background_light.svg';

    return Stack(
      children: [
        // SVG Background
        Positioned.fill(
          child: SvgPicture.asset(
            backgroundPath,
            fit: fit,
            alignment: alignment,
          ),
        ),
        // Content overlay
        if (child != null) child!,
      ],
    );
  }
}

/// Extension to easily add SVG background to any Scaffold
extension SvgBackgroundExtension on Widget {
  Widget withSvgBackground({
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    return SvgBackground(
      fit: fit,
      alignment: alignment,
      child: this,
    );
  }
}
