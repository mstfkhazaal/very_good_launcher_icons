# Very Good Launcher Icons

A Dart CLI for generating launcher icons and launch images for Flutter projects created with **Very Good CLI**.

This package is designed for projects that use Very Good CLI flavors and platform-specific icon structures.

It can generate and update icons for:

- Android
- iOS
- macOS
- Windows
- Web

It also supports optional icon composition from a single SVG logo using `resvg`.

---

## Why this package exists

Flutter projects created with Very Good CLI often have a structure like this:

```text
android/app/src/main/
android/app/src/development/
android/app/src/staging/

ios/Runner/AppIcons/AppIcon.icon/
ios/Runner/AppIcons/AppIcon-dev.icon/
ios/Runner/AppIcons/AppIcon-stg.icon/

macos/AppIcons/AppIcon.icon/
macos/AppIcons/AppIcon-dev.icon/
macos/AppIcons/AppIcon-stg.icon/
```

Generic launcher icon tools usually target the default Flutter structure. They may create extra files such as:

```text
launcher_icon.png
AppIcon.appiconset
drawable-* launcher PNGs
```

This package avoids that and works directly with the Very Good CLI structure.

---

## Features

- Generate Android launcher icons for multiple flavors.
- Support separate Android icons for:
    - normal launcher icon
    - round launcher icon
    - Play Store icon
- Update Android `mipmap-*` icons.
- Update Android adaptive icon XML files.
- Update Android `ic_launcher_background.xml`.
- Update iOS Very Good CLI `.icon` folders.
- Generate iOS `LaunchImage.imageset`.
- Update macOS Very Good CLI `.icon` folders.
- Generate macOS `LaunchImage.imageset`.
- Generate Windows `.ico`.
- Generate Web favicon and PWA icons.
- Optionally compose all icon source PNGs from one SVG logo.

---

## Installation

Add the package to your Flutter project `dev_dependencies`.

### From pub.dev

```yaml
dev_dependencies:
  very_good_launcher_icons: ^0.1.0
```

### From Git

```yaml
dev_dependencies:
  very_good_launcher_icons:
    git:
      url: https://github.com/mstfkhazaal/very_good_launcher_icons.git
      ref: main
```

### From local path

```yaml
dev_dependencies:
  very_good_launcher_icons:
    path: packages/very_good_launcher_icons
```

Then run:

```sh
flutter pub get
```

---

## Basic usage

Create this file in the root of your Flutter project:

```text
very_good_launcher_icons.yaml
```

Then run:

```sh
dart run very_good_launcher_icons
```

You can also pass a custom config path:

```sh
dart run very_good_launcher_icons path/to/very_good_launcher_icons.yaml
```

---

## Recommended asset structure

A simple recommended structure:

```text
assets/branding/launcher/
├── development/
│   ├── wareed_launcher_icon_dev.png
│   ├── wareed_launcher_playstore_dev.png
│   └── wareed_launcher_round_icon_dev.png
├── production/
│   ├── wareed_launcher_icon.png
│   ├── wareed_launcher_playstore.png
│   └── wareed_launcher_round_icon.png
├── staging/
│   ├── wareed_launcher_icon_stg.png
│   ├── wareed_launcher_playstore_stg.png
│   └── wareed_launcher_round_icon_stg.png
├── wareed_logo.svg
└── wareed_logo_transparent.png
```

Recommended sizes:

| File | Size | Shape |
|---|---:|---|
| `wareed_launcher_icon.png` | 1024x1024 | rounded-square app icon |
| `wareed_launcher_round_icon.png` | 1024x1024 | circle-safe icon |
| `wareed_launcher_playstore.png` | 512x512 | square Play Store icon |
| `wareed_logo.svg` | 500x500 viewBox | transparent vector logo |
| `wareed_logo_transparent.png` | 1024x1024 | transparent logo only |

Important:

```text
ic_launcher.png           = normal launcher icon
ic_launcher_round.png     = circle-safe launcher icon
ic_launcher-playstore.png = 512x512 square Play Store icon
```

Do not use a rounded-corner image for the Play Store icon.

---

## Full configuration example

