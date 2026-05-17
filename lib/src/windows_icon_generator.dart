import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class WindowsIconGenerator {
  const WindowsIconGenerator({
    required this.logoPngTransparentPath,
    required this.outputPath,
  });

  final String logoPngTransparentPath;
  final String outputPath;

  Future<void> generate() async {
    final source = File(logoPngTransparentPath);

    if (!source.existsSync()) {
      throw FileSystemException('Transparent logo PNG not found', source.path);
    }

    final image = decodePng(source.readAsBytesSync());

    if (image == null) {
      throw FormatException('Invalid PNG file: ${source.path}');
    }

    final icon = copyResize(
      image,
      width: 256,
      height: 256,
      interpolation: Interpolation.cubic,
    );

    final output = File(outputPath);
    await output.parent.create(recursive: true);
    await output.writeAsBytes(encodeIco(icon));

    stdout.writeln('Updated ${p.normalize(output.path)}');
  }
}
