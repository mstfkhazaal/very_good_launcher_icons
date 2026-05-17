import 'dart:io';

import 'package:very_good_launcher_icons/src/android_icon_generator.dart';
import 'package:yaml/yaml.dart';
import 'package:very_good_launcher_icons/src/icon_composer.dart';

class VeryGoodLauncherIconsConfig {
  factory VeryGoodLauncherIconsConfig.fromFile(File file) {
    final yaml = loadYaml(file.readAsStringSync());

    if (yaml is! YamlMap) {
      throw const FormatException('Invalid YAML file.');
    }

    final root = yaml['very_good_launcher_icons'];

    if (root is! YamlMap) {
      throw const FormatException(
        'Missing root key: very_good_launcher_icons',
      );
    }

    final android = _map(root, 'android');
    final ios = _map(root, 'ios');
    final iosLaunchImage = _map(root, 'ios_launch_image');
    final macos = _map(root, 'macos');
    final macosLaunchImage = _map(root, 'macos_launch_image');
    final windows = _map(root, 'windows');
    final web = _map(root, 'web');

    final iconPng = _requiredString(root, 'icon_png');
    final backgroundColor = _string(root, 'background_color', '#080A12');

    final source = _map(root, 'source');
    final compose = _map(root, 'compose');

    return VeryGoodLauncherIconsConfig(
      brandColor: _string(root, 'brand_color', '#7C3AED'),
      backgroundColor: backgroundColor,
      logoSvg: _requiredString(root, 'logo_svg'),
      logoPngTransparent: _requiredString(root, 'logo_png_transparent'),
      iconPng: iconPng,
      androidEnabled: _bool(android, 'enabled', true),
      androidBackgroundColor: _string(
        android,
        'background_color',
        backgroundColor,
      ),
      androidFlavorIcons: _androidFlavors(
        android: android,
        fallbackIconPng: iconPng,
      ),
      iconComposer: _iconComposer(
        root: root,
        source: source,
        compose: compose,
      ),
      removeGeneratedDrawablePngs: _bool(
        android,
        'remove_generated_drawable_pngs',
        true,
      ),
      iosEnabled: _bool(ios, 'enabled', true),
      iosAppIconsPath: _string(
        ios,
        'app_icons_path',
        'ios/Runner/AppIcons',
      ),
      iosLaunchImageEnabled: _bool(iosLaunchImage, 'enabled', true),
      iosLaunchImagePath: _string(
        iosLaunchImage,
        'path',
        'ios/Runner/Assets.xcassets/LaunchImage.imageset',
      ),
      macosEnabled: _bool(macos, 'enabled', true),
      macosAppIconsPath: _string(
        macos,
        'app_icons_path',
        'macos/AppIcons',
      ),
      macosLaunchImageEnabled: _bool(macosLaunchImage, 'enabled', true),
      macosLaunchImagePath: _string(
        macosLaunchImage,
        'path',
        'macos/Runner/Assets.xcassets/LaunchImage.imageset',
      ),
      windowsEnabled: _bool(windows, 'enabled', true),
      windowsIconPath: _string(
        windows,
        'icon_path',
        'windows/runner/resources/app_icon.ico',
      ),
      webEnabled: _bool(web, 'enabled', true),
      webBackgroundColor: _string(web, 'background_color', '#FFFFFF'),
      webFaviconPath: _string(web, 'favicon_path', 'web/favicon.png'),
      webIconsPath: _string(web, 'icons_path', 'web/icons'),
    );
  }
  const VeryGoodLauncherIconsConfig({
    required this.brandColor,
    required this.backgroundColor,
    required this.logoSvg,
    required this.logoPngTransparent,
    required this.iconPng,
    required this.androidEnabled,
    required this.androidBackgroundColor,
    required this.androidFlavorIcons,
    required this.removeGeneratedDrawablePngs,
    required this.iosEnabled,
    required this.iosAppIconsPath,
    required this.iosLaunchImageEnabled,
    required this.iconComposer,
    required this.iosLaunchImagePath,
    required this.macosEnabled,
    required this.macosAppIconsPath,
    required this.macosLaunchImageEnabled,
    required this.macosLaunchImagePath,
    required this.windowsEnabled,
    required this.windowsIconPath,
    required this.webEnabled,
    required this.webBackgroundColor,
    required this.webFaviconPath,
    required this.webIconsPath,
  });