```yaml
very_good_launcher_icons:
  brand_color: "#7C3AED"
  background_color: "#080A12"

  logo_svg: "assets/branding/launcher/wareed_logo.svg"
  logo_png_transparent: "assets/branding/launcher/wareed_logo_transparent.png"
  icon_png: "assets/branding/launcher/production/wareed_launcher_icon.png"

  android:
    enabled: true
    background_color: "#080A12"
    remove_generated_drawable_pngs: true
    flavors:
      main:
        icon_png: "assets/branding/launcher/production/wareed_launcher_icon.png"
        round_icon_png: "assets/branding/launcher/production/wareed_launcher_round_icon.png"
        playstore_icon_png: "assets/branding/launcher/production/wareed_launcher_playstore.png"

      development:
        icon_png: "assets/branding/launcher/development/wareed_launcher_icon_dev.png"
        round_icon_png: "assets/branding/launcher/development/wareed_launcher_round_icon_dev.png"
        playstore_icon_png: "assets/branding/launcher/development/wareed_launcher_playstore_dev.png"

      staging:
        icon_png: "assets/branding/launcher/staging/wareed_launcher_icon_stg.png"
        round_icon_png: "assets/branding/launcher/staging/wareed_launcher_round_icon_stg.png"
        playstore_icon_png: "assets/branding/launcher/staging/wareed_launcher_playstore_stg.png"

  ios:
    enabled: true
    app_icons_path: "ios/Runner/AppIcons"

  ios_launch_image:
    enabled: true
    path: "ios/Runner/Assets.xcassets/LaunchImage.imageset"

  macos:
    enabled: true
    app_icons_path: "macos/AppIcons"

  macos_launch_image:
    enabled: true
    path: "macos/Runner/Assets.xcassets/LaunchImage.imageset"

  windows:
    enabled: true
    icon_path: "windows/runner/resources/app_icon.ico"

  web:
    enabled: true
    background_color: "#FFFFFF"
    favicon_path: "web/favicon.png"
    icons_path: "web/icons"
```

Run:

```sh
dart run very_good_launcher_icons
```

---

## Android output

For each Android flavor, this package updates:

```text
android/app/src/<flavor>/ic_launcher-playstore.png

android/app/src/<flavor>/res/mipmap-mdpi/ic_launcher.png
android/app/src/<flavor>/res/mipmap-mdpi/ic_launcher_round.png

android/app/src/<flavor>/res/mipmap-hdpi/ic_launcher.png
android/app/src/<flavor>/res/mipmap-hdpi/ic_launcher_round.png

android/app/src/<flavor>/res/mipmap-xhdpi/ic_launcher.png
android/app/src/<flavor>/res/mipmap-xhdpi/ic_launcher_round.png

android/app/src/<flavor>/res/mipmap-xxhdpi/ic_launcher.png
android/app/src/<flavor>/res/mipmap-xxhdpi/ic_launcher_round.png

android/app/src/<flavor>/res/mipmap-xxxhdpi/ic_launcher.png
android/app/src/<flavor>/res/mipmap-xxxhdpi/ic_launcher_round.png

android/app/src/<flavor>/res/mipmap-anydpi-v26/ic_launcher.xml
android/app/src/<flavor>/res/mipmap-anydpi-v26/ic_launcher_round.xml

android/app/src/<flavor>/res/values/ic_launcher_background.xml
```

Example flavors:

```text
main
development
staging
```

In Very Good CLI projects, `main` usually represents production.

---

## iOS output

This package updates the Very Good CLI `.icon` folders:

```text
ios/Runner/AppIcons/AppIcon.icon/Assets/Logo.svg
ios/Runner/AppIcons/AppIcon-dev.icon/Assets/Logo.svg
ios/Runner/AppIcons/AppIcon-stg.icon/Assets/Logo.svg
```

It also generates launch images:

```text
ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json
ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@1x.png
ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png
```

Generated sizes:

```text
LaunchImage@1x.png = 150x150
LaunchImage@2x.png = 300x300
LaunchImage@3x.png = 600x600
```

---

## macOS output

This package updates:

```text
macos/AppIcons/AppIcon.icon/Assets/Logo.svg
macos/AppIcons/AppIcon-dev.icon/Assets/Logo.svg
macos/AppIcons/AppIcon-stg.icon/Assets/Logo.svg
```

It also generates:

```text
macos/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json
macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@1x.png
macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png
```

