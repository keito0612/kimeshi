import 'package:flutter_test/flutter_test.dart';
import 'package:kimeshi/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = SettingsRepository(prefs);
  });

  group('SettingsRepository', () {
    group('defaultBudget', () {
      test('should return null when not set', () {
        expect(repository.defaultBudget, isNull);
      });

      test('should return value after setting', () async {
        await repository.setDefaultBudget('2000');

        expect(repository.defaultBudget, '2000');
      });

      test('should return null after clearing', () async {
        await repository.setDefaultBudget('2000');
        await repository.setDefaultBudget(null);

        expect(repository.defaultBudget, isNull);
      });
    });

    group('defaultGenre', () {
      test('should return null when not set', () {
        expect(repository.defaultGenre, isNull);
      });

      test('should return value after setting', () async {
        await repository.setDefaultGenre('japanese');

        expect(repository.defaultGenre, 'japanese');
      });

      test('should return null after clearing', () async {
        await repository.setDefaultGenre('japanese');
        await repository.setDefaultGenre(null);

        expect(repository.defaultGenre, isNull);
      });
    });

    group('defaultRadius', () {
      test('should return default value (1000) when not set', () {
        expect(repository.defaultRadius, 1000);
      });

      test('should return value after setting', () async {
        await repository.setDefaultRadius(500);

        expect(repository.defaultRadius, 500);
      });
    });

    group('defaultSearchLimit', () {
      test('should return default value (20) when not set', () {
        expect(repository.defaultSearchLimit, 20);
      });

      test('should return value after setting', () async {
        await repository.setDefaultSearchLimit(30);

        expect(repository.defaultSearchLimit, 30);
      });
    });

    group('clearDefaults', () {
      test('should clear all default settings', () async {
        await repository.setDefaultBudget('2000');
        await repository.setDefaultGenre('japanese');
        await repository.setDefaultRadius(500);
        await repository.setDefaultSearchLimit(30);

        await repository.clearDefaults();

        expect(repository.defaultBudget, isNull);
        expect(repository.defaultGenre, isNull);
        expect(repository.defaultRadius, 1000); // default value
        expect(repository.defaultSearchLimit, 20); // default value
      });
    });

    group('persistence', () {
      test('should persist values across repository instances', () async {
        await repository.setDefaultBudget('3000');
        await repository.setDefaultGenre('italian_french');
        await repository.setDefaultRadius(2000);
        await repository.setDefaultSearchLimit(50);

        // Create new repository with same SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final newRepository = SettingsRepository(prefs);

        expect(newRepository.defaultBudget, '3000');
        expect(newRepository.defaultGenre, 'italian_french');
        expect(newRepository.defaultRadius, 2000);
        expect(newRepository.defaultSearchLimit, 50);
      });
    });
  });
}
