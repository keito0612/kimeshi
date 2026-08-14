# Kimeshi - モバイルアプリ仕様書

## 1. プロジェクト概要

### 1.1 コンセプト
「今ここで何食べる？」を3秒で解決するモバイルアプリ

### 1.2 ターゲットユーザー
- 食事場所を決めるのが苦手な人
- 時間がなくてすぐに決めたい人
- 新しい店を開拓したい人

### 1.3 コアバリュー
- **即決**: 1店舗だけ提案、選択肢を絞る
- **シンプル**: 最小限の入力で結果を得る
- **パーソナライズ**: 履歴から学習し精度向上

---

## 2. 技術スタック

| カテゴリ | 技術 |
|---------|------|
| フレームワーク | Flutter |
| 状態管理（Local） | flutter_hooks |
| 状態管理（Global） | Riverpod |
| HTTP通信 | dio |
| 位置情報 | geolocator |
| 住所取得 | geocoding |
| ローカル保存 | shared_preferences |
| コード生成 | freezed, build_runner |
| URL起動 | url_launcher |
| テスト | mocktail |

---

## 3. アーキテクチャ

### 3.1 MVVM + Repository + Service

```
┌─────────────────────────────────────────────────┐
│                    View                         │
│            Widget + flutter_hooks               │
│            （UIの描画・ユーザー入力）             │
└─────────────────────┬───────────────────────────┘
                      │ 監視・操作
┌─────────────────────▼───────────────────────────┐
│                 ViewModel                       │
│              Riverpod Provider                  │
│        （UI状態管理・エラーハンドリング）          │
└─────────────────────┬───────────────────────────┘
                      │ 呼び出し
┌─────────────────────▼───────────────────────────┐
│                  Service                        │
│      （ビジネスロジック・Repository連携）         │
└─────────────────────┬───────────────────────────┘
                      │ データ取得
┌─────────────────────▼───────────────────────────┐
│                Repository                       │
│          （API通信・ローカルストレージ）           │
└─────────────────────────────────────────────────┘
```

### 3.2 各層の責務

| 層 | 責務 | 実装 |
|----|------|------|
| **View** | UIの描画・ユーザー入力受付 | Widget + flutter_hooks |
| **ViewModel** | UI状態保持・ロジック呼び出し | Riverpod StateNotifier |
| **Service** | ビジネスロジック・複数Repository連携 | 純粋なDartクラス |
| **Repository** | データ取得の抽象化 | Interface + 実装クラス |
| **Model** | データ構造 | Freezedで生成 |

---

## 4. ディレクトリ構成

```
lib/
├── core/
│   ├── api/
│   │   └── api_client.dart         # Dio HTTPクライアント
│   ├── constants/
│   │   └── app_constants.dart      # 定数（API URL、オプション等）
│   ├── exceptions/
│   │   └── app_exception.dart      # カスタム例外クラス
│   └── utils/
│       └── (ユーティリティ関数)
│
├── models/
│   ├── restaurant.dart             # 店舗モデル (Freezed)
│   ├── restaurant.freezed.dart     # 自動生成
│   ├── restaurant.g.dart           # 自動生成
│   ├── search_params.dart          # 検索パラメータ (Freezed)
│   ├── search_params.freezed.dart  # 自動生成
│   ├── search_params.g.dart        # 自動生成
│   ├── location.dart               # 位置情報モデル (Freezed)
│   ├── location.freezed.dart       # 自動生成
│   └── location.g.dart             # 自動生成
│
├── repositories/
│   ├── i_location_repository.dart      # 位置情報リポジトリ Interface
│   ├── location_repository.dart        # 位置情報リポジトリ 実装
│   ├── i_restaurant_repository.dart    # 店舗リポジトリ Interface
│   └── restaurant_repository.dart      # 店舗リポジトリ 実装
│
├── services/
│   ├── i_restaurant_search_service.dart  # 検索サービス Interface
│   └── restaurant_search_service.dart    # 検索サービス 実装
│
├── viewmodels/
│   ├── providers.dart              # Provider定義（DI設定）
│   └── search_viewmodel.dart       # 検索画面のViewModel
│
├── views/
│   ├── screens/
│   │   ├── home_screen.dart        # ホーム画面（条件入力）
│   │   └── result_screen.dart      # 結果画面（店舗表示）
│   └── widgets/
│       ├── budget_selector.dart    # 予算選択Widget
│       ├── genre_selector.dart     # ジャンル選択Widget
│       ├── radius_slider.dart      # 距離選択スライダー
│       └── restaurant_card.dart    # 店舗カード
│
└── main.dart                       # エントリーポイント

test/
├── mocks/
│   ├── mock_restaurant_repository.dart
│   └── mock_location_repository.dart
├── repositories/
│   └── restaurant_repository_test.dart
├── services/
│   └── restaurant_search_service_test.dart
├── viewmodels/
│   └── search_viewmodel_test.dart
└── views/
    └── home_screen_test.dart
```