---

## Windows output

This package generates:

```text
windows/runner/resources/app_icon.ico
```

The source should be a transparent PNG logo:

```yaml
logo_png_transparent: "assets/branding/launcher/wareed_logo_transparent.png"
```

---

## Web output

This package generates:

```text
web/favicon.png
web/icons/favicon.png
web/icons/Icon-192.png
web/icons/Icon-512.png
```

The Web icon uses:

```yaml
web:
  background_color: "#FFFFFF"
```

This is useful when you want a normal logo on a white background for browser icons.

---

## Optional: generate source PNGs from SVG

You can let the package create the production, development, and staging PNG assets from one SVG logo.

This requires `resvg`.

### Install resvg on macOS

```sh
brew install resvg
```

Check installation:

```sh
resvg --version
```

### SVG requirements

Recommended SVG:

```xml
<svg
  width="500"
  height="500"
  viewBox="0 0 500 500"
  fill="none"
  xmlns="http://www.w3.org/2000/svg"
>
  ...
</svg>
```

The SVG should contain the logo only. Do not include background color in the SVG.

### Composer configuration

```yaml
very_good_launcher_icons:
  brand_color: "#7C3AED"
  background_color: "#080A12"

  source:
    logo_svg: "assets/branding/launcher/wareed_logo.svg"

  logo_svg: "assets/branding/launcher/wareed_logo.svg"
  logo_png_transparent: "assets/branding/launcher/generated/wareed_logo_transparent.png"
  icon_png: "assets/branding/launcher/generated/production/wareed_launcher_icon.png"

  compose:
    enabled: true
    output_path: "assets/branding/launcher/generated"
    logo_render_size: 2048

    production:
      label: null
      label_color: "#FFFFFF"
      label_background_color: null

    development:
      label: "DEV"
      label_color: "#FFFFFF"
      label_background_color: "#22B8F0"

    staging:
      label: "STG"
      label_color: "#FFFFFF"
      label_background_color: "#F59E0B"

    presets:
      normal:
        size: 1024
        shape: rounded_square
        corner_radius_ratio: 0.20
        logo_width_ratio: 0.62
        logo_center_y_ratio: 0.49

      round:
        size: 1024
        shape: circle
        logo_width_ratio: 0.56
        logo_center_y_ratio: 0.48

      playstore:
        size: 512
        shape: square
        logo_width_ratio: 0.60
        logo_center_y_ratio: 0.47
        label_height_ratio: 0.13
        label_bottom_margin_ratio: 0.07

      transparent:
        size: 1024
        shape: transparent
        logo_width_ratio: 0.66
        logo_center_y_ratio: 0.50
```

This generates:

```text
assets/branding/launcher/generated/production/wareed_launcher_icon.png
assets/branding/launcher/generated/production/wareed_launcher_round_icon.png
assets/branding/launcher/generated/production/wareed_launcher_playstore.png

assets/branding/launcher/generated/development/wareed_launcher_icon_dev.png
assets/branding/launcher/generated/development/wareed_launcher_round_icon_dev.png
assets/branding/launcher/generated/development/wareed_launcher_playstore_dev.png

assets/branding/launcher/generated/staging/wareed_launcher_icon_stg.png
assets/branding/launcher/generated/staging/wareed_launcher_round_icon_stg.png
assets/branding/launcher/generated/staging/wareed_launcher_playstore_stg.png

assets/branding/launcher/generated/wareed_logo_transparent.png
```

Then point Android to the generated files:

```yaml
android:
  enabled: true
  background_color: "#080A12"
  remove_generated_drawable_pngs: true
  flavors:
    main:
      icon_png: "assets/branding/launcher/generated/production/wareed_launcher_icon.png"
      round_icon_png: "assets/branding/launcher/generated/production/wareed_launcher_round_icon.png"
      playstore_icon_png: "assets/branding/launcher/generated/production/wareed_launcher_playstore.png"

    development:
      icon_png: "assets/branding/launcher/generated/development/wareed_launcher_icon_dev.png"
      round_icon_png: "assets/branding/launcher/generated/development/wareed_launcher_round_icon_dev.png"
      playstore_icon_png: "assets/branding/launcher/generated/development/wareed_launcher_playstore_dev.png"

    staging:
      icon_png: "assets/branding/launcher/generated/staging/wareed_launcher_icon_stg.png"
      round_icon_png: "assets/branding/launcher/generated/staging/wareed_launcher_round_icon_stg.png"
      playstore_icon_png: "assets/branding/launcher/generated/staging/wareed_launcher_playstore_stg.png"
```

