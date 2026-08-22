import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 広告サービス
/// AdMobの初期化とApp Tracking Transparency (ATT) の管理を行う
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;

  /// AdMobを初期化する
  Future<void> initialize() async {
    if (_isInitialized) return;

    // iOSの場合はATTダイアログを表示
    if (Platform.isIOS) {
      await _requestTrackingAuthorization();
    }

    // AdMobを初期化
    await MobileAds.instance.initialize();

    // テストデバイスの設定（デバッグビルドのみ）
    if (kDebugMode) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: []),
      );
    }

    _isInitialized = true;
  }

  /// App Tracking Transparency (ATT) の許可をリクエスト
  Future<void> _requestTrackingAuthorization() async {
    // ATTのステータスを確認
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    // まだ許可をリクエストしていない場合のみダイアログを表示
    if (status == TrackingStatus.notDetermined) {
      // iOS 14以降では少し遅延させてから表示する必要がある
      await Future.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  /// 現在のトラッキング許可状態を取得
  Future<TrackingStatus> getTrackingStatus() async {
    if (Platform.isIOS) {
      return await AppTrackingTransparency.trackingAuthorizationStatus;
    }
    // Androidの場合は常に許可とみなす
    return TrackingStatus.authorized;
  }
}