---

## 5. 機能要件

### 5.1 MVP機能（v1.0）

| 機能 | 画面 | 説明 |
|------|------|------|
| 位置情報取得 | ホーム | 現在地を自動取得し住所を表示 |
| 条件入力 | ホーム | 予算・ジャンル・距離を選択 |
| 店舗検索 | - | APIから条件に合う店舗を取得 |
| 店舗提案 | 結果 | ランダムに1店舗を提案表示 |
| 次候補表示 | 結果 | 「これじゃない」で別の店を表示 |
| 地図連携 | 結果 | 「地図で見る」でGoogleマップを開く |
| 店舗決定 | 結果 | 「ここに決めた！」でホットペッパーを開く |

### 5.2 将来機能（v1.1以降）

| 機能 | バージョン | 説明 |
|------|-----------|------|
| 履歴保存 | v1.1 | 選択した店舗をローカルに保存 |
| 履歴画面 | v1.1 | 過去の選択履歴を一覧表示 |
| サーバー同期 | v1.2 | 履歴をサーバーに保存・同期 |
| SNSシェア | v1.2 | 結果をSNSに共有 |
| お気に入り | v1.3 | 店舗をお気に入り登録 |

---

## 6. 画面設計

### 6.1 画面一覧

| 画面 | パス | 説明 |
|------|------|------|
| ホーム | / | 条件入力・検索開始 |
| 結果 | /result | 店舗提案・決定/スキップ |
| 履歴 | /history | 過去の選択履歴（v1.1） |

### 6.2 ホーム画面

```
┌─────────────────────────────┐
│         Kimeshi             │  ← AppBar
│                             │
│  ┌───────────────────────┐  │
│  │     📍 渋谷区神南      │  │  ← 現在地表示
│  └───────────────────────┘  │
│                             │
│  予算                       │  ← セクションタイトル
│  ┌─────┬─────┬─────┬─────┐  │
│  │〜1000│〜2000│〜3000│ なし │  │  ← BudgetSelector
│  └─────┴─────┴─────┴─────┘  │
│                             │
│  ジャンル                   │
│  ┌─────┬─────┬─────┬─────┐  │
│  │ 和食 │ 洋食 │ 中華 │ ALL │  │  ← GenreSelector
│  └─────┴─────┴─────┴─────┘  │
│                             │
│  距離                       │
│  ○──────────●────────○      │  ← RadiusSlider
│  100m      1km       3km    │
│                             │
│  ┌───────────────────────┐  │
│  │     🍽 今日はここ！    │  │  ← 検索ボタン
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 6.3 結果画面

```
┌─────────────────────────────┐
│  ←                          │  ← 戻るボタン
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │      [店舗画像]       │  │  ← RestaurantCard
│  │                       │  │
│  │  居酒屋 kimeshi       │  │
│  │  ジャンル: 居酒屋     │  │
│  │  💰 2000〜3000円       │  │
│  │  📍 渋谷駅から徒歩5分  │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │   🗺 地図で見る        │  │  ← Googleマップ起動
│  └───────────────────────┘  │
│                             │
│  ┌───────────┬───────────┐  │
│  │  これじゃ  │  ここに   │  │
│  │   ない    │  決めた！ │  │  ← アクションボタン
│  └───────────┴───────────┘  │
│                             │
│  残り 15 件                 │  ← 残り件数
└─────────────────────────────┘
```

---

## 7. データモデル

### 7.1 Restaurant

```dart
@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    required String address,
    required double lat,
    required double lng,
    required String budget,
    required String genre,
    String? imageUrl,
    required String hotpepperUrl,
  }) = _Restaurant;
}
```

### 7.2 SearchParams

```dart
@freezed
class SearchParams with _$SearchParams {
  const factory SearchParams({
    required double lat,
    required double lng,
    String? budget,
    String? genre,
    @Default(1000) int radius,
    @Default([]) List<String> excludeIds,
  }) = _SearchParams;
}
```

### 7.3 Location

```dart
@freezed
class Location with _$Location {
  const factory Location({
    required double lat,
    required double lng,
    String? address,
  }) = _Location;
}
```

---

## 8. 状態管理

### 8.1 SearchState

```dart
class SearchState {
  final bool isLoading;           // ローディング中か
  final Restaurant? restaurant;   // 現在表示中の店舗
  final int remainingCount;       // 残り候補数
  final String? errorMessage;     // エラーメッセージ
  final List<String> excludeIds;  // 除外した店舗IDリスト
  final String? selectedBudget;   // 選択中の予算
  final String? selectedGenre;    // 選択中のジャンル
  final int radius;               // 選択中の距離
}
```

### 8.2 SearchViewModel

| メソッド | 説明 |
|---------|------|
| `setBudget(String?)` | 予算を設定 |
| `setGenre(String?)` | ジャンルを設定 |
| `setRadius(int)` | 距離を設定 |
| `search()` | 検索実行（除外リストリセット） |
| `skipAndFindNext()` | 現在の店舗を除外して次を検索 |
| `reset()` | 状態をリセット |

---

## 9. API連携

### 9.1 エンドポイント

| メソッド | パス | 説明 |
|---------|------|------|
| GET | /restaurants/suggest | 店舗を1件提案 |
| GET | /restaurants/:id | 店舗詳細取得 |
| POST | /history | 履歴保存 |
| GET | /history | 履歴一覧取得 |

### 9.2 店舗提案リクエスト

```dart
final response = await apiClient.get(
  '/restaurants/suggest',
  queryParameters: {
    'lat': 35.6812,
    'lng': 139.7671,
    'budget': '2000',
    'genre': 'izakaya',
    'radius': 1000,
    'exclude': 'id1,id2,id3',
  },
);
```

### 9.3 レスポンス

```json
{
  "restaurant": {
    "id": "J001234567",
    "name": "居酒屋 kimeshi",
    "address": "東京都渋谷区...",
    "lat": 35.6812,
    "lng": 139.7671,
    "budget": "2000〜3000円",
    "genre": "居酒屋",
    "image_url": "https://...",
    "hotpepper_url": "https://..."
  },
  "remaining_count": 15
}
```

---

## 10. 環境設定

### 10.1 環境変数

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8787',
  );
}
```

