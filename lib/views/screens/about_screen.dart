import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('アプリについて')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // アプリアイコンと名前
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.restaurant_menu,
                color: colorScheme.primary,
                size: 64,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kimeshi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'バージョン 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // アプリ説明
            _buildSection(
              context: context,
              title: 'Kimeshiとは',
              content:
                  'Kimeshiは、今いる場所の近くにあるお店をサクサク探せるグルメアプリです。\n\n'
                  '「今日のランチどこにしよう？」「飲み会のお店が決まらない...」\n'
                  'そんな時、Kimeshiがあなたにピッタリのお店を提案します。',
            ),
            const SizedBox(height: 20),

            // 主な機能
            _buildSection(
              context: context,
              title: '主な機能',
              child: Column(
                children: [
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.place,
                    title: '現在地から検索',
                    description: 'GPSを使って今いる場所の周辺のお店を検索',
                  ),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.payments_outlined,
                    title: '予算で絞り込み',
                    description: '予算に合ったお店だけを表示',
                  ),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.ramen_dining,
                    title: 'ジャンルで絞り込み',
                    description: '和食、中華、イタリアンなど好みのジャンルで検索',
                  ),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.swipe,
                    title: 'スワイプで選ぶ',
                    description: '気になるお店をスワイプで簡単に選択',
                  ),
                  _buildFeatureItem(
                    context: context,
                    icon: Icons.share,
                    title: 'かんたん共有',
                    description: '選んだお店を友達やグループにすぐ共有',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 使い方
            _buildSection(
              context: context,
              title: '使い方',
              content:
                  '1. 予算・ジャンル・距離を選択\n'
                  '2.「お店を探す」ボタンをタップ\n'
                  '3. 表示されたお店が気に入らなければ左スワイプ\n'
                  '4. 気に入ったら右スワイプで決定！\n'
                  '5. お店の詳細を確認して、さっそく行こう',
            ),
            const SizedBox(height: 32),

            // 著作権表記
            Text(
              '© 2026 Kimeshi',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    String? content,
    Widget? child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ?child,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
