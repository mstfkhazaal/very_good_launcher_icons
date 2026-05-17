import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class WebIconGenerator {
  const WebIconGenerator({
    required this.logoPngTransparentPath,
    required this.faviconPath,
    required this.iconsPath,
    required this.backgroundColor,
  });

  final String logoPngTransparentPath;
  final String faviconPath;
  final String iconsPath;
  final String backgroundColor;

  Future<void> generate() async {
    final source = File(logoPngTransparentPath);

    if (!source.existsSync()) {
      throw FileSystemException('Transparent logo PNG not found', source.path);
    }

    final logo = decodePng(source.readAsBytesSync());

    if (logo == null) {
      throw FormatException('Invalid PNG file: ${source.path}');
    }

    await _writeWebIcon(
      logo: logo,
      size: 16,
      outputPath: faviconPath,
    );

    await _writeWebIcon(
      logo: logo,
      size: 16,
      outputPath: p.join(iconsPath, 'favicon.png'),
    );

    await _writeWebIcon(
      logo: logo,
      size: 192,
      outputPath: p.join(iconsPath, 'Icon-192.png'),
    );

    await _writeWebIcon(
      logo: logo,
      size: 512,
      outputPath: p.join(iconsPath, 'Icon-512.png'),
    );
  }

  Future<void> _writeWebIcon({
    required Image logo,
    required int size,
    required String outputPath,
  }) async {
    final canvas = Image(
      width: size,
      height: size,
      numChannels: 4,
    );

    fill(canvas, color: _hexToColor(backgroundColor));

    final logoSize = (size * 0.72).round();
    final resizedLogo = copyResize(
      logo,
      width: logoSize,
      height: logoSize,
      interpolation: Interpolation.cubic,
    );

    compositeImage(
      canvas,
      resizedLogo,
      dstX: ((size - resizedLogo.width) / 2).round(),
      dstY: ((size - resizedLogo.height) / 2).round(),
    );

    final output = File(outputPath);
    await output.parent.create(recursive: true);
    await output.writeAsBytes(encodePng(canvas));

    stdout.writeln('Updated ${p.normalize(output.path)}');
  }

  Color _hexToColor(String hex) {
    final normalized = hex.replaceAll('#', '');
    final value = int.parse(normalized, radix: 16);

    if (normalized.length != 6) {
      throw FormatException('Invalid hex color: $hex');
    }

    return ColorUint8.rgb(
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    );
  }
}
