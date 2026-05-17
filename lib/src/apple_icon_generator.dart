import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:very_good_launcher_icons/src/svg_tools.dart';

class AppleIconGenerator {
  const AppleIconGenerator({
    required this.logoSvgPath,
    required this.appIconsPath,
    required this.brandColor,
  });

  final String logoSvgPath;
  final String appIconsPath;
  final String brandColor;

  Future<void> generate() async {
    final logoFile = File(logoSvgPath);

    if (!logoFile.existsSync()) {
      throw FileSystemException('Logo SVG not found', logoSvgPath);
    }

    final appIconsDirectory = Directory(appIconsPath);

    if (!appIconsDirectory.existsSync()) {
      stdout.writeln('Skipping missing AppIcons directory: $appIconsPath');
      return;
    }

    final sourceSvg = await logoFile.readAsString();
    final themedSvg = SvgTools.applyFillColor(sourceSvg, brandColor);

    final logoFiles = appIconsDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => p.basename(file.path) == 'Logo.svg')
        .toList();

    if (logoFiles.isEmpty) {
      stdout.writeln('No Logo.svg files found under $appIconsPath');
      return;
    }

    for (final file in logoFiles) {
      await file.writeAsString(themedSvg);
      stdout.writeln('Updated ${file.path}');
    }
  }
}
