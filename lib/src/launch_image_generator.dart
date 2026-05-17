import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class LaunchImageGenerator {
  const LaunchImageGenerator({
    required this.logoPngTransparentPath,
    required this.launchImageSetPath,
  });

  final String logoPngTransparentPath;
  final String launchImageSetPath;

  Future<void> generate() async {
    final source = File(logoPngTransparentPath);

    if (!source.existsSync()) {
      throw FileSystemException(
        'Transparent logo PNG not found',
        source.path,
      );
    }

    final logo = decodePng(source.readAsBytesSync());

    if (logo == null) {
      throw FormatException('Invalid PNG file: ${source.path}');
    }

    final directory = Directory(launchImageSetPath);
    await directory.create(recursive: true);

    await _writeLaunchImage(
      logo: logo,
      size: 150,
      fileName: 'LaunchImage@1x.png',
    );

    await _writeLaunchImage(
      logo: logo,
      size: 300,
      fileName: 'LaunchImage@2x.png',
    );

    await _writeLaunchImage(
      logo: logo,
      size: 600,
      fileName: 'LaunchImage@3x.png',
    );

    await _writeContentsJson();

    stdout.writeln('Updated ${p.normalize(launchImageSetPath)}');
  }

  Future<void> _writeLaunchImage({
    required Image logo,
    required int size,
    required String fileName,
  }) async {
    final image = copyResize(
      logo,
      width: size,
      height: size,
      interpolation: Interpolation.cubic,
    );

    final output = File(p.join(launchImageSetPath, fileName));
    await output.parent.create(recursive: true);
    await output.writeAsBytes(encodePng(image));
  }

  Future<void> _writeContentsJson() async {
    final json = <String, Object>{
      'images': [
        {
          'filename': 'LaunchImage@1x.png',
          'idiom': 'universal',
          'scale': '1x',
        },
        {
          'filename': 'LaunchImage@2x.png',
          'idiom': 'universal',
          'scale': '2x',
        },
        {
          'filename': 'LaunchImage@3x.png',
          'idiom': 'universal',
          'scale': '3x',
        },
      ],
      'info': {
        'author': 'xcode',
        'version': 1,
      },
    };

    const encoder = JsonEncoder.withIndent('  ');
    final output = File(p.join(launchImageSetPath, 'Contents.json'));
    await output.writeAsString('${encoder.convert(json)}\n');
  }
}
