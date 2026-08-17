import 'package:flutter/material.dart';

/// iPhoneの画面サイズに応じたレスポンシブ対応ユーティリティ
class Responsive {
  final BuildContext context;

  Responsive(this.context);

  /// 画面の幅
  double get screenWidth => MediaQuery.of(context).size.width;

  /// 画面の高さ
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Safe Area の padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(context).padding;

  /// テキストスケールファクター（アクセシビリティ対応）
  double get textScaleFactor =>
      MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3);

  /// 小さい画面かどうか (iPhone SE, iPhone mini)
  bool get isSmallScreen => screenWidth < 375;

  /// 標準画面かどうか (iPhone 標準)
  bool get isMediumScreen => screenWidth >= 375 && screenWidth < 414;

  /// 大きい画面かどうか (iPhone Plus, Pro Max)
  bool get isLargeScreen => screenWidth >= 414;

  /// 縦長の画面かどうか (ノッチ付きiPhone)
  bool get isTallScreen => screenHeight / screenWidth > 2.0;

  /// 画面幅に基づいたパディング
  double get horizontalPadding {
    if (isSmallScreen) return 12;
    if (isMediumScreen) return 16;
    return 20;
  }

  /// 画面幅に基づいたフォントサイズのスケール
  double get fontScale {
    if (isSmallScreen) return 0.9;
    if (isLargeScreen) return 1.05;
    return 1.0;
  }

  /// スケール済みフォントサイズ
  double scaledFontSize(double baseSize) {
    return baseSize * fontScale;
  }

  /// スケール済みの値
  double scaled(double baseValue) {
    final scale = screenWidth / 375; // iPhone 8 を基準
    return baseValue * scale.clamp(0.85, 1.15);
  }

  /// カードの高さ（画面比率ベース）
  double get cardHeight {
    // 縦長画面では大きめ、短い画面では小さめ
    if (isTallScreen) {
      return screenHeight * 0.55;
    }
    return screenHeight * 0.50;
  }

  /// ボタンの高さ
  double get buttonHeight {
    if (isSmallScreen) return 48;
    return 56;
  }

  /// アイコンサイズ
  double get iconSize {
    if (isSmallScreen) return 20;
    if (isLargeScreen) return 26;
    return 24;
  }
}

/// BuildContext の拡張
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}
