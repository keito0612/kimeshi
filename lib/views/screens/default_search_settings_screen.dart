import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/providers.dart';
import '../../viewmodels/search_viewmodel.dart';

class DefaultSearchSettingsScreen extends HookConsumerWidget {
  const DefaultSearchSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.read(settingsRepositoryProvider);

    // 現在の設定値を状態として保持
    final selectedBudget = useState<String?>(settings.defaultBudget);
    final selectedGenre = useState<String?>(settings.defaultGenre);
    final selectedRadius = useState<int>(settings.defaultRadius);

    // 変更があったかどうか
    final hasChanges = useState(false);

    void checkChanges() {
      hasChanges.value = selectedBudget.value != settings.defaultBudget ||
          selectedGenre.value != settings.defaultGenre ||
          selectedRadius.value != settings.defaultRadius;
    }

    Future<void> saveSettings() async {
      HapticFeedback.mediumImpact();
      await settings.setDefaultBudget(selectedBudget.value);
      await settings.setDefaultGenre(selectedGenre.value);
      await settings.setDefaultRadius(selectedRadius.value);

      // SearchViewModelの状態を更新
      ref.read(searchViewModelProvider.notifier).reloadDefaults();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('設定を保存しました'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    tooltip: '戻る',
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'デフォルト検索条件',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // コンテンツ
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '検索画面を開いた時の初期値を設定できます。',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 予算設定
                    _buildSectionCard(
                      context: context,
                      icon: Icons.payments_outlined,
                      iconColor: colorScheme.primary,
                      title: 'デフォルト予算',
                      child: _buildBudgetSelector(
                        context: context,
                        selectedValue: selectedBudget.value,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          selectedBudget.value = value;
                          checkChanges();
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ジャンル設定
                    _buildSectionCard(
                      context: context,
                      icon: Icons.ramen_dining,
                      iconColor: colorScheme.tertiary,
                      title: 'デフォルトジャンル',
                      child: _buildGenreSelector(
                        context: context,
                        selectedValue: selectedGenre.value,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          selectedGenre.value = value;
                          checkChanges();
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 距離設定
                    _buildSectionCard(
                      context: context,
                      icon: Icons.place_outlined,
                      iconColor: colorScheme.tertiary,
                      title: 'デフォルト距離',
                      child: _buildRadiusSlider(
                        context: context,
                        value: selectedRadius.value,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          selectedRadius.value = value;
                          checkChanges();
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 保存ボタン
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: hasChanges.value ? saveSettings : null,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          '保存する',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // リセットボタン
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          await settings.clearDefaults();
                          selectedBudget.value = null;
                          selectedGenre.value = null;
                          selectedRadius.value = AppConstants.defaultRadius;
                          ref
                              .read(searchViewModelProvider.notifier)
                              .reloadDefaults();
                          hasChanges.value = false;

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('デフォルト設定をリセットしました'),
                                backgroundColor: colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('デフォルトに戻す'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSelector({
    required BuildContext context,
    required String? selectedValue,
    required ValueChanged<String?> onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // 「設定なし」オプション
        _buildChip(
          context: context,
          label: '設定なし',
          isSelected: selectedValue == null,
          onTap: () => onSelected(null),
        ),
        ...AppConstants.budgetOptions.map((option) {
          final isSelected = selectedValue == option.value;
          return _buildChip(
            context: context,
            label: option.label,
            isSelected: isSelected,
            onTap: () => onSelected(isSelected ? null : option.value),
          );
        }),
      ],
    );
  }

  Widget _buildGenreSelector({
    required BuildContext context,
    required String? selectedValue,
    required ValueChanged<String?> onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // 「設定なし」オプション
        _buildChip(
          context: context,
          label: '設定なし',
          isSelected: selectedValue == null,
          onTap: () => onSelected(null),
        ),
        ...AppConstants.genreOptions.map((option) {
          final isSelected = selectedValue == option.value;
          return _buildChip(
            context: context,
            label: option.label,
            isSelected: isSelected,
            onTap: () => onSelected(isSelected ? null : option.value),
          );
        }),
      ],
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colorScheme.primary : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 4 : 1,
      shadowColor: isSelected
          ? colorScheme.primary.withValues(alpha: 0.4)
          : colorScheme.shadow.withValues(alpha: 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: colorScheme.primary.withValues(alpha: 0.2),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadiusSlider({
    required BuildContext context,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = colorScheme.tertiary;

    return Column(
      children: [
        // 現在値の表示
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.near_me, color: accentColor, size: 24),
              const SizedBox(width: 8),
              Text(
                _formatRadius(value),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // スライダー
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: accentColor,
            inactiveTrackColor: accentColor.withValues(alpha: 0.2),
            thumbColor: accentColor,
            overlayColor: accentColor.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: value.toDouble(),
            min: AppConstants.minRadius.toDouble(),
            max: AppConstants.maxRadius.toDouble(),
            divisions: 29,
            onChanged: (newValue) => onChanged(newValue.toInt()),
          ),
        ),

        // 範囲表示
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatRadius(AppConstants.minRadius),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              Text(
                _formatRadius(AppConstants.maxRadius),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRadius(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
    return '${meters}m';
  }
}
