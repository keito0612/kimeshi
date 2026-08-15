import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

/// デフォルト検索条件を保存・読み込みするリポジトリ
class SettingsRepository {
  static const _keyDefaultBudget = 'default_budget';
  static const _keyDefaultGenre = 'default_genre';
  static const _keyDefaultRadius = 'default_radius';
  static const _keyDefaultSearchLimit = 'default_search_limit';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // デフォルト予算
  String? get defaultBudget => _prefs.getString(_keyDefaultBudget);
  Future<void> setDefaultBudget(String? value) async {
    if (value == null) {
      await _prefs.remove(_keyDefaultBudget);
    } else {
      await _prefs.setString(_keyDefaultBudget, value);
    }
  }

  // デフォルトジャンル
  String? get defaultGenre => _prefs.getString(_keyDefaultGenre);
  Future<void> setDefaultGenre(String? value) async {
    if (value == null) {
      await _prefs.remove(_keyDefaultGenre);
    } else {
      await _prefs.setString(_keyDefaultGenre, value);
    }
  }

  // デフォルト距離
  int get defaultRadius =>
      _prefs.getInt(_keyDefaultRadius) ?? AppConstants.defaultRadius;
  Future<void> setDefaultRadius(int value) async {
    await _prefs.setInt(_keyDefaultRadius, value);
  }

  // デフォルト検索上限数
  int get defaultSearchLimit =>
      _prefs.getInt(_keyDefaultSearchLimit) ?? AppConstants.defaultSearchLimit;
  Future<void> setDefaultSearchLimit(int value) async {
    await _prefs.setInt(_keyDefaultSearchLimit, value);
  }

  // すべてのデフォルト設定をクリア
  Future<void> clearDefaults() async {
    await _prefs.remove(_keyDefaultBudget);
    await _prefs.remove(_keyDefaultGenre);
    await _prefs.remove(_keyDefaultRadius);
    await _prefs.remove(_keyDefaultSearchLimit);
  }
}
