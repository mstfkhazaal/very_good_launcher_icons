class SvgTools {
  const SvgTools._();

  static String applyFillColor(String svg, String color) {
    final normalizedColor = color.startsWith('#') ? color : '#$color';

    var output = svg;

    output = output.replaceAll(
      RegExp(r'\sfill="[^"]*"'),
      '',
    );

    output = output.replaceFirst(
      RegExp(r'<svg\b'),
      '<svg fill="$normalizedColor"',
    );

    return output;
  }
}
