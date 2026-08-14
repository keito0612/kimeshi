import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'default_search_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // コンパクトヘッダー
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '設定',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 検索設定セクション
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '検索設定',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.tune,
                        iconColor: colorScheme.primary,
                        title: 'デフォルト検索条件',
                        subtitle: '予算・ジャンル・距離の初期値',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DefaultSearchSettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // アプリ情報セクション
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'アプリ情報',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.info_outline,
                        iconColor: colorScheme.tertiary,
                        title: 'アプリについて',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          showAboutDialog(
                            context: context,
                            applicationName: 'Kimeshi',
                            applicationVersion: '1.0.0',
                            applicationIcon: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                color: colorScheme.primary,
                                size: 40,
                              ),
                            ),
                            applicationLegalese: '© 2024 Kimeshi',
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.description_outlined,
                        iconColor: colorScheme.tertiary,
                        title: '利用規約',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          // TODO: 利用規約画面へ遷移
                        },
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.privacy_tip_outlined,
                        iconColor: colorScheme.tertiary,
                        title: 'プライバシーポリシー',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          // TODO: プライバシーポリシー画面へ遷移
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: title,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