  static IconComposerConfig _iconComposer({
    required YamlMap root,
    required YamlMap source,
    required YamlMap compose,
  }) {
    final production = _map(compose, 'production');
    final development = _map(compose, 'development');
    final staging = _map(compose, 'staging');
    final presets = _map(compose, 'presets');

    return IconComposerConfig(
      enabled: _bool(compose, 'enabled', false),
      logoSvgPath: _string(
        source,
        'logo_svg',
        _requiredString(root, 'logo_svg'),
      ),
      outputPath: _string(
        compose,
        'output_path',
        'assets/branding/launcher/generated',
      ),
      backgroundColor: _string(root, 'background_color', '#080A12'),
      logoRenderSize: _int(compose, 'logo_render_size', 2048),
      flavors: [
        _composerFlavor(
          name: 'production',
          suffix: '',
          map: production,
        ),
        _composerFlavor(
          name: 'development',
          suffix: '_dev',
          map: development,
        ),
        _composerFlavor(
          name: 'staging',
          suffix: '_stg',
          map: staging,
        ),
      ],
      normal: _composerPreset(
        _map(presets, 'normal'),
        fallbackShape: IconCanvasShape.roundedSquare,
        fallbackSize: 1024,
        fallbackLogoWidthRatio: 0.62,
        fallbackLogoCenterYRatio: 0.49,
        fallbackCornerRadiusRatio: 0.20,
        fallbackLabelHeightRatio: 0.12,
        fallbackLabelBottomMarginRatio: 0.06,
      ),
      round: _composerPreset(
        _map(presets, 'round'),
        fallbackShape: IconCanvasShape.circle,
        fallbackSize: 1024,
        fallbackLogoWidthRatio: 0.56,
        fallbackLogoCenterYRatio: 0.48,
        fallbackCornerRadiusRatio: 0,
        fallbackLabelHeightRatio: 0.12,
        fallbackLabelBottomMarginRatio: 0.06,
      ),
      playStore: _composerPreset(
        _map(presets, 'playstore'),
        fallbackShape: IconCanvasShape.square,
        fallbackSize: 512,
        fallbackLogoWidthRatio: 0.60,
        fallbackLogoCenterYRatio: 0.47,
        fallbackCornerRadiusRatio: 0,
        fallbackLabelHeightRatio: 0.13,
        fallbackLabelBottomMarginRatio: 0.07,
      ),
      transparent: _composerPreset(
        _map(presets, 'transparent'),
        fallbackShape: IconCanvasShape.transparent,
        fallbackSize: 1024,
        fallbackLogoWidthRatio: 0.66,
        fallbackLogoCenterYRatio: 0.50,
        fallbackCornerRadiusRatio: 0,
        fallbackLabelHeightRatio: 0,
        fallbackLabelBottomMarginRatio: 0,
      ),
    );
  }

  static IconComposerFlavorConfig _composerFlavor({
    required String name,
    required String suffix,
    required YamlMap map,
  }) {
    final label = map['label'];

    return IconComposerFlavorConfig(
      name: name,
      suffix: suffix,
      label: label is String && label.trim().isNotEmpty ? label : null,
      labelColor: _string(map, 'label_color', '#FFFFFF'),
      labelBackgroundColor: _nullableString(map, 'label_background_color'),
    );
  }

  static IconComposerPresetConfig _composerPreset(
    YamlMap map, {
    required IconCanvasShape fallbackShape,
    required int fallbackSize,
    required double fallbackLogoWidthRatio,
    required double fallbackLogoCenterYRatio,
    required double fallbackCornerRadiusRatio,
    required double fallbackLabelHeightRatio,
    required double fallbackLabelBottomMarginRatio,
  }) {
    return IconComposerPresetConfig(
      size: _int(map, 'size', fallbackSize),
      shape: _shape(map, 'shape', fallbackShape),
      logoWidthRatio: _double(
        map,
        'logo_width_ratio',
        fallbackLogoWidthRatio,
      ),
      logoCenterYRatio: _double(
        map,
        'logo_center_y_ratio',
        fallbackLogoCenterYRatio,
      ),
      cornerRadiusRatio: _double(
        map,
        'corner_radius_ratio',
        fallbackCornerRadiusRatio,
      ),
      labelHeightRatio: _double(
        map,
        'label_height_ratio',
        fallbackLabelHeightRatio,
      ),
      labelBottomMarginRatio: _double(
        map,
        'label_bottom_margin_ratio',
        fallbackLabelBottomMarginRatio,
      ),
    );
  }