### 10.2 ビルド時の設定

```bash
# 開発
flutter run --dart-define=API_BASE_URL=http://localhost:8787

# 本番
flutter build apk --dart-define=API_BASE_URL=https://kimeshi-api.workers.dev
```

---

## 11. テスト

### 11.1 テスト種別

| 種別 | 対象 | ツール |
|------|------|--------|
| Unit | ViewModel, Service, Repository | mocktail |
| Widget | 個別Widget | flutter_test |
| Integration | 画面遷移・全体フロー | integration_test |

### 11.2 テスト例

```dart
// ViewModel単体テスト
void main() {
  test('検索結果が空の時はnullを返す', () async {
    final container = ProviderContainer(
      overrides: [
        restaurantRepositoryProvider.overrideWithValue(
          MockRestaurantRepository([]),
        ),
      ],
    );

    final viewModel = container.read(searchViewModelProvider.notifier);
    await viewModel.search();

    final state = container.read(searchViewModelProvider);
    expect(state.restaurant, isNull);
  });
}
```

---

## 12. 開発コマンド

```bash
# 依存関係インストール
flutter pub get

# コード生成（Freezed）
dart run build_runner build

# 開発サーバー起動
flutter run

# テスト実行
flutter test

# ビルド（Android）
flutter build apk

# ビルド（iOS）
flutter build ios
```

---

## 13. 開発ロードマップ

### Phase 1: MVP開発（v1.0）

- [x] プロジェクトセットアップ
- [x] ディレクトリ構成作成
- [x] 基本パッケージ導入
- [x] Model定義（Freezed）
- [x] Repository実装
- [x] Service実装
- [x] ViewModel実装
- [x] ホーム画面実装
- [x] 結果画面実装
- [ ] API連携テスト
- [ ] UI調整
- [ ] 単体テスト

### Phase 2: 履歴機能（v1.1）

- [ ] 履歴Repository追加
- [ ] 履歴ViewModel追加
- [ ] 履歴画面実装
- [ ] ローカル保存（SharedPreferences）

### Phase 3: 同期・拡張（v1.2〜）

- [ ] サーバー同期
- [ ] SNSシェア
- [ ] プッシュ通知

---

## 14. 関連ドキュメント

- [バックエンド仕様書](/Users/isobekeito/kimeshi-api/docs/SPECIFICATION.md)
- [Flutter 公式](https://flutter.dev/)
- [Riverpod 公式](https://riverpod.dev/)
- [Freezed パッケージ](https://pub.dev/packages/freezed)
