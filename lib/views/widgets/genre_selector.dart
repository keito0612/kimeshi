import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';

class GenreSelector extends StatelessWidget {
  final List<GenreOption> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  const GenreSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  // ジャンルごとのアイコンマッピング
  IconData _getGenreIcon(String label) {
    switch (label) {
      case '和食':
        return Icons.rice_bowl;
      case '洋食':
        return Icons.dinner_dining;
      case '中華':
        return Icons.ramen_dining;
      case 'イタリアン':
        return Icons.local_pizza;
      case 'フレンチ':
        return Icons.restaurant;
      case '焼肉':
        return Icons.outdoor_grill;
      case '寿司':
        return Icons.set_meal;
      case 'ラーメン':
        return Icons.ramen_dining;
      case 'カフェ':
        return Icons.coffee;
      case '居酒屋':
        return Icons.sports_bar;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selectedValue == option.value;
        return Semantics(
          selected: isSelected,
          button: true,
          label: '${option.label}${isSelected ? "、選択中" : ""}',
          child: AnimatedScale(
            scale: isSelected ? 1.02 : 1.0,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 150),
            child: Material(
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: isSelected ? 4 : 1,
              shadowColor: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.4)
                  : colorScheme.shadow.withValues(alpha: 0.1),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: colorScheme.primary.withValues(alpha: 0.2),
                highlightColor: colorScheme.primary.withValues(alpha: 0.1),
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelected(isSelected ? null : option.value);
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getGenreIcon(option.label),
                        size: 18,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        option.label,
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
