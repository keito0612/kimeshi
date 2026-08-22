import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/budget_selector.dart';
import '../widgets/genre_selector.dart';
import '../widgets/radius_slider.dart';
import 'result_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchViewModelProvider);
    final viewModel = ref.read(searchViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    // バリデーションエラーの状態
    final showBudgetError = useState(false);
    final showGenreError = useState(false);

    // 選択されたらエラーをクリア
    useEffect(() {
      if (state.selectedBudget != null) {
        showBudgetError.value = false;
      }
      return null;
    }, [state.selectedBudget]);

    useEffect(() {
      if (state.selectedGenre != null) {
        showGenreError.value = false;
      }
      return null;
    }, [state.selectedGenre]);

    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // メインコンテンツ
                  SliverPadding(
              padding: EdgeInsets.fromLTRB(
                responsive.horizontalPadding,
                12,
                responsive.horizontalPadding,
                20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 予算カード
                  _buildSectionCard(
                    context: context,
                    icon: Icons.payments_outlined,
                    iconColor: colorScheme.primary,
                    title: '予算',
                    child: BudgetSelector(
                      options: AppConstants.budgetOptions,
                      selectedValue: state.selectedBudget,
                      onSelected: viewModel.setBudget,
                    ),
                    showError: showBudgetError.value,
                    errorMessage: '予算を選択してください',
                  ),

                  SizedBox(height: responsive.isSmallScreen ? 12 : 16),

                  // ジャンルカード
                  _buildSectionCard(
                    context: context,
                    icon: Icons.ramen_dining,
                    iconColor: colorScheme.tertiary,
                    title: 'ジャンル',
                    child: GenreSelector(
                      options: AppConstants.genreOptions,
                      selectedValue: state.selectedGenre,
                      onSelected: viewModel.setGenre,
                    ),
                    showError: showGenreError.value,
                    errorMessage: 'ジャンルを選択してください',
                  ),

                  SizedBox(height: responsive.isSmallScreen ? 12 : 16),

                  // 距離カード
                  _buildSectionCard(
                    context: context,
                    icon: Icons.place_outlined,
                    iconColor: colorScheme.tertiary,
                    title: '距離',
                    child: RadiusSlider(
                      value: state.radius,
                      onChanged: viewModel.setRadius,
                    ),
                  ),

                  SizedBox(height: responsive.isSmallScreen ? 24 : 32),

                  // 検索ボタン
                  Semantics(
                    button: true,
                    label: '今日はここ！検索ボタン',
                    child: Container(
                      height: responsive.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.tertiary],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: colorScheme.onPrimary.withValues(
                            alpha: 0.3,
                          ),
                          highlightColor: colorScheme.onPrimary.withValues(
                            alpha: 0.1,
                          ),
                          onTap: state.isLoading
                              ? null
                              : () async {
                                  HapticFeedback.mediumImpact();
                                  bool hasError = false;

                                  if (state.selectedBudget == null) {
                                    showBudgetError.value = true;
                                    hasError = true;
                                  }

                                  if (state.selectedGenre == null) {
                                    showGenreError.value = true;
                                    hasError = true;
                                  }

                                  if (hasError) {
                                    HapticFeedback.heavyImpact();
                                    return;
                                  }

                                  await viewModel.search();
                                  if (context.mounted) {
                                    final currentState = ref.read(
                                      searchViewModelProvider,
                                    );
                                    if (currentState.restaurant != null) {
                                      HapticFeedback.lightImpact();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ResultScreen(),
                                        ),
                                      );
                                    } else if (currentState.errorMessage !=
                                        null) {
                                      HapticFeedback.heavyImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            currentState.errorMessage!,
                                          ),
                                          backgroundColor: colorScheme.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: Center(
                            child: state.isLoading
                                ? SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: colorScheme.onPrimary,
                                        size: responsive.iconSize,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '今日はここ！',
                                        style: TextStyle(
                                          fontSize: responsive.scaledFontSize(20),
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onPrimary,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ]),
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

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
    bool showError = false,
    String? errorMessage,
  }) {
    final responsive = context.responsive;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(responsive.isSmallScreen ? 16 : 20),
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
                  child: Icon(icon, color: iconColor, size: responsive.iconSize),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.scaledFontSize(18),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.isSmallScreen ? 12 : 16),
            child,
            if (showError && errorMessage != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
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
}
