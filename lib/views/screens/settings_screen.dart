import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/responsive.dart';
import '../widgets/banner_ad_widget.dart';
import 'about_screen.dart';
import 'default_search_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;
    final horizontalPadding = responsive.horizontalPadding;

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
            // 検索設定セクション
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                8,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '検索設定',
                  style: TextStyle(
                    fontSize: responsive.scaledFontSize(14),
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                16,
              ),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.tune,
                        iconColor: colorScheme.tertiary,
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
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                8,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'アプリ情報',
                  style: TextStyle(
                    fontSize: responsive.scaledFontSize(14),
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                20,
              ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
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
                        title: '利用規約・プライバシーポリシー',
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          final url = Uri.parse(
                            "https://keito0612.github.io/kimeshi_privacy_policy/",
                          );
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
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
                        icon: Icons.phone,
                        iconColor: colorScheme.tertiary,
                        title: 'お問い合わせ',
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          final uri = Uri.parse(
                            'https://docs.google.com/forms/d/e/1FAIpQLSfLzHcI7CO4pd9DbN7CaxhInsgP_XmTHE53EESKlF9XsMej-Q/viewform?usp=publish-editor',
                          );
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
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
      // バナー広告
      const BannerAdWidget(),
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
    final responsive = context.responsive;

    return Semantics(
      button: true,
      label: title,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: responsive.isSmallScreen ? 12 : 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: responsive.iconSize - 2),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.scaledFontSize(16),
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: responsive.scaledFontSize(13),
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
