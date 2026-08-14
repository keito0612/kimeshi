import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';

class BudgetSelector extends StatelessWidget {
  final List<BudgetOption> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;

  const BudgetSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

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
                    horizontal: 16,
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
                  child: Text(
                    option.label,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
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
