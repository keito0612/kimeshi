import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_constants.dart';

/// レスポンシブ対応のバナー広告ウィジェット
/// すべてのiPhoneサイズに対応するアダプティブバナーを使用
class BannerAdWidget extends HookWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerAd = useState<BannerAd?>(null);
    final isLoaded = useState(false);

    // MediaQueryはuseEffectの外で取得する
    final screenWidth = MediaQuery.of(context).size.width.truncate();

    useEffect(() {
      Future<void> loadAd() async {
        // 既に広告がロードされている場合はスキップ
        if (bannerAd.value != null) return;

        final adSize = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(screenWidth);

        if (adSize == null) {
          debugPrint('アダプティブバナーサイズの取得に失敗しました');
          return;
        }

        final ad = BannerAd(
          adUnitId: AppConstants.bannerAdUnitId,
          size: adSize,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              isLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error) {
              debugPrint('バナー広告の読み込みに失敗: ${error.message}');
              ad.dispose();
              bannerAd.value = null;
            },
            onAdOpened: (ad) {
              debugPrint('バナー広告が開かれました');
            },
            onAdClosed: (ad) {
              debugPrint('バナー広告が閉じられました');
            },
          ),
        );

        bannerAd.value = ad;
        await ad.load();
      }

      loadAd();

      // クリーンアップ: 広告をdispose
      return () {
        bannerAd.value?.dispose();
      };
    }, [screenWidth]);

    if (!isLoaded.value || bannerAd.value == null) {
      // 広告がロードされるまでスペースを確保
      return const SizedBox(height: 50);
    }

    return SafeArea(
      child: SizedBox(
        width: bannerAd.value!.size.width.toDouble(),
        height: bannerAd.value!.size.height.toDouble(),
        child: AdWidget(ad: bannerAd.value!),
      ),
    );
  }
}
