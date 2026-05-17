import 'package:test/test.dart';
import 'package:very_good_launcher_icons/very_good_launcher_icons.dart';

void main() {
  test('AndroidFlavorIconConfig stores paths', () {
    const config = AndroidFlavorIconConfig(
      name: 'main',
      iconPngPath: 'icon.png',
      roundIconPngPath: 'round.png',
      playStoreIconPngPath: 'playstore.png',
    );

    expect(config.name, equals('main'));
    expect(config.iconPngPath, equals('icon.png'));
    expect(config.roundIconPngPath, equals('round.png'));
    expect(config.playStoreIconPngPath, equals('playstore.png'));
  });

  test('SvgTools applies fill color', () {
    const svg =
        '<svg viewBox="0 0 10 10" fill="none"><path d="M0 0h10v10z" /></svg>';

    final output = SvgTools.applyFillColor(svg, '#7C3AED');

    expect(output, contains('fill="#7C3AED"'));
    expect(output, isNot(contains('fill="none"')));
  });
}
