# Kimeshi

**今日のご飯、ここに決めた！**

## 概要

Kimeshiは、現在地周辺の飲食店をランダムに提案するモバイルアプリです。「今日何食べよう？」という日常の悩みを、スワイプ操作で直感的に解決します。予算・ジャンル・距離を設定するだけで、あなたにぴったりのお店を提案します。

## 開発背景

「今日のランチどこにしよう」「飲み会のお店が決まらない」—そんな経験は誰にでもあるはずです。グルメサイトで検索しても、選択肢が多すぎて結局決められない。そんな「決断疲れ」を解消するために、Kimeshiは生まれました。

アプリがランダムにお店を提案し、ユーザーは「ここにする」か「パス」かを選ぶだけ。シンプルな操作で、お店選びのストレスから解放されます。

## 画面イメージ

| ホーム画面 | 結果画面 | 設定画面 |
|:---:|:---:|:---:|
| 予算・ジャンル・距離を選択 | スワイプでお店を選択 | デフォルト条件を設定 |

## 主な機能

- **条件設定検索**: 予算、ジャンル、距離を指定して周辺の飲食店を検索
- **スワイプ選択**: 右スワイプで「決定」、左スワイプで「パス」の直感的な操作
- **お店詳細表示**: 店名、住所、予算、ジャンルをカード形式で表示
- **外部連携**:
  - ホットペッパーで予約
  - Google Mapsで場所を確認
  - LINE / Slack / その他アプリでシェア
- **デフォルト設定**: よく使う検索条件を保存して次回以降自動適用

## 使用技術

| カテゴリ | 技術 |
|---------|-----|
| フレームワーク | Flutter 3.47.0 |
| 言語 | Dart 3.10.4 |
| 状態管理 | Riverpod + Flutter Hooks |
| HTTP通信 | Dio |
| 位置情報 | Geolocator, Geocoding |
| データ永続化 | SharedPreferences |
| コード生成 | Freezed, json_serializable |
| UIコンポーネント | flutter_card_swiper |
| 外部連携 | url_launcher, share_plus |
| テスト | flutter_test, mocktail |
| CI/CD | GitHub Actions |

## アーキテクチャ

本アプリはクリーンアーキテクチャをベースとした構成を採用しています。

```
┌─────────────────────────────────────────────────────────┐
│                     Views (UI)                          │
│              screens / widgets                          │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│                  ViewModels                             │
│           Riverpod StateNotifier                        │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│                   Services                              │
│            ビジネスロジック                               │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│                 Repositories                            │
│         データアクセス（API / ローカル）                    │
└─────────────────────────────────────────────────────────┘
```

- **Views**: UIの描画とユーザー操作の受付
- **ViewModels**: 状態管理とUIロジック
- **Services**: ビジネスロジックの実装
- **Repositories**: 外部API・ローカルストレージとのデータやり取り
- **Models**: Freezedによる不変データクラス

## ローカル環境での起動方法

### 前提条件

- Flutter SDK 3.47.0以上
- Dart SDK 3.10.4以上
- Xcode（iOS開発の場合）
- Android Studio（Android開発の場合）

### セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/your-username/kimeshi.git
cd kimeshi

# 依存関係をインストール
flutter pub get

# コード生成（Freezed / json_serializable）
dart run build_runner build --delete-conflicting-outputs

# iOSシミュレータで起動
flutter run -d ios

# Androidエミュレータで起動
flutter run -d android
```

### テスト実行

```bash
# 全テスト実行
flutter test

# カバレッジ付きで実行
flutter test --coverage

# 静的解析
flutter analyze
```

## ディレクトリ構成

```
lib/
├── main.dart                    # アプリケーションエントリーポイント
├── core/
│   ├── api/
│   │   └── api_client.dart      # HTTP通信クライアント
│   ├── constants/
│   │   └── app_constants.dart   # 定数定義（予算/ジャンル選択肢等）
│   └── exceptions/
│       └── app_exception.dart   # カスタム例外クラス
├── models/
│   ├── restaurant.dart          # 飲食店モデル
│   ├── location.dart            # 位置情報モデル
│   └── search_params.dart       # 検索パラメータモデル
├── repositories/
│   ├── i_restaurant_repository.dart    # 飲食店リポジトリインターフェース
│   ├── restaurant_repository.dart      # 飲食店リポジトリ実装
│   ├── i_location_repository.dart      # 位置情報リポジトリインターフェース
│   ├── location_repository.dart        # 位置情報リポジトリ実装
│   └── settings_repository.dart        # 設定リポジトリ
├── services/
│   ├── i_restaurant_search_service.dart  # 検索サービスインターフェース
│   └── restaurant_search_service.dart    # 検索サービス実装
├── viewmodels/
│   ├── search_viewmodel.dart    # 検索画面のViewModel
│   └── providers.dart           # Riverpodプロバイダ定義
├── views/
│   ├── screens/
│   │   ├── main_screen.dart              # メイン画面（ナビゲーション）
│   │   ├── home_screen.dart              # ホーム画面（検索条件設定）
│   │   ├── result_screen.dart            # 結果画面（スワイプ選択）
│   │   ├── settings_screen.dart          # 設定画面
│   │   ├── default_search_settings_screen.dart  # デフォルト検索設定
│   │   └── about_screen.dart             # アプリについて
│   └── widgets/
│       ├── restaurant_card.dart    # 飲食店カードウィジェット
│       ├── budget_selector.dart    # 予算選択ウィジェット
│       ├── genre_selector.dart     # ジャンル選択ウィジェット
│       └── radius_slider.dart      # 距離スライダーウィジェット
└── assets/
    ├── icons/                    # アイコン画像
    └── app_icons/                # アプリアイコン

test/
├── models/                       # モデルテスト
├── repositories/                 # リポジトリテスト
├── services/                     # サービステスト
├── viewmodels/                   # ViewModelテスト
└── widget_test.dart              # ウィジェットテスト
```