  static IconCanvasShape _shape(
    YamlMap map,
    String key,
    IconCanvasShape fallback,
  ) {
    final value = map[key];

    if (value is! String) {
      return fallback;
    }

    return switch (value) {
      'transparent' => IconCanvasShape.transparent,
      'square' => IconCanvasShape.square,
      'rounded_square' => IconCanvasShape.roundedSquare,
      'circle' => IconCanvasShape.circle,
      _ => fallback,
    };
  }

  static String? _nullableString(YamlMap map, String key) {
    final value = map[key];

    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    return null;
  }

  static int _int(YamlMap map, String key, int fallback) {
    final value = map[key];

    if (value is int) {
      return value;
    }

    return fallback;
  }

  static double _double(YamlMap map, String key, double fallback) {
    final value = map[key];

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return fallback;
  }

  final String brandColor;
  final String backgroundColor;
  final String logoSvg;
  final String logoPngTransparent;
  final String iconPng;

  final IconComposerConfig iconComposer;
  final bool androidEnabled;
  final String androidBackgroundColor;
  final List<AndroidFlavorIconConfig> androidFlavorIcons;
  final bool removeGeneratedDrawablePngs;

  final bool iosEnabled;
  final String iosAppIconsPath;

  final bool iosLaunchImageEnabled;
  final String iosLaunchImagePath;

  final bool macosEnabled;
  final String macosAppIconsPath;

  final bool macosLaunchImageEnabled;
  final String macosLaunchImagePath;

  final bool windowsEnabled;
  final String windowsIconPath;

  final bool webEnabled;
  final String webBackgroundColor;
  final String webFaviconPath;
  final String webIconsPath;

  static YamlMap _map(YamlMap map, String key) {
    final value = map[key];

    if (value is YamlMap) {
      return value;
    }

    return YamlMap();
  }

  static String _requiredString(YamlMap map, String key) {
    final value = map[key];

    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    throw FormatException('Missing required config value: $key');
  }

  static String _string(YamlMap map, String key, String fallback) {
    final value = map[key];

    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    return fallback;
  }

  static bool _bool(YamlMap map, String key, bool fallback) {
    final value = map[key];

    if (value is bool) {
      return value;
    }

    return fallback;
  }

  static List<AndroidFlavorIconConfig> _androidFlavors({
    required YamlMap android,
    required String fallbackIconPng,
  }) {
    final flavors = android['flavors'];

    if (flavors is YamlMap && flavors.isNotEmpty) {
      return flavors.entries
          .map((entry) {
            final name = entry.key;

            if (name is! String || name.trim().isEmpty) {
              throw const FormatException(
                'Android flavor name must be a string.',
              );
            }

            final value = entry.value;

            if (value is! YamlMap) {
              throw FormatException(
                'Android flavor "$name" must be a YAML map.',
              );
            }

            final iconPng = _string(value, 'icon_png', fallbackIconPng);
            final roundIconPng = _string(value, 'round_icon_png', iconPng);
            final playStoreIconPng = _string(
              value,
              'playstore_icon_png',
              iconPng,
            );

            return AndroidFlavorIconConfig(
              name: name,
              iconPngPath: iconPng,
              roundIconPngPath: roundIconPng,
              playStoreIconPngPath: playStoreIconPng,
            );
          })
          .toList(growable: false);
    }

    return [
      AndroidFlavorIconConfig(
        name: 'main',
        iconPngPath: fallbackIconPng,
        roundIconPngPath: fallbackIconPng,
        playStoreIconPngPath: fallbackIconPng,
      ),
    ];
  }
}
