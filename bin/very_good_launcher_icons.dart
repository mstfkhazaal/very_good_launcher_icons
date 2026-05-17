import 'dart:io';

import 'package:very_good_launcher_icons/src/android_icon_generator.dart';
import 'package:very_good_launcher_icons/src/apple_icon_generator.dart';
import 'package:very_good_launcher_icons/src/config.dart';
import 'package:very_good_launcher_icons/src/icon_composer.dart';
import 'package:very_good_launcher_icons/src/ios_launch_image_generator.dart';
import 'package:very_good_launcher_icons/src/macos_launch_image_generator.dart';
import 'package:very_good_launcher_icons/src/web_icon_generator.dart';
import 'package:very_good_launcher_icons/src/windows_icon_generator.dart';

Future<void> main(List<String> args) async {
  final configPath = args.isNotEmpty
      ? args.first
      : 'very_good_launcher_icons.yaml';

  final configFile = File(configPath);

  if (!configFile.existsSync()) {
    stderr.writeln('Config file not found: $configPath');
    exitCode = 1;
    return;
  }

  try {
    final config = VeryGoodLauncherIconsConfig.fromFile(configFile);

    if (config.iconComposer.enabled) {
      await IconComposer(config: config.iconComposer).generate();
      stdout.writeln('Composed launcher icon source assets.');
    }

    if (config.iosEnabled) {
      await AppleIconGenerator(
        logoSvgPath: config.logoSvg,
        appIconsPath: config.iosAppIconsPath,
        brandColor: config.brandColor,
      ).generate();

      stdout.writeln('Updated iOS Very Good AppIcons.');
    }

    if (config.iosLaunchImageEnabled) {
      await IosLaunchImageGenerator(
        logoPngTransparentPath: config.logoPngTransparent,
        launchImageSetPath: config.iosLaunchImagePath,
      ).generate();

      stdout.writeln('Updated iOS LaunchImage.imageset.');
    }

    if (config.macosEnabled) {
      await AppleIconGenerator(
        logoSvgPath: config.logoSvg,
        appIconsPath: config.macosAppIconsPath,
        brandColor: config.brandColor,
      ).generate();

      stdout.writeln('Updated macOS Very Good AppIcons.');
    }

    if (config.macosLaunchImageEnabled) {
      await MacosLaunchImageGenerator(
        logoPngTransparentPath: config.logoPngTransparent,
        launchImageSetPath: config.macosLaunchImagePath,
      ).generate();

      stdout.writeln('Updated macOS LaunchImage.imageset.');
    }

    if (config.androidEnabled) {
      await AndroidIconGenerator(
        backgroundColor: config.androidBackgroundColor,
        flavors: config.androidFlavorIcons,
        removeGeneratedDrawablePngs: config.removeGeneratedDrawablePngs,
      ).generate();

      stdout.writeln('Updated Android Very Good flavor icons.');
    }

    if (config.windowsEnabled) {
      await WindowsIconGenerator(
        logoPngTransparentPath: config.logoPngTransparent,
        outputPath: config.windowsIconPath,
      ).generate();

      stdout.writeln('Updated Windows icon.');
    }

    if (config.webEnabled) {
      await WebIconGenerator(
        logoPngTransparentPath: config.logoPngTransparent,
        faviconPath: config.webFaviconPath,
        iconsPath: config.webIconsPath,
        backgroundColor: config.webBackgroundColor,
      ).generate();

      stdout.writeln('Updated Web icons.');
    }

    stdout.writeln('Very Good launcher icons generated successfully.');
  } on Object catch (error, stackTrace) {
    stderr.writeln(error);
    stderr.writeln(stackTrace);
    exitCode = 1;
  }
}
