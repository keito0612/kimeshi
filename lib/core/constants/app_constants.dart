import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Kimeshi';

  // API
  // デバッグビルド → ローカル、リリースビルド → 本番
  static const String apiBaseUrl = kDebugMode
      ? 'http://localhost:8787'
      : 'https://kimeshi-api.keito3079.workers.dev';

  // AdMob App ID
  // TODO: 本番リリース時に実際のApp IDに置き換えてください
  static const String admobAppIdIos = kDebugMode
      ? 'ca-app-pub-3940256099942544~1458002511' // テスト用
      : 'ca-app-pub-8369847853540237~5151980209'; // 本番用に置き換え

  static const String admobAppIdAndroid = kDebugMode
      ? 'ca-app-pub-3940256099942544~3347511713' // テスト用
      : 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX'; // 本番用に置き換え

  // AdMob Banner Unit ID
  // TODO: 本番リリース時に実際のUnit IDに置き換えてください
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/2435281174' // iOSテスト用
          : 'ca-app-pub-8369847853540237/9095094648'; // 本番用に置き換え
    } else {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111' // Androidテスト用
          : 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX'; // 本番用に置き換え
    }
  }

  // 検索設定
  static const int defaultRadius = 1000; // メートル
  static const int minRadius = 100;
  static const int maxRadius = 3000;

  // 検索上限数設定
  static const int defaultSearchLimit = 20;
  static const int minSearchLimit = 5;
  static const int maxSearchLimit = 50;

  // 予算オプション
  static const List<BudgetOption> budgetOptions = [
    BudgetOption(label: '~1000円', value: '1000'),
    BudgetOption(label: '~2000円', value: '2000'),
    BudgetOption(label: '~3000円', value: '3000'),
    BudgetOption(label: '指定なし', value: 'unlimited'),
  ];

  // ジャンルオプション
  static const List<GenreOption> genreOptions = [
    GenreOption(label: '指定なし', value: 'all'),
    GenreOption(label: '居酒屋', value: 'izakaya'),
    GenreOption(label: '和食', value: 'japanese'),
    GenreOption(label: '洋食', value: 'western'),
    GenreOption(label: '中華', value: 'chinese'),
    GenreOption(label: 'イタリアン・フレンチ', value: 'italian_french'),
    GenreOption(label: '韓国料理', value: 'korean'),
    GenreOption(label: 'アジア・エスニック', value: 'asian_ethnic'),
    GenreOption(label: '焼肉', value: 'yakiniku'),
    GenreOption(label: 'ラーメン', value: 'ramen'),
    GenreOption(label: 'カフェ・スイーツ', value: 'cafe'),
    GenreOption(label: 'バー・カクテル', value: 'bar'),
    GenreOption(label: 'お好み焼き・もんじゃ', value: 'okonomiyaki'),
  ];
}

class BudgetOption {
  final String label;
  final String value;

  const BudgetOption({required this.label, required this.value});
}

class GenreOption {
  final String label;
  final String value;

  const GenreOption({required this.label, required this.value});
}