---

## Icon composition presets

Supported shapes:

```yaml
shape: transparent
shape: square
shape: rounded_square
shape: circle
```

Useful preset values:

```yaml
normal:
  size: 1024
  shape: rounded_square
  corner_radius_ratio: 0.20
  logo_width_ratio: 0.62
  logo_center_y_ratio: 0.49

round:
  size: 1024
  shape: circle
  logo_width_ratio: 0.56
  logo_center_y_ratio: 0.48

playstore:
  size: 512
  shape: square
  logo_width_ratio: 0.60
  logo_center_y_ratio: 0.47

transparent:
  size: 1024
  shape: transparent
  logo_width_ratio: 0.66
  logo_center_y_ratio: 0.50
```

For development and staging flags:

```yaml
development:
  label: "DEV"
  label_color: "#FFFFFF"
  label_background_color: "#22B8F0"

staging:
  label: "STG"
  label_color: "#FFFFFF"
  label_background_color: "#F59E0B"
```

---

## Disable a platform

You can disable any platform:

```yaml
android:
  enabled: false

ios:
  enabled: false

ios_launch_image:
  enabled: false

macos:
  enabled: false

macos_launch_image:
  enabled: false

windows:
  enabled: false

web:
  enabled: false
```

---

## Manual assets vs generated assets

If you already created your PNG files manually in Photoshop, use:

```yaml
compose:
  enabled: false
```

Then point Android to your manual files:

```yaml
android:
  flavors:
    main:
      icon_png: "assets/branding/launcher/production/wareed_launcher_icon.png"
      round_icon_png: "assets/branding/launcher/production/wareed_launcher_round_icon.png"
      playstore_icon_png: "assets/branding/launcher/production/wareed_launcher_playstore.png"
```

If you want the package to generate the PNG files from SVG, use:

```yaml
compose:
  enabled: true
```

and point Android/Web/Windows/iOS/macOS launch images to the generated files.

---

## Verification

After running:

```sh
dart run very_good_launcher_icons
```

Verify the generated files.

### Android

```sh
file android/app/src/main/ic_launcher-playstore.png
file android/app/src/development/ic_launcher-playstore.png
file android/app/src/staging/ic_launcher-playstore.png

file android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
file android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png
```

Expected Play Store output:

```text
512 x 512 PNG
```

### iOS

```sh
file ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@1x.png
file ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
file ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png
```

### macOS

```sh
file macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@1x.png
file macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png
file macos/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png
```

### Web

```sh
file web/favicon.png
file web/icons/favicon.png
file web/icons/Icon-192.png
file web/icons/Icon-512.png
```

### Windows

```sh
file windows/runner/resources/app_icon.ico
```

---

## Common problems

### Config file not found

If you see:

```text
Config file not found: very_good_launcher_icons.yaml
```

Run the command from your Flutter project root:

```sh
dart run very_good_launcher_icons
```

Or pass the config path:

```sh
dart run very_good_launcher_icons ../../very_good_launcher_icons.yaml
```

### resvg not found

If you use `compose.enabled: true`, install `resvg`:

```sh
brew install resvg
```

If you do not want SVG composition, disable it:

```yaml
compose:
  enabled: false
```

### Play Store icon is rounded

Use a square Play Store source image:

```yaml
playstore_icon_png: "assets/branding/launcher/production/wareed_launcher_playstore.png"
```

Do not point `playstore_icon_png` to the rounded launcher icon.

### Round icon is not circular

Use a separate round icon source:

```yaml
round_icon_png: "assets/branding/launcher/production/wareed_launcher_round_icon.png"
```

Do not point `round_icon_png` to the normal launcher icon unless you intentionally want both to look the same.

---

## Suggested workflow

```sh
flutter pub get
dart run very_good_launcher_icons
flutter clean
flutter pub get
```

Then run your app normally:

```sh
flutter run --flavor development
flutter run --flavor staging
flutter run --flavor production
```

---

## License

MIT