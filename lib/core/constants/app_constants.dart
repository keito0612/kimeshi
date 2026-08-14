class AppConstants {
  AppConstants._();

  static const String appName = 'Kimeshi';

  // API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8787',
  );

  // 検索設定
  static const int defaultRadius = 1000; // メートル
  static const int minRadius = 100;
  static const int maxRadius = 3000;

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
