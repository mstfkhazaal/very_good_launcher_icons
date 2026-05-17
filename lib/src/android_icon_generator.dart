import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart' as p;

/// Android icon configuration for a single source set/flavor.
///
/// Example source sets:
/// - main
/// - development
/// - staging
class AndroidFlavorIconConfig {
  const AndroidFlavorIconConfig({
    required this.name,
    required this.iconPngPath,
    required this.roundIconPngPath,
    required this.playStoreIconPngPath,
  });

  /// Android source set name.
  ///
  /// Example:
  /// android/app/src/main
  /// android/app/src/development
  /// android/app/src/staging
  final String name;

  /// Normal launcher icon source image.
  ///
  /// This generates:
  /// android/app/src/<flavor>/res/mipmap-*/ic_launcher.png
  final String iconPngPath;

  /// Round/circle-safe launcher icon source image.
  ///
  /// This generates:
  /// android/app/src/<flavor>/res/mipmap-*/ic_launcher_round.png
  final String roundIconPngPath;

  /// Google Play Store icon source image.
  ///
  /// This generates:
  /// android/app/src/<flavor>/ic_launcher-playstore.png
  ///
  /// The generated output is always resized to 512x512.
  final String playStoreIconPngPath;
}

/// Generates Android launcher icons for Very Good CLI flavored projects.
///
/// This generator intentionally writes only the Very Good CLI launcher files:
///
/// - res/mipmap-mdpi/ic_launcher.png
/// - res/mipmap-mdpi/ic_launcher_round.png
/// - res/mipmap-hdpi/ic_launcher.png
/// - res/mipmap-hdpi/ic_launcher_round.png
/// - res/mipmap-xhdpi/ic_launcher.png
/// - res/mipmap-xhdpi/ic_launcher_round.png
/// - res/mipmap-xxhdpi/ic_launcher.png
/// - res/mipmap-xxhdpi/ic_launcher_round.png
/// - res/mipmap-xxxhdpi/ic_launcher.png
/// - res/mipmap-xxxhdpi/ic_launcher_round.png
/// - res/mipmap-anydpi-v26/ic_launcher.xml
/// - res/mipmap-anydpi-v26/ic_launcher_round.xml
/// - res/values/ic_launcher_background.xml
/// - ic_launcher-playstore.png
///
/// It does not generate drawable density launcher PNGs because Very Good CLI
/// projects usually keep launcher bitmap files in mipmap directories.
class AndroidIconGenerator {
  const AndroidIconGenerator({
    required this.backgroundColor,
    required this.flavors,
    required this.removeGeneratedDrawablePngs,
  });

  /// Adaptive icon background color.
  ///
  /// Example: #080A12
  final String backgroundColor;

  /// Android flavor/source-set icon definitions.
  final List<AndroidFlavorIconConfig> flavors;

  /// Deletes old generated launcher PNGs from drawable density folders.
  ///
  /// This only deletes:
  /// - drawable-*/ic_launcher_foreground.png
  /// - drawable-*/ic_launcher_monochrome.png
  ///
  /// It does not delete:
  /// - drawable/ic_launcher_foreground.xml
  /// - drawable/launch_background.xml
  /// - splash assets
  final bool removeGeneratedDrawablePngs;

  static const _launcherSizes = <String, int>{
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  static const _playStoreIconSize = 512;

  Future<void> generate() async {
    for (final flavor in flavors) {
      final icon = _readPng(
        filePath: flavor.iconPngPath,
        label: 'launcher icon',
      );

      final roundIcon = _readPng(
        filePath: flavor.roundIconPngPath,
        label: 'round launcher icon',
      );

      final playStoreIcon = _readPng(
        filePath: flavor.playStoreIconPngPath,
        label: 'Play Store icon',
      );

      final sourceSet = p.join('android', 'app', 'src', flavor.name);
      final resPath = p.join(sourceSet, 'res');

      await _generateLauncherIcons(
        resPath: resPath,
        icon: icon,
        roundIcon: roundIcon,
      );

      await _writeAdaptiveXml(resPath);
      await _writeBackgroundColor(resPath);

      await _writePlayStoreIcon(
        sourceSet: sourceSet,
        image: playStoreIcon,
      );

      if (removeGeneratedDrawablePngs) {
        await _removeGeneratedDrawablePngs(resPath);
      }

      stdout.writeln('Updated Android source set: $sourceSet');
    }
  }

  Image _readPng({
    required String filePath,
    required String label,
  }) {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw FileSystemException('$label PNG not found', filePath);
    }

    final image = decodePng(file.readAsBytesSync());

    if (image == null) {
      throw FormatException('Invalid $label PNG file: $filePath');
    }

    return image;
  }

