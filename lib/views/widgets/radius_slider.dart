import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';

class RadiusSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const RadiusSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // テーマのtertiaryカラーを使用（オレンジ系）
    final accentColor = colorScheme.tertiary;

    return Semantics(
      label: '距離スライダー、現在${_formatRadius(value)}',
      value: _formatRadius(value),
      child: Column(
        children: [
          // 現在値の表示（大きく目立つように）
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
              onChanged: (newValue) {
                HapticFeedback.selectionClick();
                onChanged(newValue.toInt());
              },
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
      ),
    );
  }

  String _formatRadius(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
    return '${meters}m';
  }
}
