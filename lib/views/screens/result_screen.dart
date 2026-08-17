import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/responsive.dart';
import '../../models/restaurant.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../widgets/restaurant_card.dart';

class ResultScreen extends HookConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchViewModelProvider);
    final viewModel = ref.read(searchViewModelProvider.notifier);
    final restaurant = state.restaurant;
    final cardSwiperController = useMemoized(() => CardSwiperController());
    final hasShownEmptyDialog = useState(false);

    useEffect(() {
      return cardSwiperController.dispose;
    }, [cardSwiperController]);

    // お店がなくなった時にモーダルを表示
    useEffect(() {
      if (restaurant == null &&
          !state.isLoading &&
          !hasShownEmptyDialog.value) {
        hasShownEmptyDialog.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _showNoRestaurantDialog(context, viewModel);
          }
        });
      }
      return null;
    }, [restaurant, state.isLoading]);

    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('飲食店'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            hasShownEmptyDialog.value = true;
            viewModel.reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.horizontalPadding),
          child: Column(
          children: [
            Expanded(
              child: state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : restaurant == null
                  ? _buildEmptyState(context)
                  : _buildSwipeableCard(
                      context,
                      ref,
                      restaurant,
                      state,
                      viewModel,
                      cardSwiperController,
                    ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context, restaurant, cardSwiperController),
            const SizedBox(height: 8),
            Text(
              restaurant != null
                  ? '残り ${state.remainingCount + 1} 件'
                  : '残り 0 件',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '条件に合うお店は\nありませんでした',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _showNoRestaurantDialog(
    BuildContext context,
    SearchViewModel viewModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('お店がありません'),
        content: const Text('条件に合うお店がなくなりました。\n条件を変えて再度探しますか？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ダイアログを閉じる
            },
            child: const Text('いいえ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // ダイアログを閉じる
              viewModel.reset();
              Navigator.pop(context); // 結果画面を閉じてホームに戻る
            },
            child: const Text('はい'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableCard(
    BuildContext context,
    WidgetRef ref,
    Restaurant restaurant,
    SearchState state,
    SearchViewModel viewModel,
    CardSwiperController controller,
  ) {
    return Column(
      children: [
        // スワイプ操作のヒント
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '左右にスワイプして選択',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // スワイプ可能なカード
        Expanded(
          child: CardSwiper(
            controller: controller,
            cardsCount: 1,
            numberOfCardsDisplayed: 1,
            isLoop: false,
            allowedSwipeDirection: const AllowedSwipeDirection.only(
              left: true,
              right: true,
            ),
            onSwipe: (prevIndex, currentIndex, direction) {
              if (direction == CardSwiperDirection.left) {
                // 左スワイプ: これじゃない
                viewModel.skipAndFindNext();
              } else if (direction == CardSwiperDirection.right) {
                // 右スワイプ: ここに決めた
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    _showActionSheet(context, restaurant);
                  }
                });
              }
              return false; // カードを消さない（viewModelが更新する）
            },
            cardBuilder: (context, index, horizontalPercent, verticalPercent) {
              return Stack(
                children: [
                  RestaurantCard(restaurant: restaurant),
                  // スワイプ中のオーバーレイ
                  if (horizontalPercent != 0)
                    _buildSwipeOverlay(context, horizontalPercent),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Restaurant? restaurant,
    CardSwiperController controller,
  ) {
    final isEnabled = restaurant != null;
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;
    final buttonHeight = responsive.buttonHeight;

    return Row(
      children: [
        // 左スワイプボタン
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: Semantics(
              button: true,
              label: 'これじゃない、次のお店を表示',
              child: OutlinedButton.icon(
                onPressed: isEnabled
                    ? () {
                        HapticFeedback.lightImpact();
                        controller.swipe(CardSwiperDirection.left);
                      }
                    : null,
                icon: const Icon(Icons.close),
                label: const Text('これじゃない'),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 詳細ボタン
        SizedBox(
          height: buttonHeight,
          width: buttonHeight,
          child: IconButton.outlined(
            onPressed: isEnabled
                ? () {
                    HapticFeedback.lightImpact();
                    _openUrl(restaurant.hotpepperUrl);
                  }
                : null,
            icon: const Icon(Icons.info_outline),
            tooltip: '店の詳細',
          ),
        ),
        const SizedBox(width: 8),
        // 右スワイプボタン
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: Semantics(
              button: true,
              label: 'ここに決めた、このお店を選択',
              child: ElevatedButton.icon(
                onPressed: isEnabled
                    ? () {
                        HapticFeedback.mediumImpact();
                        controller.swipe(CardSwiperDirection.right);
                      }
                    : null,
                icon: const Icon(Icons.favorite),
                label: const Text('ここに決めた！'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: isEnabled
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeOverlay(BuildContext context, int horizontalPercent) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLeft = horizontalPercent < 0;
    final progress = horizontalPercent.abs();
    final opacity = (progress / 50).clamp(0.0, 1.0);

    // テーマに合わせた色を使用
    final overlayColor = isLeft ? colorScheme.error : colorScheme.primary;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: overlayColor.withValues(alpha: opacity * 0.3),
        ),
        child: Center(
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: isLeft ? -0.2 : 0.2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: overlayColor, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isLeft ? 'パス' : '決定！',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: overlayColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, Restaurant restaurant) {
    final colorScheme = Theme.of(context).colorScheme;
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'お店が決まりました！',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.name,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _ActionTile(
                icon: Icons.restaurant,
                label: 'ホットペッパーで予約する',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _openUrl(restaurant.hotpepperUrl);
                },
              ),
              _ActionTile(
                icon: Icons.map,
                label: '地図で見る',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _openMap(restaurant.name, restaurant.lat, restaurant.lng);
                },
              ),
              _ActionTile(
                icon: Icons.share,
                label: '友達にシェアする',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _showShareOptions(context, restaurant);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMap(String restaurantName, double lat, double lng) async {
    final encodedName = Uri.encodeComponent(restaurantName);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedName&center=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showShareOptions(BuildContext context, Restaurant restaurant) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'シェア方法を選択',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _ShareOptionTile(
                assetIcon: 'lib/assets/icons/line_icon.png',
                label: 'LINEでシェア',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _shareToLine(restaurant);
                },
              ),
              _ShareOptionTile(
                assetIcon: 'lib/assets/icons/slack_icon.png',
                label: 'Slackでシェア',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _shareToSlack(restaurant);
                },
              ),
              _ShareOptionTile(
                icon: Icons.more_horiz,
                label: 'その他のアプリ',
                iconColor: colorScheme.primary,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  _shareToOther(restaurant);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _buildShareText(Restaurant restaurant) {
    final encodedName = Uri.encodeComponent(restaurant.name);
    final mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedName&center=${restaurant.lat},${restaurant.lng}';

    return '${restaurant.name}\n'
        '${restaurant.address}\n'
        '予算: ${restaurant.budget}\n\n'
        '詳細: ${restaurant.hotpepperUrl}\n'
        '地図: $mapsUrl';
  }

  Future<void> _shareToLine(Restaurant restaurant) async {
    final text = _buildShareText(restaurant);
    final encodedText = Uri.encodeComponent(text);
    final uri = Uri.parse('https://line.me/R/share?text=$encodedText');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // LINEがインストールされていない場合は通常のシェアを使用
      await _shareToOther(restaurant);
    }
  }

  Future<void> _shareToSlack(Restaurant restaurant) async {
    final text = _buildShareText(restaurant);
    final encodedText = Uri.encodeComponent(text);
    // Slack URLスキームでテキストを共有
    final uri = Uri.parse('slack://open?text=$encodedText');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Slackがインストールされていない場合は通常のシェアを使用
      await _shareToOther(restaurant);
    }
  }

  Future<void> _shareToOther(Restaurant restaurant) async {
    final text = _buildShareText(restaurant);
    await SharePlus.instance.share(ShareParams(text: text));
  }
}

class _ShareOptionTile extends StatelessWidget {
  final IconData? icon;
  final String? assetIcon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ShareOptionTile({
    this.icon,
    this.assetIcon,
    required this.label,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    Widget iconWidget;
    if (assetIcon != null) {
      iconWidget = Image.asset(assetIcon!, width: 24, height: 24);
    } else {
      iconWidget = Icon(icon, size: 24, color: color);
    }

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: iconWidget),
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