  Future<void> _generateLauncherIcons({
    required String resPath,
    required Image icon,
    required Image roundIcon,
  }) async {
    for (final entry in _launcherSizes.entries) {
      final directory = Directory(p.join(resPath, entry.key));
      await directory.create(recursive: true);

      final resizedIcon = copyResize(
        icon,
        width: entry.value,
        height: entry.value,
        interpolation: Interpolation.cubic,
      );

      final resizedRoundIcon = copyResize(
        roundIcon,
        width: entry.value,
        height: entry.value,
        interpolation: Interpolation.cubic,
      );

      final iconFile = File(p.join(directory.path, 'ic_launcher.png'));
      final roundIconFile = File(
        p.join(directory.path, 'ic_launcher_round.png'),
      );

      await iconFile.writeAsBytes(encodePng(resizedIcon));
      await roundIconFile.writeAsBytes(encodePng(resizedRoundIcon));

      stdout.writeln('Updated ${iconFile.path}');
      stdout.writeln('Updated ${roundIconFile.path}');
    }
  }

  Future<void> _writeAdaptiveXml(String resPath) async {
    final directory = Directory(p.join(resPath, 'mipmap-anydpi-v26'));
    await directory.create(recursive: true);

    const launcherXml = '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher"/>
</adaptive-icon>
''';

    const roundLauncherXml = '''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_round"/>
</adaptive-icon>
''';

    final iconXml = File(p.join(directory.path, 'ic_launcher.xml'));
    final roundIconXml = File(
      p.join(directory.path, 'ic_launcher_round.xml'),
    );

    await iconXml.writeAsString(launcherXml);
    await roundIconXml.writeAsString(roundLauncherXml);

    stdout.writeln('Updated ${iconXml.path}');
    stdout.writeln('Updated ${roundIconXml.path}');
  }

  Future<void> _writeBackgroundColor(String resPath) async {
    final directory = Directory(p.join(resPath, 'values'));
    await directory.create(recursive: true);

    final file = File(p.join(directory.path, 'ic_launcher_background.xml'));

    final xml =
        '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$backgroundColor</color>
</resources>
''';

    await file.writeAsString(xml);

    stdout.writeln('Updated ${file.path}');
  }

  Future<void> _writePlayStoreIcon({
    required String sourceSet,
    required Image image,
  }) async {
    final resized = copyResize(
      image,
      width: _playStoreIconSize,
      height: _playStoreIconSize,
      interpolation: Interpolation.cubic,
    );

    final destination = File(p.join(sourceSet, 'ic_launcher-playstore.png'));

    await destination.parent.create(recursive: true);
    await destination.writeAsBytes(encodePng(resized));

    stdout.writeln('Updated ${destination.path}');
  }

  Future<void> _removeGeneratedDrawablePngs(String resPath) async {
    final resDirectory = Directory(resPath);

    if (!resDirectory.existsSync()) {
      return;
    }

    await for (final entity in resDirectory.list()) {
      if (entity is! Directory) {
        continue;
      }

      final directoryName = p.basename(entity.path);

      if (!directoryName.startsWith('drawable-')) {
        continue;
      }

      final foreground = File(
        p.join(entity.path, 'ic_launcher_foreground.png'),
      );

      if (foreground.existsSync()) {
        await foreground.delete();
        stdout.writeln('Deleted ${foreground.path}');
      }

      final monochrome = File(
        p.join(entity.path, 'ic_launcher_monochrome.png'),
      );

      if (monochrome.existsSync()) {
        await monochrome.delete();
        stdout.writeln('Deleted ${monochrome.path}');
      }
    }
  }
}
